import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import '../../../domain/usecases/analyze_cry_usecase.dart';
import '../../../domain/usecases/delete_cry_analysis_usecase.dart';
import '../../../domain/usecases/get_child_cry_analyses_usecase.dart';
import '../../../domain/usecases/get_user_cry_analyses_usecase.dart';
import 'baby_cry_state.dart';

@injectable
class BabyCryCubit extends SafeCubit<BabyCryState> {
  final AnalyzeCryUseCase _analyzeUseCase;
  final GetUserCryAnalysesUseCase _getUserAnalysesUseCase;
  final GetChildCryAnalysesUseCase _getChildAnalysesUseCase;
  final DeleteCryAnalysisUseCase _deleteUseCase;

  BabyCryCubit(
    this._analyzeUseCase,
    this._getUserAnalysesUseCase,
    this._getChildAnalysesUseCase,
    this._deleteUseCase,
  ) : super(const BabyCryState());

  Future<void> analyzeCry({required File audioFile, required int childId}) async {
    safeEmit(state.copyWith(
      status: BabyCryStatus.analyzing,
      clearError: true,
    ));

    final result = await _analyzeUseCase(AnalyzeCryParams(
      audioFile: audioFile,
      childId: childId,
    ));

    result.fold(
      (failure) => safeEmit(state.copyWith(
        status: BabyCryStatus.error,
        errorMessage: failure.message,
      )),
      (analysis) => safeEmit(state.copyWith(
        status: BabyCryStatus.success,
        analysisResult: analysis,
      )),
    );
  }

  Future<void> loadUserHistory() async {
    safeEmit(state.copyWith(
      status: BabyCryStatus.historyLoading,
      clearError: true,
    ));

    final result = await _getUserAnalysesUseCase();

    result.fold(
      (failure) => safeEmit(state.copyWith(
        status: BabyCryStatus.error,
        errorMessage: failure.message,
      )),
      (list) => safeEmit(state.copyWith(
        status: BabyCryStatus.historySuccess,
        historyList: list,
      )),
    );
  }

  Future<void> loadChildHistory(int childId) async {
    safeEmit(state.copyWith(
      status: BabyCryStatus.historyLoading,
      clearError: true,
    ));

    final result = await _getChildAnalysesUseCase(childId);

    result.fold(
      (failure) => safeEmit(state.copyWith(
        status: BabyCryStatus.error,
        errorMessage: failure.message,
      )),
      (list) => safeEmit(state.copyWith(
        status: BabyCryStatus.historySuccess,
        historyList: list,
      )),
    );
  }

  Future<void> deleteCryAnalysis(int cryId) async {
    final originalList = state.historyList;
    final updatedList = originalList.where((a) => a.cryId != cryId).toList();

    safeEmit(state.copyWith(
      status: BabyCryStatus.historySuccess,
      historyList: updatedList,
      clearError: true,
    ));

    final result = await _deleteUseCase(cryId);

    result.fold(
      (failure) {
        safeEmit(state.copyWith(
          status: BabyCryStatus.error,
          errorMessage: failure.message,
          historyList: originalList,
        ));
        safeEmit(state.copyWith(
          status: BabyCryStatus.historySuccess,
          historyList: originalList,
        ));
      },
      (_) {
        // Success
      },
    );
  }
}
