import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:new_mama/feature/auth/presentation/cubit/auth_state.dart';

class SignUpButton extends StatelessWidget {
  final bool isValid;
  final VoidCallback onPressed;

  const SignUpButton({
    super.key,
    required this.isValid,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Opacity(
          opacity: isValid && !isLoading ? 1.0 : 0.5,
          child: CustomElevatedButton(
            text: context.trContext(TK.authSignUpButton),
            minimumSize: const Size(double.infinity, 52),
            onPressed: isValid && !isLoading ? onPressed : null,
          ),
        );
      },
    );
  }
}
