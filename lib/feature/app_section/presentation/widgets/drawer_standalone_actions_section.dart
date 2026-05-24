import 'package:flutter/material.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
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
          title: context.trContext(TK.drawerRateApp),
          titleColor: onSurfaceVariant,
          leading: buildDrawerIcon(AppIcons.iconsRate, color: onSurfaceVariant),
          onTap: () {},
        ),
        DrawerListTile(
          title: context.trContext(TK.drawerShareApp),
          titleColor: onSurfaceVariant,
          leading: buildDrawerIcon(
            AppIcons.iconsShare,
            color: onSurfaceVariant,
          ),
          onTap: () {},
        ),
        DrawerListTile(
          title: context.trContext(TK.drawerSendFeedback),
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
