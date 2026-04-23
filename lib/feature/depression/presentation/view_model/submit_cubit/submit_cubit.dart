import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/feature/depression/domain/entities/submit_answer.dart';
import 'package:new_mama/feature/depression/domain/entities/submit_request.dart';
import 'package:new_mama/feature/depression/domain/usecase/submit_assessment_usecase.dart';
import 'package:new_mama/feature/depression/domain/entities/assessment_result.dart';
import 'submit_state.dart';

@injectable
class SubmitCubit extends SafeCubit<SubmitState> {
  final SubmitAssessmentUseCase _submitAssessment;

  SubmitCubit(this._submitAssessment) : super(SubmitInitial());

  void submitAnswers(int assessmentId, List<SubmitAnswer> answers) {
    if (answers.isEmpty) return; 
    
    safeEmit(SubmitLoading());
    final request = SubmitRequest(answers: answers);
    
    cancelableOperation(_submitAssessment(assessmentId, request)).value.then((result) {
      result.fold(
        (failure) => safeEmit(SubmitError(failure.message)),
        (AssessmentResult data) => safeEmit(SubmitSuccess(data)),
      );
    });
  }
}



