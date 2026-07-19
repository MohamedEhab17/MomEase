import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/feature/depression/domain/usecase/get_assessments_usecase.dart';
import 'package:new_mama/feature/depression/presentation/view_model/assessments_cubit/assessments_state.dart';

@injectable
class AssessmentsCubit extends SafeCubit<AssessmentsState> {
  final GetAssessmentsUseCase _getAssessments;

  AssessmentsCubit(this._getAssessments)
      : super(AssessmentsInitial());

  void fetchAssessments() {
    safeEmit(AssessmentsLoading());

    cancelableOperation(_getAssessments()).value.then((result) {
      result.fold(
        (failure) => safeEmit(AssessmentsError(failure.message)),
        (data) => safeEmit(AssessmentsLoaded(data)),
      );
    });
  }
}