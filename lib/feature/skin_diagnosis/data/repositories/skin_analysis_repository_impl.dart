import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/error_handler.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/core/network/network_info.dart';
import 'package:new_mama/feature/skin_diagnosis/data/datasources/skin_analysis_remote_data_source.dart';
import 'package:new_mama/feature/skin_diagnosis/domain/entities/skin_analysis.dart';
import 'package:new_mama/feature/skin_diagnosis/domain/repositories/skin_analysis_repository.dart';

@LazySingleton(as: SkinAnalysisRepository)
class SkinAnalysisRepositoryImpl implements SkinAnalysisRepository {
  final SkinAnalysisRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  SkinAnalysisRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, SkinAnalysis>> analyzeImage({
    required File image,
    required int childId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final model =
          await _remoteDataSource.analyzeImage(image: image, childId: childId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<SkinAnalysis>>> getUserAnalyses() async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final models = await _remoteDataSource.getUserAnalyses();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<SkinAnalysis>>> getChildAnalyses(
      int childId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      final models = await _remoteDataSource.getChildAnalyses(childId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAnalysis(int analysisId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ServerFailure('No internet connection.'));
    }
    try {
      await _remoteDataSource.deleteAnalysis(analysisId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
