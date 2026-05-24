import 'package:flutter/material.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'drawer_helpers.dart';
import 'drawer_item_group.dart';
import 'drawer_list_tile.dart';

class DrawerSupportInfoSection extends StatelessWidget {
  const DrawerSupportInfoSection({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DrawerItemGroup(
      title: context.trContext(TK.drawerSupportInfo),
      children: [
        DrawerListTile(
          title: context.trContext(TK.drawerHelpCenter),
          leading: buildDrawerIcon(AppIcons.iconsHelp,
              color: context.ext.colors.primaryDark),
          onTap: () => _launchUrl(
              'https://www.notion.so/Help-Center-FAQ-35a632c6936e807a8da4eca1fef4f099?source=copy_link'),
        ),
        DrawerListTile(
          title: context.trContext(TK.drawerContactUs),
          leading: buildDrawerIcon(
            AppIcons.iconsContact,
            color: context.ext.colors.primaryDark,
          ),
          onTap: () => _launchUrl(
              'https://www.notion.so/Contact-Us-35a632c6936e808fbf0aec3c8da08f3d?source=copy_link'),
        ),
        DrawerListTile(
          title: context.trContext(TK.drawerAboutMomEase),
          leading: buildDrawerIcon(AppIcons.iconsAbout,
              color: context.ext.colors.primaryDark),
          onTap: () => _launchUrl(
              'https://www.notion.so/About-Momease-35a632c6936e8002acf8cf5b94b33e99?source=copy_link'),
        ),
        DrawerListTile(
          title: context.trContext(TK.drawerPrivacyPolicy),
          leading: buildDrawerIcon(AppIcons.iconsLock,
              color: context.ext.colors.primaryDark),
          onTap: () => _launchUrl(
              'https://www.notion.so/Privacy-Policy-Momease-35a632c6936e803589cafef3b05ab932?source=copy_link'),
        ),
      ],
    );
  }
}
