import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/theme/cubit/theme_cubit.dart';
import 'package:new_mama/core/utils/app_icons.dart';
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
            color: context.ext.colors.primaryDark,
          ),
          trailing: buildDrawerChevron(color: context.ext.colors.primaryDark),
          onTap: () {},
        ),
        DrawerListTile(
          title: 'Security',
          leading: buildDrawerIcon(AppIcons.iconsLock, color: context.ext.colors.primaryDark),
          trailing: buildDrawerChevron(color: context.ext.colors.primaryDark),
          onTap: () {},
        ),
        DrawerListTile(
          title: 'Notifications',
          leading: buildDrawerIcon(
            AppIcons.iconsInActiveNotification,
            color: context.ext.colors.primaryDark,
          ),
          trailing: buildDrawerChevron(color: context.ext.colors.primaryDark),
          onTap: () {},
        ),
        DrawerListTile(
          title: 'Language',
          leading: buildDrawerIcon(
            AppIcons.iconsLanguage,
            color: context.ext.colors.primaryDark,
          ),
          trailing: Text(
            'English',
            style: context.theme.textTheme.titleSmall!.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () {},
        ),
        BlocBuilder<ThemeCubit, AppThemeMode>(
          builder: (context, themeMode) {
            String themeTitle = 'Theme Action';
            if (themeMode == AppThemeMode.pink) {
              themeTitle = 'Blue Mode';
            } else if (themeMode == AppThemeMode.blue) {
              themeTitle = 'Dark Mode';
            } else {
              themeTitle = 'Pink Mode';
            }

            return DrawerListTile(
              title: themeTitle,
              leading: buildDrawerIcon(
                AppIcons.iconsTheme,
                color: context.ext.colors.primaryDark,
              ),
              trailing: buildDrawerChevron(color: context.ext.colors.primaryDark),
              onTap: () {
                context.read<ThemeCubit>().toggleTheme();
              },
            );
          },
        ),
      ],
    );
  }
}
