import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_state.dart';
import 'package:new_mama/feature/children/domain/repositories/children_repository.dart';
import 'package:new_mama/feature/children/presentation/cubit/children_cubit.dart';

class StepValidationHelper {
  StepValidationHelper._();

  static bool isNextEnabled(OnboardingState state, String? stepKey) {
    if (stepKey == null) return true;
    final answer = state.answers[stepKey];
    if (answer is String) {
      return answer.trim().isNotEmpty;
    }
    return answer != null;
  }

  static void submitToApi(BuildContext context, OnboardingState state) {
    final answers = state.answers;
    final name = answers['babyName'] as String? ?? 'Baby';
    final gender = answers['babyGender'] as String? ?? 'Boy';
    final dobStr = answers['dateOfBirth'] as String? ?? '';
    final feeding = answers['feedingType'] as String? ?? '';
    final delivery = answers['birthExperience'] as String? ?? '';

    String formattedDob;
    try {
      final parts = dobStr.split('/');
      final m = int.parse(parts[0]);
      final d = int.parse(parts[1]);
      final y = int.parse(parts[2]);
      formattedDob = DateTime(y, m, d).toUtc().toIso8601String();
    } catch (_) {
      formattedDob = DateTime.now().toUtc().toIso8601String();
    }

    final params = CreateChildParams(
      fullName: name,
      gender: gender,
      birthDate: formattedDob,
      deliveryType: delivery,
      feedingTypeForBaby: feeding,
    );

    context.read<ChildrenCubit>().createChild(params);
  }
}
