import 'package:equatable/equatable.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_group_entity.dart';

abstract class VaccinationsState extends Equatable {
  const VaccinationsState();

  @override
  List<Object?> get props => [];
}

class VaccinationsInitial extends VaccinationsState {}

class VaccinationsLoading extends VaccinationsState {}

class VaccinationsLoaded extends VaccinationsState {
  final List<VaccineGroupEntity> vaccineGroups;
  final List<VaccineEntity> upcomingVaccines;
  final List<VaccineEntity> overdueVaccines;
  final List<VaccineEntity> completedVaccines;
  final int? updatingVaccineId;
  final String? errorMessage;
  final String? successMessage;

  const VaccinationsLoaded({
    this.vaccineGroups = const [],
    this.upcomingVaccines = const [],
    this.overdueVaccines = const [],
    this.completedVaccines = const [],
    this.updatingVaccineId,
    this.errorMessage,
    this.successMessage,
  });

  VaccinationsLoaded copyWith({
    List<VaccineGroupEntity>? vaccineGroups,
    List<VaccineEntity>? upcomingVaccines,
    List<VaccineEntity>? overdueVaccines,
    List<VaccineEntity>? completedVaccines,
    int? updatingVaccineId,
    String? errorMessage,
    String? successMessage,
  }) {
    return VaccinationsLoaded(
      vaccineGroups: vaccineGroups ?? this.vaccineGroups,
      upcomingVaccines: upcomingVaccines ?? this.upcomingVaccines,
      overdueVaccines: overdueVaccines ?? this.overdueVaccines,
      completedVaccines: completedVaccines ?? this.completedVaccines,
      updatingVaccineId: updatingVaccineId, // note: explicitly cleared by passing null
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        vaccineGroups,
        upcomingVaccines,
        overdueVaccines,
        completedVaccines,
        updatingVaccineId,
        errorMessage,
        successMessage,
      ];
}

class VaccinationsError extends VaccinationsState {
  final String message;

  const VaccinationsError(this.message);

  @override
  List<Object?> get props => [message];
}
