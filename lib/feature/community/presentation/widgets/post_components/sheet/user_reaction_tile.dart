import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/community/data/models/reaction_model.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/reaction_picker.dart';

class UserReactionTile extends StatelessWidget {
  final ReactionModel reaction;
  const UserReactionTile({super.key, required this.reaction});

  String? get _resolvedPhotoUrl {
    final photo = reaction.userPhoto;
    if (photo == null || photo.isEmpty) return null;
    return photo.startsWith('http') ? photo : 'http://momease.runasp.net$photo';
  }

  @override
  Widget build(BuildContext context) {
    final config = ReactionConfig.byType(reaction.reactionType);
    final resolvedPhoto = _resolvedPhotoUrl;
    final trimmedName = reaction.userName.trim();
    final initials = trimmedName.isNotEmpty
        ? trimmedName
            .split(' ')
            .where((w) => w.isNotEmpty)
            .map((w) => w[0])
            .take(2)
            .join()
        : '?';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          //  Avatar with reaction badge ────────────────────────
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor: config?.color.withAlpha(38) ??
                    context.ext.colors.primaryLighter.withAlpha(102),
                backgroundImage: resolvedPhoto != null
                    ? CachedNetworkImageProvider(resolvedPhoto)
                    : null,
                child: resolvedPhoto == null
                    ? Text(
                        initials.toUpperCase(),
                        style: TextStyle(
                          color:
                              config?.color ?? context.ext.colors.primaryDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
                        ),
                      )
                    : null,
              ),
              // Small reaction badge at bottom-right
              if (config != null)
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 18.r,
                    height: 18.r,
                    decoration: BoxDecoration(
                      color: config.color.withAlpha(38),
                      shape: BoxShape.circle,
                      border: Border.all(
                         color: context.theme.scaffoldBackgroundColor,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        config.icon,
                        size: 10.sp,
                        color: config.color,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          14.width,

          //  Name 
          Expanded(
            child: Text(
              reaction.userName,
              style: context.text.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Reaction type label 
          if (config != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(config.icon, size: 14.sp, color: config.color),
                4.width,
                Text(
                  _getLocalizedReaction(context, config.type),
                  style: TextStyle(
                    color: config.color,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _getLocalizedReaction(BuildContext context, String type) {
    if (context.isAr) {
      switch (type) {
        case 'LIKE': return 'إعجاب';
        case 'LOVE': return 'أحببته';
        case 'SUPPORT': return 'دعم';
        case 'HELPFUL': return 'مفيد';
        default: return type;
      }
    }
    return type[0] + type.substring(1).toLowerCase();
  }
}
