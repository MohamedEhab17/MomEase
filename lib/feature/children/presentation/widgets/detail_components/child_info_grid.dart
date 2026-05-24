import 'package:flutter/material.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';
import 'package:new_mama/feature/children/presentation/widgets/premium_child_components.dart';

class ChildInfoGrid extends StatelessWidget {
  final Child child;

  const ChildInfoGrid({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final items = [
      InfoItem(
        icon: child.isBoy ? '👦' : '👧',
        label: context.trContext(TK.childrenGender),
        value: child.isBoy ? context.trContext(TK.childrenBoy) : context.trContext(TK.childrenGirl),
        accentColor: context.ext.colors.mentionBlue,
      ),
      InfoItem(
        icon: '🏥',
        label: context.trContext(TK.childrenDelivery),
        value: child.deliveryType == 'Normal'
            ? context.trContext(TK.childrenNormal)
            : context.trContext(TK.childrenCesarean),
        accentColor: context.ext.colors.backgroundGreen,
      ),
      InfoItem(
        icon: '🍼',
        label: context.trContext(TK.childrenFeeding),
        value: child.feedingTypeForBaby == 'Breastfeeding'
            ? context.trContext(TK.childrenBreastfeeding)
            : child.feedingTypeForBaby == 'Formula'
                ? context.trContext(TK.childrenFormula)
                : context.trContext(TK.childrenSolidFood),
        accentColor: context.ext.colors.accent,
      ),
      InfoItem(
        icon: '🎂',
        label: context.trContext(TK.childrenAge),
        value: '${child.ageInMonths}m ${child.ageInDays % 30}d',
        accentColor: context.ext.colors.primaryDark,
      ),
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: PremiumInfoCard(item: items[0])),
            16.width,
            Expanded(child: PremiumInfoCard(item: items[1])),
          ],
        ),
        16.height,
        Row(
          children: [
            Expanded(child: PremiumInfoCard(item: items[2])),
            16.width,
            Expanded(child: PremiumInfoCard(item: items[3])),
          ],
        ),
      ],
    );
  }
}
