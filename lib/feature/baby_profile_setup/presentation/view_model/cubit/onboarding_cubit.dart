import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final int totalSteps;

  OnboardingCubit({required this.totalSteps})
      : super(OnboardingState(
          currentStep: 0,
          progress: 1 / totalSteps,
          answers: const {},
        ));

  void nextStep() {
    if (state.currentStep < totalSteps - 1) {
      final newStep = state.currentStep + 1;
      emit(state.copyWith(
        currentStep: newStep,
        progress: (newStep + 1) / totalSteps,
      ));
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      final newStep = state.currentStep - 1;
      emit(state.copyWith(
        currentStep: newStep,
        progress: (newStep + 1) / totalSteps,
      ));
    }
  }

  void setAnswer(String key, dynamic value) {
    final updatedAnswers = Map<String, dynamic>.from(state.answers);
    updatedAnswers[key] = value;
    emit(state.copyWith(answers: updatedAnswers));
  }
}
