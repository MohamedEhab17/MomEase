import 'package:dartz/dartz.dart' hide Option;
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/error_handler.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/core/network/network_info.dart';
import 'package:new_mama/feature/depression/data/datasources/assessment_remote_data_source_contract.dart';
import 'package:new_mama/feature/depression/data/models/submit_request_model.dart';
import 'package:new_mama/feature/depression/domain/entities/assessments.dart';
import 'package:new_mama/feature/depression/domain/entities/assessment_result.dart';
import 'package:new_mama/feature/depression/domain/entities/question.dart';
import 'package:new_mama/feature/depression/domain/entities/option.dart';
import 'package:new_mama/feature/depression/domain/entities/submit_request.dart';
import 'package:new_mama/feature/depression/domain/repositories/assessment_repository.dart';

@LazySingleton(as: AssessmentRepository)
class AssessmentRepositoryImpl implements AssessmentRepository {
  final AssessmentRemoteDataSourceContract _remoteDataSource;
  final NetworkInfo _networkInfo;

  AssessmentRepositoryImpl(
    this._remoteDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, List<Assessments>>> getAssessments() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getAssessments();

        // convert model → entity
        final assessments = models.map((e) => e.toEntity()).toList();

        return Right(assessments);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, Assessments>> getAssessmentById(int id) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getAssessmentById(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, List<Question>>> getQuestions(int assessmentId) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getQuestions(assessmentId);
        return Right(models.map((e) => e.toEntity()).toList());
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, Question>> getQuestionById(int assessmentId, int questionId) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getQuestionById(assessmentId, questionId);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, List<Option>>> getOptions(int questionId) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getOptionsByQuestionId(questionId);
        return Right(models.map((e) => e.toEntity()).toList());
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, AssessmentResult>> submitAssessment(int assessmentId, SubmitRequest body) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = SubmitRequestModel.fromEntity(body);
        final resultModel = await _remoteDataSource.submitAssessment(assessmentId, model);
        return Right(resultModel.toEntity());
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }


  @override
  Future<Either<Failure, AssessmentResult>> getAssessmentResult(int id) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getAssessmentResult(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection.'));
    }
  }
}
