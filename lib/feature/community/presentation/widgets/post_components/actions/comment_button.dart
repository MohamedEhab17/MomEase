import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/widgets/comment_components/comments_modal_sheet.dart';

class CommentButton extends StatelessWidget {
  final PostModel post;
  const CommentButton({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final communityCubit = context.read<CommunityCubit>();
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => BlocProvider.value(
            value: communityCubit,
            child: CommentsModalSheet(
              postId: post.postId.toString(),
              postUserId: post.userId,
              initialCommentCount: post.commentsCount,
            ),
          ),
        );
      },
      child: Container(
        width: 113.w,
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: context.ext.colors.primaryLighter.withAlpha(77),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.iconsComment,
              width: 16,
              height: 16,
              colorMapper: AppSvgColorMapper(
                from: const Color(0xffFF3381),
                to: context.ext.colors.primaryDark,
              ),
            ),
            6.width,
            Text(
              context.trContext(TK.communityComment),
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
