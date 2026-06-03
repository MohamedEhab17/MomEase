import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/error_handler.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/core/network/network_info.dart';
import 'package:new_mama/feature/baby_track/data/datasources/sleep_remote_data_source_contract.dart';
import 'package:new_mama/feature/baby_track/data/models/add_sleep_record_request_model.dart';
import 'package:new_mama/feature/baby_track/domain/entities/sleep_record_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_sleep_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_sleep_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/sleep_statistics_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/sleep_repository.dart';

@LazySingleton(as: SleepRepository)
class SleepRepositoryImpl implements SleepRepository {
  final SleepRemoteDataSourceContract _remoteDataSource;
  final NetworkInfo _networkInfo;

  SleepRepositoryImpl(
    this._remoteDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, SleepRecordEntity>> addSleepRecord(
    int childId,
    AddSleepRecordRequestModel request,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.addSleepRecord(childId, request);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, WeeklySleepRecordsEntity>> getWeeklySleepRecords(
      int childId) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getWeeklySleepRecords(childId);
        return Right(model);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, MonthlySleepRecordsEntity>> getMonthlySleepRecords(
      int childId) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getMonthlySleepRecords(childId);
        return Right(model);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, SleepStatisticsEntity>> getSleepStatistics(
      int childId) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getSleepStatistics(childId);
        return Right(model);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, List<SleepRecordEntity>>> getSleepRecords(int childId) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getSleepRecords(childId);
        final entities = models.map((m) => m.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSleepRecord(int childId, int id) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteSleepRecord(childId, id);
        return const Right(null);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }
}
