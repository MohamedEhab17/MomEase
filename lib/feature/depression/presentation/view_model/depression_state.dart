abstract class DepressionState {}

class DepressionInitial extends DepressionState {}

class DepressionAnswering extends DepressionState {
  final int currentIndex;
  final int totalScore;
  final int? selectedAnswerIndex;

  DepressionAnswering({
    required this.currentIndex,
    required this.totalScore,
    this.selectedAnswerIndex,
  });
}

class DepressionFinished extends DepressionState {
  final int totalScore;

  DepressionFinished({required this.totalScore});
}
