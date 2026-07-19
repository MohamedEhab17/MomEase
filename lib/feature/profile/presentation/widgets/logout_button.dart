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
            children: [
              SizedBox(
                width: double.infinity,
                child: state is LogoutLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomElevatedButton(
                        backgroundColor:
                            context.theme.buttonTheme.colorScheme!.secondary,
                        borderColor: context.ext.colors.primaryDark,
                        icon: Icon(
                          Icons.logout,
                          color: context.ext.colors.primaryDark,
                          size: 20.sp,
                        ),
                        text: context.trContext(TK.commonLogout),
                        textStyle: context.theme.textTheme.titleLarge!.copyWith(
                          color: context.ext.colors.primaryDark,
                          fontWeight: FontWeight.w600,
                        ),
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
              ),
              16.verticalSpace,
              Text(
                context.trContext(TK.commonVersionDisplay, namedArgs: {'version': '1.0.0'}),
                style: context.text.bodyLarge!.copyWith(
                  color: context.ext.colors.lightTextSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
