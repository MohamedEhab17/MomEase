import 'package:new_mama/feature/depression/data/models/assessments_model.dart';
import 'package:new_mama/feature/depression/data/models/assessment_result_model.dart';
import 'package:new_mama/feature/depression/data/models/question_model.dart';
import 'package:new_mama/feature/depression/data/models/option_model.dart';
import 'package:new_mama/feature/depression/data/models/submit_request_model.dart';

abstract class AssessmentRemoteDataSourceContract {
  Future<List<AssessmentsModel>> getAssessments();
  Future<AssessmentsModel> getAssessmentById(int id);
  // Future<void> createAssessment(AssessmentsModel assessment);
  Future<List<QuestionModel>> getQuestions(int assessmentId);
  Future<QuestionModel> getQuestionById(int assessmentId, int questionId);
  Future<List<OptionModel>> getOptionsByQuestionId(int questionId);
  Future<AssessmentResultModel> submitAssessment(int assessmentId, SubmitRequestModel body);

  Future<AssessmentResultModel> getAssessmentResult(int id);
  Future<List<AssessmentResultModel>> getUserAssessmentResults();
  Future<void> deleteAssessmentResult(int id);
}