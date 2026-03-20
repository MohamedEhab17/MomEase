import 'package:flutter/material.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'drawer_helpers.dart';
import 'drawer_item_group.dart';
import 'drawer_list_tile.dart';

class DrawerSupportInfoSection extends StatelessWidget {
  const DrawerSupportInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerItemGroup(
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
    );
  }
}
