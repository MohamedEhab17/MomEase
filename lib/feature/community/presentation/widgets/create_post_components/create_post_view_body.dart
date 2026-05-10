import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/widgets/create_post_components/create_post_header.dart';
import 'package:new_mama/feature/community/presentation/widgets/create_post_components/upload_post_image.dart';

class CreatePostViewBody extends StatefulWidget {
  const CreatePostViewBody({super.key});

  @override
  State<CreatePostViewBody> createState() => _CreatePostViewBodyState();
}

class _CreatePostViewBodyState extends State<CreatePostViewBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,

      padding: 20.hPadding,
      child: Column(
        children: [
          CreatePostHeader(),
          36.height,
          UploadPostImage(
            onImagesChanged: (List<File> images) {
              postImages = images;
            },
          ),
          44.height,
          TextFormFieldHelper(
            controller: _postContentController,
            borderRadius: BorderRadius.circular(16.r),
            fillColor: context.colors.surface,
            hint: context.trContext(TK.communityCreatePostHint),
            maxLines: 8,
            minLines: 8,
          ),
          44.height,
          ValueListenableBuilder(
            valueListenable: _postContentController,
            builder: (context, value, child) {
              // final hasText = value.text.trim().isNotEmpty;
              return CustomElevatedButton(
                backgroundColor: _postContentController.text.isNotEmpty
                    ? context.ext.colors.primaryDark
                    : context.ext.colors.primaryLighter,
                minimumSize: Size(double.infinity, 52.h),
                textStyle: context.text.headlineMedium!.copyWith(
                  color: context.theme.buttonTheme.colorScheme!.onPrimary,
                ),
                text: context.trContext(TK.communityPostButton),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (_postContentController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          context.trContext(TK.communityPostContentRequired),
                        ),
                      ),
                    );
                    return;
                  }
                  // Handle post submission logic here, including the post content and image.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.trContext(TK.communityPostsu)),
                    ),
                  );
                  context.read<CommunityCubit>().createPost(
                        text: _postContentController.text,
                        mediaFiles: postImages.map((e) => e.path).toList(),
                      );
                  _postContentController.clear();
                  context.pop(context);
                },
              );
            },
          ),
          12.height,
          Text(
            context.trContext(TK.communityShareMoment),
            style: context.text.bodyMedium!.copyWith(
              fontWeight: FontWeight.normal,
              color: context.colors.onSurface.withAlpha(128),
            ),
          ),
        ],
      ),
    );
  }

  late TextEditingController _postContentController;
  List<File> postImages = [];
  @override
  void initState() {
    super.initState();
    _postContentController = TextEditingController();
  }
}
