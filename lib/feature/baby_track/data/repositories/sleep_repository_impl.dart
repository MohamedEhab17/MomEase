import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/error_handler.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/core/network/network_info.dart';
import 'package:new_mama/feature/baby_track/data/datasources/sleep_remote_data_source_contract.dart';
import 'package:new_mama/feature/baby_track/data/models/add_sleep_record_request_model.dart';
import 'package:new_mama/feature/baby_track/domain/entities/sleep_record_entity.dart';
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
}
