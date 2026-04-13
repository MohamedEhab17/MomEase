import 'package:flutter/material.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'drawer_helpers.dart';
import 'drawer_item_group.dart';
import 'drawer_list_tile.dart';

class DrawerSupportInfoSection extends StatelessWidget {
  const DrawerSupportInfoSection({super.key});

  @override
  Widget build(BuildContext context) {

    return DrawerItemGroup(
      title: context.trContext(TK.drawerSupportInfo),
      children: [
        DrawerListTile(
          title: context.trContext(TK.drawerHelpCenter),
          leading: buildDrawerIcon(AppIcons.iconsHelp, color:  context.ext.colors.primaryDark),
          onTap: () {},
        ),
        DrawerListTile(
          title: context.trContext(TK.drawerContactUs),
          leading: buildDrawerIcon(
            AppIcons.iconsContact,
            color: context.ext.colors.primaryDark,
          ),
          onTap: () {},
        ),
        DrawerListTile(
          title: context.trContext(TK.drawerAboutMomEase),
          leading: buildDrawerIcon(AppIcons.iconsAbout, color: context.ext.colors.primaryDark),
          onTap: () {},
        ),
      ],
    );
  }
}
