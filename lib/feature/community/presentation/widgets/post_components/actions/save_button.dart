import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';
import 'package:new_mama/core/widgets/delete_confirmation_dialog.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';

class SaveButton extends StatelessWidget {
  final PostModel post;
  final AnimateToController controller;
  final bool removeOnUnsave;

  const SaveButton({
    super.key,
    required this.post,
    required this.controller,
    required this.removeOnUnsave,
  });

  @override
  Widget build(BuildContext context) {
    final isSaved = post.isSaved;
    final saveTag = 'save_${post.postId}';

    return GestureDetector(
      onTap: () async {
        if (isSaved && removeOnUnsave) {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (_) => DeleteConfirmationDialog(
              title: context.trContext(TK.communityUnsavePostTitle),
              content: context.trContext(TK.communityUnsavePostContent),
            ),
          );
          if (confirm != true) return;
        }
        if (!isSaved) controller.animateTag(saveTag);
        if (context.mounted) {
          context.read<CommunityCubit>().toggleSave(
                post.postId,
                removeOnUnsave: removeOnUnsave,
              );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 113.w,
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: isSaved
              ? context.ext.colors.primaryDark.withAlpha(31)
              : context.ext.colors.primaryLighter.withAlpha(77),
          borderRadius: BorderRadius.circular(16),
          border: isSaved
              ? Border.all(
                  color: context.ext.colors.primaryDark.withAlpha(76),
                  width: 1)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimateFrom(
              key: controller.tag(saveTag),
              child: SvgPicture.asset(
                isSaved ? AppIcons.iconsFilledSave : AppIcons.iconsUnfilledSave,
                width: 16,
                height: 16,
                colorMapper: AppSvgColorMapper(
                  from: const Color(0xffFF3381),
                  to: context.ext.colors.primaryDark,
                ),
              ),
            ),
            6.width,
            Text(
              context.trContext(TK.communitySaved),
              style: context.text.bodyMedium!.copyWith(
                color: context.ext.colors.primaryDark,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
