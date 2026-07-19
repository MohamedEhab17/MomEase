import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'drawer_helpers.dart';
import 'drawer_item_group.dart';
import 'drawer_list_tile.dart';

class DrawerMainFeaturesSection extends StatelessWidget {
  final VoidCallback onClose;

  const DrawerMainFeaturesSection({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return DrawerItemGroup(
      children: [
        DrawerListTile(
          title: context.trContext(TK.drawerBabyTracking),
          leading: buildDrawerIcon(
            color: context.ext.colors.primaryDark,
            AppIcons.iconsBabyTracing,
          ),
          trailing: buildDrawerChevron(color: context.ext.colors.primaryDark),
          onTap: () {
            onClose();
            context.push(AppRoutesPaths.babyTrackView);
          },
        ),
        DrawerListTile(
          title: context.trContext(TK.drawerDepression),
          leading: buildDrawerIcon(
            color: context.ext.colors.primaryDark,
            AppIcons.iconsActiveProfile,
          ),
          trailing: buildDrawerChevron(color: context.ext.colors.primaryDark),
          onTap: () {
            onClose();
            context.push(AppRoutesPaths.depressionView);
          },
        ),
        DrawerListTile(
          title: context.trContext(TK.drawerBabyCry),
          leading: buildDrawerIcon(
            color: context.ext.colors.primaryDark,
            AppIcons.iconsSound,
          ),
          trailing: buildDrawerChevron(color: context.ext.colors.primaryDark),
          onTap: () {
            onClose();
            context.push(AppRoutesPaths.cryingInsightView);
          },
        ),
        DrawerListTile(
          title: context.trContext(TK.drawerSkinDiagnosis),
          leading: buildDrawerIcon(
            color: context.ext.colors.primaryDark,
            AppIcons.iconsSkin,
          ),
          trailing: buildDrawerChevron(color: context.ext.colors.primaryDark),
          onTap: () {
            onClose();
            context.push(AppRoutesPaths.skinDiagnosisInsightView);
          },
        ),
      ],
    );
  }
}
