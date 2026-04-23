import 'package:dartz/dartz.dart' hide Option;
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/depression/domain/entities/assessments.dart';
import 'package:new_mama/feature/depression/domain/entities/assessment_result.dart';
import 'package:new_mama/feature/depression/domain/entities/question.dart';
import 'package:new_mama/feature/depression/domain/entities/option.dart';
import 'package:new_mama/feature/depression/domain/entities/submit_request.dart';

abstract class AssessmentRepository {
  Future<Either<Failure, List<Assessments>>> getAssessments();
  Future<Either<Failure, Assessments>> getAssessmentById(int id);
  // Future<Either<Failure, void>> createAssessment(Assessments assessment);
  Future<Either<Failure, List<Question>>> getQuestions(int assessmentId);
  Future<Either<Failure, Question>> getQuestionById(int assessmentId, int questionId);
  Future<Either<Failure, List<Option>>> getOptions(int questionId);
  Future<Either<Failure, AssessmentResult>> submitAssessment(int assessmentId, SubmitRequest body);

  Future<Either<Failure, AssessmentResult>> getAssessmentResult(int id);
}