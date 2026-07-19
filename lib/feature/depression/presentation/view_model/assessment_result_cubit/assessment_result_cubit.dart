import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/feature/depression/domain/usecase/get_assessment_result_usecase.dart';
import 'assessment_result_state.dart';

@injectable
class AssessmentResultCubit extends SafeCubit<AssessmentResultState> {
  final GetAssessmentResultUseCase getAssessmentResultUseCase;

  AssessmentResultCubit(this.getAssessmentResultUseCase) : super(AssessmentResultInitial());

  Future<void> getResult(int id) async {
    emit(AssessmentResultLoading());
    final result = await getAssessmentResultUseCase(id);
    result.fold(
      (failure) => emit(AssessmentResultError(failure.message)),
      (data) => emit(AssessmentResultSuccess(data)),
    );
  }
}
