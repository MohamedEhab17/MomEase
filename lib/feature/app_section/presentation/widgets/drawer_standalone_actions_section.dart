import 'package:flutter/material.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'drawer_helpers.dart';
import 'drawer_list_tile.dart';

class DrawerStandaloneActionsSection extends StatelessWidget {
  const DrawerStandaloneActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;

    return Column(
      children: [
        DrawerListTile(
          title: 'Rate MomEase',
          titleColor: onSurfaceVariant,
          leading: buildDrawerIcon(AppIcons.iconsRate, color: onSurfaceVariant),
          onTap: () {},
        ),
        DrawerListTile(
          title: 'Share with Friends',
          titleColor: onSurfaceVariant,
          leading: buildDrawerIcon(
            AppIcons.iconsShare,
            color: onSurfaceVariant,
          ),
          onTap: () {},
        ),
        DrawerListTile(
          title: 'Send Feedback',
          titleColor: onSurfaceVariant,
          leading: buildDrawerIcon(
            AppIcons.iconsFeedback,
            color: onSurfaceVariant,
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
