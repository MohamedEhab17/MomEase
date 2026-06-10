import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_group_entity.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/get_vaccinations_usecase.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/update_vaccination_status_usecase.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/get_upcoming_vaccinations_usecase.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/get_overdue_vaccinations_usecase.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/get_completed_vaccinations_usecase.dart';
import 'package:new_mama/feature/baby_track/domain/usecase/mark_vaccination_taken_usecase.dart';
import 'vaccinations_state.dart';

@injectable
class VaccinationsCubit extends SafeCubit<VaccinationsState> {
  final GetVaccinationsUseCase _getVaccinations;
  final UpdateVaccinationStatusUseCase _updateVaccinationStatus;
  final GetUpcomingVaccinationsUseCase _getUpcomingVaccinations;
  final GetOverdueVaccinationsUseCase _getOverdueVaccinations;
  final GetCompletedVaccinationsUseCase _getCompletedVaccinations;
  final MarkVaccinationTakenUseCase _markVaccinationTaken;

  VaccinationsCubit(
    this._getVaccinations,
    this._updateVaccinationStatus,
    this._getUpcomingVaccinations,
    this._getOverdueVaccinations,
    this._getCompletedVaccinations,
    this._markVaccinationTaken,
  ) : super(VaccinationsInitial());

  void fetchVaccinations(int childId) {
    safeEmit(VaccinationsLoading());
    cancelableOperation(_getVaccinations(childId)).value.then((dynamic res) {
      final result = res as Either<Failure, List<VaccineGroupEntity>>;
      result.fold(
        (failure) => safeEmit(VaccinationsError(failure.message)),
        (data) => safeEmit(VaccinationsLoaded(vaccineGroups: data)),
      );
    });
  }

  void fetchUpcomingVaccinations(int childId, {int daysAhead = 30}) {
    safeEmit(VaccinationsLoading());
    cancelableOperation(_getUpcomingVaccinations(childId, daysAhead)).value.then((dynamic res) {
      final result = res as Either<Failure, List<VaccineEntity>>;
      result.fold(
        (failure) => safeEmit(VaccinationsError(failure.message)),
        (data) => safeEmit(VaccinationsLoaded(upcomingVaccines: data)),
      );
    });
  }

  void fetchOverdueVaccinations(int childId) {
    safeEmit(VaccinationsLoading());
    cancelableOperation(_getOverdueVaccinations(childId)).value.then((dynamic res) {
      final result = res as Either<Failure, List<VaccineEntity>>;
      result.fold(
        (failure) => safeEmit(VaccinationsError(failure.message)),
        (data) => safeEmit(VaccinationsLoaded(overdueVaccines: data)),
      );
    });
  }

  void fetchCompletedVaccinations(int childId) {
    safeEmit(VaccinationsLoading());
    cancelableOperation(_getCompletedVaccinations(childId)).value.then((dynamic res) {
      final result = res as Either<Failure, List<VaccineEntity>>;
      result.fold(
        (failure) => safeEmit(VaccinationsError(failure.message)),
        (data) => safeEmit(VaccinationsLoaded(completedVaccines: data)),
      );
    });
  }

  /// Premium helper to fetch all types of vaccination data in parallel for a child
  void fetchAllVaccinationData(int childId, {int daysAhead = 30}) {
    safeEmit(VaccinationsLoading());
    
    Future.wait([
      _getVaccinations(childId),
      _getUpcomingVaccinations(childId, daysAhead),
      _getOverdueVaccinations(childId),
      _getCompletedVaccinations(childId),
    ]).then((results) {
      final groupsRes = results[0] as Either<Failure, List<VaccineGroupEntity>>;
      final upcomingRes = results[1] as Either<Failure, List<VaccineEntity>>;
      final overdueRes = results[2] as Either<Failure, List<VaccineEntity>>;
      final completedRes = results[3] as Either<Failure, List<VaccineEntity>>;

      String? errorMsg;
      List<VaccineGroupEntity> groups = [];
      List<VaccineEntity> upcoming = [];
      List<VaccineEntity> overdue = [];
      List<VaccineEntity> completed = [];

      groupsRes.fold((f) => errorMsg = f.message, (d) => groups = d);
      upcomingRes.fold((f) => errorMsg = f.message, (d) => upcoming = d);
      overdueRes.fold((f) => errorMsg = f.message, (d) => overdue = d);
      completedRes.fold((f) => errorMsg = f.message, (d) => completed = d);

      if (errorMsg != null) {
        safeEmit(VaccinationsError(errorMsg!));
      } else {
        safeEmit(VaccinationsLoaded(
          vaccineGroups: groups,
          upcomingVaccines: upcoming,
          overdueVaccines: overdue,
          completedVaccines: completed,
        ));
      }
    });
  }

