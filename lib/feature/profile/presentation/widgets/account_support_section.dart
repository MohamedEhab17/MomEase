import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/app_section/presentation/view_model/cubit/bottom_nav_cubit.dart';
import 'package:new_mama/feature/profile/data/models/profile_model.dart';
import 'package:new_mama/feature/profile/presentation/widgets/account_action_item_tile.dart';

class AccountSupportSection extends StatelessWidget {
  final List<AccountSupportItem> items;

  const AccountSupportSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        // Mapping string icon path to IconData for dummy data simplicity
        IconData getIcon(String path) {
          switch (path) {
            case "person_outline":
              return Icons.person_outline;
            case "lock_outline":
              return Icons.lock_outline;
            case "notifications_none":
              return Icons.notifications_none;
            case "translate":
              return Icons.translate;
            case "palette_outlined":
              return Icons.palette_outlined;
            case "help_outline":
              return Icons.help_outline;
            default:
              return Icons.circle;
          }
        }

        String getLocalizedTitle(String title) {
          switch (title) {
            case "Manage Profile":
              return context.trContext(TK.profileManageProfile);
            case "Security":
              return context.trContext(TK.profileSecurity);
            case "Notifications":
              return context.trContext(TK.notificationsTitle);
            case "Language":
              return context.trContext(TK.profileLanguageLabel);
            case "Theme":
              return context.trContext(TK.profileThemeLabel);
            case "Help Center":
              return context.trContext(TK.profileHelpCenter);
            default:
              return title;
          }
        }

        return AccountActionItemTile(
          title: getLocalizedTitle(item.title),
          iconData: getIcon(item.iconPath),
          iconBackgroundColor: item.iconBackgroundColor,
          iconColor: item.iconColor,
          trailingText: item.trailingText,
          onTap: () {
            if (item.title == "Notifications") {
              context.read<BottomNavCubit>().setIndex(2);
            }
          },
        );
      }).toList(),
    );
  }
}
