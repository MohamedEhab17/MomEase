import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/error_handler.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/core/network/network_info.dart';
import '../data_source/cry_analysis_remote_data_source.dart';
import '../../domain/entities/cry_analysis.dart';
import '../../domain/repositories/cry_analysis_repository.dart';

@LazySingleton(as: CryAnalysisRepository)
class CryAnalysisRepositoryImpl implements CryAnalysisRepository {
  final CryAnalysisRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  CryAnalysisRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, CryAnalysis>> analyzeCry({
    required File audioFile,
    required int childId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final model = await _remoteDataSource.analyzeCry(
        audioFile: audioFile,
        childId: childId,
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<CryAnalysis>>> getUserCryAnalyses() async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final models = await _remoteDataSource.getUserCryAnalyses();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<CryAnalysis>>> getChildCryAnalyses(
      int childId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final models = await _remoteDataSource.getChildCryAnalyses(childId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCryAnalysis(int cryId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      await _remoteDataSource.deleteCryAnalysis(cryId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
