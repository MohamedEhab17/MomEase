import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/error_handler.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/core/network/network_info.dart';
import 'package:new_mama/feature/baby_track/data/datasources/vaccination_remote_data_source_contract.dart';
import 'package:new_mama/feature/baby_track/data/models/update_vaccination_request_model.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_group_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/vaccination_repository.dart';

@LazySingleton(as: VaccinationRepository)
class VaccinationRepositoryImpl implements VaccinationRepository {
  final VaccinationRemoteDataSourceContract _remoteDataSource;
  final NetworkInfo _networkInfo;

  VaccinationRepositoryImpl(
    this._remoteDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, List<VaccineGroupEntity>>> getVaccinations(int childId) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getVaccinations(childId);
        final entities = models.map((e) => e.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, VaccineEntity>> getVaccinationById(int childId, int id) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getVaccinationById(childId, id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, VaccineEntity>> updateVaccinationStatus(
    int childId,
    int id, {
    required String status,
    DateTime? takenDate,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final body = UpdateVaccinationRequestModel(status: status, takenDate: takenDate);
        final model = await _remoteDataSource.updateVaccinationStatus(childId, id, body);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, List<VaccineEntity>>> getUpcomingVaccinations(int childId, int daysAhead) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getUpcomingVaccinations(childId, daysAhead);
        final entities = models.map((e) => e.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, List<VaccineEntity>>> getOverdueVaccinations(int childId) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getOverdueVaccinations(childId);
        final entities = models.map((e) => e.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, List<VaccineEntity>>> getCompletedVaccinations(int childId) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getCompletedVaccinations(childId);
        final entities = models.map((e) => e.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, VaccineEntity>> markVaccinationAsTaken(
    int childId,
    int id, {
    required String status,
    DateTime? takenDate,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final body = UpdateVaccinationRequestModel(status: status, takenDate: takenDate);
        final model = await _remoteDataSource.markVaccinationAsTaken(childId, id, body);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }
}
