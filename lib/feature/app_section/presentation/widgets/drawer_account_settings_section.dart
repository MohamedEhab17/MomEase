import 'package:flutter/material.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'drawer_helpers.dart';
import 'drawer_item_group.dart';
import 'drawer_list_tile.dart';

class DrawerAccountSettingsSection extends StatelessWidget {
  const DrawerAccountSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerItemGroup(
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
    );
  }
}
