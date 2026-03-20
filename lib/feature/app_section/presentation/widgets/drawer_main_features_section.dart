import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          title: 'Baby Tracking',
          leading: buildDrawerIcon(AppIcons.iconsBabyTracing),
          trailing: buildDrawerChevron(),
          onTap: () {
            onClose();
            context.push(AppRoutesPaths.babyTrackView);
          },
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
    );
  }
}
