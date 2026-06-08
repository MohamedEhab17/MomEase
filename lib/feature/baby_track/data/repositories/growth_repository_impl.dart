import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/error_handler.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/core/network/network_info.dart';
import 'package:new_mama/feature/baby_track/data/datasources/growth_remote_data_source_contract.dart';
import 'package:new_mama/feature/baby_track/data/models/add_growth_record_request_model.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_record_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_chart_data_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_statistics_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_growth_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_growth_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/repositories/growth_repository.dart';

@LazySingleton(as: GrowthRepository)
class GrowthRepositoryImpl implements GrowthRepository {
  final GrowthRemoteDataSourceContract _remoteDataSource;
  final NetworkInfo _networkInfo;

  GrowthRepositoryImpl(
    this._remoteDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, GrowthRecordEntity>> addGrowthRecord(
    int childId,
    AddGrowthRecordRequestModel request,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.addGrowthRecord(childId, request);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, List<GrowthRecordEntity>>> getGrowthRecords(int childId) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getGrowthRecords(childId);
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
  Future<Either<Failure, void>> deleteGrowthRecord(int childId, int id) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteGrowthRecord(childId, id);
        return const Right(null);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, GrowthChartDataEntity>> getGrowthChartData(int childId) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getGrowthChartData(childId);
        return Right(model);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, GrowthStatisticsEntity>> getGrowthStatistics(int childId) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getGrowthStatistics(childId);
        return Right(model);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, WeeklyGrowthRecordsEntity>> getWeeklyGrowthRecords(int childId) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getWeeklyGrowthRecords(childId);
        return Right(model);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, MonthlyGrowthRecordsEntity>> getMonthlyGrowthRecords(int childId) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getMonthlyGrowthRecords(childId);
        return Right(model);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }
}
