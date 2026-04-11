import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        spacing: 24,
        children: [
          CustomElevatedButton(
            backgroundColor: context.theme.buttonTheme.colorScheme!.secondary,
            borderColor: context.ext.colors.primaryDark,
            text: "Logout Account",
            textStyle: context.text.titleLarge!.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.w600,
            ),
            minimumSize: Size(double.infinity, 52.h),
            onPressed: () {
              context.go(AppRoutesPaths.login);
            },
          ),
          Text(
            "MomEase V1.0.0",
            style: context.text.bodyLarge!.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
