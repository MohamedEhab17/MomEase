import 'package:flutter/material.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'drawer_helpers.dart';
import 'drawer_list_tile.dart';

class DrawerStandaloneActionsSection extends StatelessWidget {
  const DrawerStandaloneActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