  void updateVaccineStatus(
    int childId,
    int vaccineId, {
    required String status,
    DateTime? takenDate,
  }) {
    final currentState = state;
    if (currentState is! VaccinationsLoaded) return;

    safeEmit(currentState.copyWith(
      updatingVaccineId: vaccineId,
      errorMessage: null,
      successMessage: null,
    ));

    cancelableOperation(_updateVaccinationStatus(
      childId: childId,
      id: vaccineId,
      status: status,
      takenDate: takenDate,
    )).value.then((dynamic res) {
      final result = res as Either<Failure, VaccineEntity>;
      result.fold(
        (failure) {
          safeEmit(currentState.copyWith(
            updatingVaccineId: null,
            errorMessage: failure.message,
          ));
        },
        (updatedVaccine) {
          final updatedState = _mapUpdatedVaccine(currentState, updatedVaccine);
          safeEmit(updatedState.copyWith(
            successMessage: 'Vaccination updated successfully',
          ));
        },
      );
    });
  }

  void markVaccineAsTaken(
    int childId,
    int vaccineId, {
    required String status,
    DateTime? takenDate,
  }) {
    final currentState = state;
    if (currentState is! VaccinationsLoaded) return;

    safeEmit(currentState.copyWith(
      updatingVaccineId: vaccineId,
      errorMessage: null,
      successMessage: null,
    ));

    cancelableOperation(_markVaccinationTaken(
      childId: childId,
      id: vaccineId,
      status: status,
      takenDate: takenDate,
    )).value.then((dynamic res) {
      final result = res as Either<Failure, VaccineEntity>;
      result.fold(
        (failure) {
          safeEmit(currentState.copyWith(
            updatingVaccineId: null,
            errorMessage: failure.message,
          ));
        },
        (updatedVaccine) {
          final updatedState = _mapUpdatedVaccine(currentState, updatedVaccine);
          safeEmit(updatedState.copyWith(
            successMessage: 'Vaccination marked as taken successfully',
          ));
        },
      );
    });
  }

  VaccinationsLoaded _mapUpdatedVaccine(VaccinationsLoaded currentState, VaccineEntity updated) {
    // 1. Map groups
    final updatedGroups = currentState.vaccineGroups.map((group) {
      final vaccines = group.vaccines.map((v) {
        if (v.childVaccineId == updated.childVaccineId) {
          return updated;
        }
        return v;
      }).toList();
      return group.copyWith(vaccines: vaccines);
    }).toList();

    final isDone = updated.status.toLowerCase() == 'done' || 
                   updated.status.toLowerCase() == 'completed' || 
                   updated.takenDate != null;

    // 2. Map upcoming list
    final List<VaccineEntity> updatedUpcoming;
    if (isDone) {
      updatedUpcoming = currentState.upcomingVaccines.where((v) => v.childVaccineId != updated.childVaccineId).toList();
    } else {
      updatedUpcoming = currentState.upcomingVaccines.map((v) {
        if (v.childVaccineId == updated.childVaccineId) {
          return updated;
        }
        return v;
      }).toList();
    }

    // 3. Map overdue list
    final List<VaccineEntity> updatedOverdue;
    if (isDone) {
      updatedOverdue = currentState.overdueVaccines.where((v) => v.childVaccineId != updated.childVaccineId).toList();
    } else {
      updatedOverdue = currentState.overdueVaccines.map((v) {
        if (v.childVaccineId == updated.childVaccineId) {
          return updated;
        }
        return v;
      }).toList();
    }

    // 4. Map completed list
    final List<VaccineEntity> updatedCompleted;
    if (isDone) {
      final baseList = currentState.completedVaccines.where((v) => v.childVaccineId != updated.childVaccineId).toList();
      updatedCompleted = [...baseList, updated];
    } else {
      updatedCompleted = currentState.completedVaccines.map((v) {
        if (v.childVaccineId == updated.childVaccineId) {
          return updated;
        }
        return v;
      }).toList();
    }

    return currentState.copyWith(
      vaccineGroups: updatedGroups,
      upcomingVaccines: updatedUpcoming,
      overdueVaccines: updatedOverdue,
      completedVaccines: updatedCompleted,
      updatingVaccineId: null,
    );
  }
}
