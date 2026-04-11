import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';

class ProfilePostPreviewCard extends StatelessWidget {
  final PostModel post;
  final String timeText;

  const ProfilePostPreviewCard({
    super.key,
    required this.post,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.ext.colors.primaryTint.withAlpha(150),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundImage: NetworkImage(post.userImage),
              ),
              8.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      post.userName,
                      style: context.text.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.colors.onSurface.withAlpha(200),
                      ),
                    ),
                    2.height,
                    Text(
                      timeText,
                      style: context.text.bodySmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.height,
          Text(
            post.text,
            style: context.text.bodyLarge!.copyWith(
              color: context.colors.onSurface.withAlpha(200),
              height: 1.5,
            ),
          ),
          if (post.images.isNotEmpty) ...[
            12.height,
            Container(
              height: 120.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.ext.colors.greyExtraLight.withAlpha(100),
                borderRadius: BorderRadius.circular(16.r),
                image: DecorationImage(
                  image: NetworkImage(post.images.first),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          12.height,
          Row(
            children: [
              SvgPicture.asset(
                AppIcons.iconsUnfilledLike,
                width: 14.w,
                colorFilter: ColorFilter.mode(
                  context.colors.primary,
                  BlendMode.srcIn,
                ),
              ),
              6.width,
              Text(
                post.likes.toString(),
                style: context.text.bodySmall!.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              16.width,
              SvgPicture.asset(
                AppIcons.iconsComment,
                width: 14.w,
                colorFilter: ColorFilter.mode(
                  context.colors.primary,
                  BlendMode.srcIn,
                ),
              ),
              6.width,
              Text(
                post.comments.toString(),
                style: context.text.bodySmall!.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              SvgPicture.asset(
                AppIcons.iconsUnfilledSave,
                width: 14.w,
                colorFilter: ColorFilter.mode(
                  context.colors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
