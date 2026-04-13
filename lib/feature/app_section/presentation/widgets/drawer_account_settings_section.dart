import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/theme/cubit/theme_cubit.dart';
import 'package:new_mama/core/localization/cubit/language_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'drawer_helpers.dart';
import 'drawer_item_group.dart';
import 'drawer_list_tile.dart';
import 'drawer_dropdown_tile.dart';

class DrawerAccountSettingsSection extends StatelessWidget {
  const DrawerAccountSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerItemGroup(
      title: context.trContext(TK.drawerAccSettings),
      children: [
        DrawerListTile(
          title: context.trContext(TK.drawerManageProfile),
          leading: buildDrawerIcon(
            AppIcons.iconsInActiveProfile,
            color: context.ext.colors.primaryDark,
          ),
          trailing: buildDrawerChevron(color: context.ext.colors.primaryDark),
          onTap: () {},
        ),
        DrawerListTile(
          title: context.trContext(TK.drawerSecurity),
          leading: buildDrawerIcon(
            AppIcons.iconsLock,
            color: context.ext.colors.primaryDark,
          ),
          trailing: buildDrawerChevron(color: context.ext.colors.primaryDark),
          onTap: () {},
        ),
        DrawerListTile(
          title: context.trContext(TK.drawerNotifications),
          leading: buildDrawerIcon(
            AppIcons.iconsInActiveNotification,
            color: context.ext.colors.primaryDark,
          ),
          trailing: buildDrawerChevron(color: context.ext.colors.primaryDark),
          onTap: () {},
        ),
        BlocBuilder<LanguageCubit, Locale>(
          builder: (context, locale) {
            final isEnglish = locale.languageCode == 'en';
            return DrawerListTile(
              title: context.trContext(TK.commonLanguage),
              leading: buildDrawerIcon(
                AppIcons.iconsLanguage,
                color: context.ext.colors.primaryDark,
              ),
              flipX: false,
              trailing: Text(
                isEnglish
                    ? context.trContext(TK.drawerEnglish)
                    : context.trContext(TK.drawerArabic),
                style: context.theme.textTheme.titleSmall!.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () async {
                final newLocaleCode = isEnglish ? 'ar' : 'en';
                final newLocale = Locale(newLocaleCode);
                await context.setLocale(newLocale);
                if (!context.mounted) return;
                context.read<LanguageCubit>().changeLanguage(newLocaleCode);
              },
            );
          },
        ),
        BlocBuilder<ThemeCubit, AppThemeMode>(
          builder: (context, themeMode) {
            String themeText = 'Pink';
            if (themeMode == AppThemeMode.blue) themeText = 'Blue';
            if (themeMode == AppThemeMode.dark) themeText = 'Dark';

            return DrawerDropdownTile<AppThemeMode>(
              title: context.trContext(TK.commonThemeMode),
              leading: buildDrawerIcon(
                AppIcons.iconsTheme,
                color: context.ext.colors.primaryDark,
              ),
              trailingText: themeText,
              items: [
                PopupMenuItem(
                  value: AppThemeMode.pink,
                  child: Text(
                    'Pink',
                    style: context.theme.textTheme.titleSmall!.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: AppThemeMode.blue,
                  child: Text(
                    'Blue',
                    style: context.theme.textTheme.titleSmall!.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: AppThemeMode.dark,
                  child: Text(
                    'Dark',
                    style: context.theme.textTheme.titleSmall!.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              onSelected: (newMode) {
                context.read<ThemeCubit>().changeTheme(newMode);
              },
            );
          },
        ),
      ],
    );
  }
}
