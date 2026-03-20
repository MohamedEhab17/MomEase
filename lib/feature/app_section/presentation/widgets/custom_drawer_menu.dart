import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'drawer_account_settings_section.dart';
import 'drawer_animated_item.dart';
import 'drawer_logout_section.dart';
import 'drawer_main_features_section.dart';
import 'drawer_standalone_actions_section.dart';
import 'drawer_support_info_section.dart';
import 'drawer_user_header.dart';

class CustomDrawerMenu extends StatelessWidget {
  final VoidCallback onClose;
  final Animation<double> animation;

  const CustomDrawerMenu({
    super.key,
    required this.onClose,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.backgroundPink,
      child: Column(
        children: [
          // User Info Header
          DrawerUserHeader(animation: animation),

          // Scrollable Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              children: [
                // ── Main Features ──
                DrawerAnimatedItem(
                  animation: animation,
                  start: 0.2,
                  end: 0.6,
                  child: DrawerMainFeaturesSection(onClose: onClose),
                ),
                SizedBox(height: 24.h),

                // ── Account Settings ──
                DrawerAnimatedItem(
                  animation: animation,
                  start: 0.3,
                  end: 0.7,
                  child: const DrawerAccountSettingsSection(),
                ),
                SizedBox(height: 24.h),

                // ── Support & Info ──
                DrawerAnimatedItem(
                  animation: animation,
                  start: 0.4,
                  end: 0.8,
                  child: const DrawerSupportInfoSection(),
                ),
                SizedBox(height: 24.h),

                // ── Standalone Actions ──
                DrawerAnimatedItem(
                  animation: animation,
                  start: 0.5,
                  end: 0.9,
                  child: const DrawerStandaloneActionsSection(),
                ),
                32.h.height,

                // ── Logout ──
                DrawerLogoutSection(animation: animation),
                32.h.height,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
