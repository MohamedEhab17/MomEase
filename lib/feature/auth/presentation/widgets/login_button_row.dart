import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:new_mama/feature/auth/presentation/cubit/auth_state.dart';

class LoginButtonRow extends StatelessWidget {
  final bool isValid;
  final bool isBiometricAvailable;
  final VoidCallback onLoginPressed;
  final VoidCallback onBiometricPressed;

  const LoginButtonRow({
    super.key,
    required this.isValid,
    required this.isBiometricAvailable,
    required this.onLoginPressed,
    required this.onBiometricPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final loading = authState is AuthLoading;
        return Opacity(
          opacity: loading ? 0.5 : 1.0,
          child: Row(
            children: [
              Expanded(
                child: Opacity(
                  opacity: isValid ? 1.0 : 0.5,
                  child: CustomElevatedButton(
                    text: context.trContext(TK.authLoginButton),
                    minimumSize: const Size(double.infinity, 52),
                    onPressed: isValid && !loading ? onLoginPressed : null,
                  ),
                ),
              ),
              if (isBiometricAvailable) ...[
                12.w.width,
                InkWell(
                  onTap: !loading ? onBiometricPressed : null,
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: context.theme.cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: context.colors.primary.withValues(
                          alpha: 0.1,
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.fingerprint_rounded,
                      color: context.colors.primary,
                      size: 32.sp,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
