import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
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
            fillColor: AppColors.lightBackground,
            hint: "Share your store or your thoughts...",
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
                    ? AppColors.primaryDark
                    : AppColors.primaryLighter,
                minimumSize: Size(double.infinity, 52.h),
                textStyle: AppStyles.styleInter20.copyWith(
                  color: AppColors.darkTextPrimary,
                ),
                text: "Post",
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (_postContentController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please enter some content for the post.",
                        ),
                      ),
                    );
                    return;
                  }
                  // Handle post submission logic here, including the post content and image.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Post submitted successfully!"),
                    ),
                  );
                  context.read<CommunityCubit>().createPost(
                    PostModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      userName: "Mohamed",
                      userImage: "https://i.pravatar.cc/150?img=2",
                      text: _postContentController.text,
                      images: postImages.map((e) => e.path).toList(),
                      likes: 0,
                      comments: 0,
                      saves: 0,
                      isLiked: false,
                      isSaved: false,
                    ),
                  );
                  _postContentController.clear();
                  context.pop(context);
                },
              );
            },
          ),
          12.height,
          Text(
            "Share your moment with community",
            style: AppStyles.styleInter12.copyWith(
              fontWeight: FontWeight.normal,
              color: AppColors.lightTextPrimary.withAlpha(128),
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
