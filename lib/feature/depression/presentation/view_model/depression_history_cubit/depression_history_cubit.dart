import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/feature/depression/domain/usecase/get_user_assessment_results_usecase.dart';
import 'package:new_mama/feature/depression/domain/usecase/delete_assessment_result_usecase.dart';
import 'depression_history_state.dart';

@injectable
class DepressionHistoryCubit extends SafeCubit<DepressionHistoryState> {
  final GetUserAssessmentResultsUseCase _getHistoryUseCase;
  final DeleteAssessmentResultUseCase _deleteUseCase;

  DepressionHistoryCubit(
    this._getHistoryUseCase,
    this._deleteUseCase,
  ) : super(DepressionHistoryInitial());

  void fetchHistory() {
    safeEmit(DepressionHistoryLoading());

    cancelableOperation(_getHistoryUseCase()).value.then((result) {
      result.fold(
        (failure) => safeEmit(DepressionHistoryError(failure.message)),
        (data) => safeEmit(DepressionHistoryLoaded(data)),
      );
    });
  }

  void deleteHistoryItem(int id) {
    if (state is! DepressionHistoryLoaded) return;
    
    final currentState = state as DepressionHistoryLoaded;
    final originalList = currentState.historyList;

    // Optimistic deletion
    final updatedList = originalList.where((e) => e.id != id).toList();
    safeEmit(DepressionHistoryLoaded(updatedList));

    cancelableOperation(_deleteUseCase(id)).value.then((result) {
      result.fold(
        (failure) {
          // Revert back on error and emit error state
          safeEmit(DepressionHistoryError(failure.message));
          safeEmit(DepressionHistoryLoaded(originalList));
        },
        (_) {
          // Success: already removed optimistically
        },
      );
    });
  }
}
