import 'package:new_mama/feature/baby_cry/domain/entities/cry_analysis.dart';

enum BabyCryStatus {
  initial,
  loading,
  analyzing,
  success,
  historyLoading,
  historySuccess,
  deleting,
  error,
}

class BabyCryState {
  final BabyCryStatus status;
  final String? errorMessage;
  final CryAnalysis? analysisResult;
  final List<CryAnalysis> historyList;

  const BabyCryState({
    this.status = BabyCryStatus.initial,
    this.errorMessage,
    this.analysisResult,
    this.historyList = const [],
  });

  BabyCryState copyWith({
    BabyCryStatus? status,
    String? errorMessage,
    bool clearError = false,
    CryAnalysis? analysisResult,
    List<CryAnalysis>? historyList,
  }) {
    return BabyCryState(
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      analysisResult: analysisResult ?? this.analysisResult,
      historyList: historyList ?? this.historyList,
    );
  }
}
