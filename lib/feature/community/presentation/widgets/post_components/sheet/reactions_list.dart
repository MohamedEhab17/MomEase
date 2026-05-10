import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/community/data/models/reaction_model.dart';
import 'user_reaction_tile.dart';

class ReactionsList extends StatelessWidget {
  final List<ReactionModel> reactions;
  const ReactionsList({super.key, required this.reactions});

  @override
  Widget build(BuildContext context) {
    if (reactions.isEmpty) {
      return Center(
        child: Text(
          context.isAr ? 'لا توجد تفاعلات' : 'No reactions',
          style: context.text.bodyMedium!.copyWith(
            color: context.colors.onSurface.withAlpha(102),
          ),
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      itemCount: reactions.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        color: context.colors.onSurface.withAlpha(15),
      ),
      itemBuilder: (_, i) => UserReactionTile(reaction: reactions[i]),
    );
  }
}
