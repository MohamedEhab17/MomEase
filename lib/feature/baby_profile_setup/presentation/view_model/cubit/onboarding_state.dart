class OnboardingState {
  final int currentStep;
  final double progress;
  final Map<String, dynamic> answers;

  const OnboardingState({
    required this.currentStep,
    required this.progress,
    required this.answers,
  });

  OnboardingState copyWith({
    int? currentStep,
    double? progress,
    Map<String, dynamic>? answers,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      progress: progress ?? this.progress,
      answers: answers ?? this.answers,
    );
  }
}
