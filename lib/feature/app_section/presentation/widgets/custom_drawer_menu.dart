import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'drawer_helpers.dart';
import 'drawer_item_group.dart';
import 'drawer_list_tile.dart';
import 'drawer_logout_section.dart';
import 'drawer_user_header.dart';

class CustomDrawerMenu extends StatelessWidget {
  final VoidCallback onClose;
  final Animation<double> animation;

  const CustomDrawerMenu({
    super.key,
    required this.onClose,
    required this.animation,
  });

  Widget _animated({
    required Widget child,
    required double start,
    required double end,
  }) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Interval(start, end, curve: Curves.easeOutBack),
    );
    return AnimatedBuilder(
      animation: curved,
      builder: (ctx, snapshot) => Transform.translate(
        offset: Offset(-40 * (1 - curved.value), 0),
        child: Opacity(opacity: curved.value.clamp(0.0, 1.0), child: child),
      ),
    );
  }

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
                _animated(
                  start: 0.2,
                  end: 0.6,
                  child: DrawerItemGroup(
                    children: [
                      DrawerListTile(
                        title: 'Baby Tracking',
                        leading: buildDrawerIcon(AppIcons.iconsBabyTracing),
                        trailing: buildDrawerChevron(),
                        onTap: () {},
                      ),
                      DrawerListTile(
                        title: 'Depression Test',
                        leading: buildDrawerIcon(AppIcons.iconsActiveProfile),
                        trailing: buildDrawerChevron(),
                        onTap: () {},
                      ),
                      DrawerListTile(
                        title: 'Baby Cry',
                        leading: buildDrawerIcon(AppIcons.iconsSound),
                        trailing: buildDrawerChevron(),
                        onTap: () {},
                      ),
                      DrawerListTile(
                        title: 'Skin Diagnosis',
                        leading: buildDrawerIcon(AppIcons.iconsSkin),
                        trailing: buildDrawerChevron(),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // ── Account Settings ──
                _animated(
                  start: 0.3,
                  end: 0.7,
                  child: DrawerItemGroup(
                    title: 'Account Settings',
                    children: [
                      DrawerListTile(
                        title: 'Manage Profile',
                        leading: buildDrawerIcon(
                          AppIcons.iconsInActiveProfile,
                          color: AppColors.lightTextSecondary,
                        ),
                        trailing: buildDrawerChevron(),
                        onTap: () {},
                      ),
                      DrawerListTile(
                        title: 'Security',
                        leading: buildDrawerIcon(
                          AppIcons.iconsLock,
                          color: AppColors.lightTextSecondary,
                        ),
                        trailing: buildDrawerChevron(),
                        onTap: () {},
                      ),
                      DrawerListTile(
                        title: 'Notifications',
                        leading: buildDrawerIcon(
                          AppIcons.iconsInActiveNotification,
                          color: AppColors.lightTextSecondary,
                        ),
                        trailing: buildDrawerChevron(),
                        onTap: () {},
                      ),
                      DrawerListTile(
                        title: 'Language',
                        leading: buildDrawerIcon(
                          AppIcons.iconsLanguage,
                          color: AppColors.lightTextSecondary,
                        ),
                        trailing: Text(
                          'English',
                          style: AppStyles.styleInter14.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {},
                      ),
                      DrawerListTile(
                        title: 'Dark Mode',
                        leading: buildDrawerIcon(
                          AppIcons.iconsTheme,
                          color: AppColors.lightTextSecondary,
                        ),
                        trailing: buildDrawerChevron(),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // ── Support & Info ──
                _animated(
                  start: 0.4,
                  end: 0.8,
                  child: DrawerItemGroup(
                    title: 'Support & Info',
                    children: [
                      DrawerListTile(
                        title: 'Help Center',
                        leading: buildDrawerIcon(
                          AppIcons.iconsHelp,
                          color: AppColors.lightTextSecondary,
                        ),
                        onTap: () {},
                      ),
                      DrawerListTile(
                        title: 'Contact Us',
                        leading: buildDrawerIcon(
                          AppIcons.iconsContact,
                          color: AppColors.lightTextSecondary,
                        ),
                        onTap: () {},
                      ),
                      DrawerListTile(
                        title: 'About MomEase',
                        leading: buildDrawerIcon(
                          AppIcons.iconsAbout,
                          color: AppColors.lightTextSecondary,
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // ── Standalone Actions ──
                _animated(
                  start: 0.5,
                  end: 0.9,
                  child: Column(
                    children: [
                      DrawerListTile(
                        title: 'Rate MomEase',
                        titleColor: AppColors.lightTextSecondary,
                        leading: buildDrawerIcon(
                          AppIcons.iconsRate,
                          color: AppColors.lightTextSecondary,
                        ),
                        onTap: () {},
                      ),
                      DrawerListTile(
                        title: 'Share with Friends',
                        titleColor: AppColors.lightTextSecondary,
                        leading: buildDrawerIcon(
                          AppIcons.iconsShare,
                          color: AppColors.lightTextSecondary,
                        ),
                        onTap: () {},
                      ),
                      DrawerListTile(
                        title: 'Send Feedback',
                        titleColor: AppColors.lightTextSecondary,
                        leading: buildDrawerIcon(
                          AppIcons.iconsFeedback,
                          color: AppColors.lightTextSecondary,
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
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
