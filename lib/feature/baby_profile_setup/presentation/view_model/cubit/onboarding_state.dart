import 'package:new_mama/feature/children/domain/repositories/children_repository.dart';

class OnboardingState {
  final int currentStep;
  final double progress;
  final Map<String, dynamic> answers;
  /// Remaining children to create after the first API call succeeds.
  final List<CreateChildParams> pendingChildren;

  const OnboardingState({
    required this.currentStep,
    required this.progress,
    required this.answers,
    this.pendingChildren = const <CreateChildParams>[],
  });

  OnboardingState copyWith({
    int? currentStep,
    double? progress,
    Map<String, dynamic>? answers,
    List<CreateChildParams>? pendingChildren,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      progress: progress ?? this.progress,
      answers: answers ?? this.answers,
      pendingChildren: pendingChildren ?? this.pendingChildren,
    );
  }
}
