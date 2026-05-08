import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/logout_confirmation_dialog.dart';
import 'package:new_mama/feature/app_section/presentation/view_model/logout_cubit/logout_cubit.dart';
import 'package:new_mama/feature/app_section/presentation/view_model/logout_cubit/logout_state.dart';
import 'package:new_mama/core/helper/app_toast.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.go(AppRoutesPaths.login);
        } else if (state is LogoutFailure) {
          AppToast.error(context, message: state.message);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 24,
            children: [
              if (state is LogoutLoading)
                const Center(child: CircularProgressIndicator())
              else
                CustomElevatedButton(
                  backgroundColor:
                      context.theme.buttonTheme.colorScheme!.secondary,
                  borderColor: context.ext.colors.primaryDark,
                  text: context.trContext(TK.profileLogoutAccount),
                  textStyle: context.text.titleLarge!.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  minimumSize: Size(double.infinity, 52.h),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => const LogoutConfirmationDialog(),
                    );
                    if (confirm == true && context.mounted) {
                      context.read<LogoutCubit>().logout();
                    }
                  },
                ),
              Text(
                context.trContext(TK.profileVersion),
                style: context.text.bodyLarge!.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
