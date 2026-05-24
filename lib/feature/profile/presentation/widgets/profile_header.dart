import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/helper/pick_image_helper.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/custom_network_image.dart';
import 'package:new_mama/core/widgets/delete_confirmation_dialog.dart';
import 'package:new_mama/feature/profile/presentation/view_model/profile_cubit.dart';
import 'package:new_mama/feature/profile/presentation/view_model/profile_state.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;
        if (profile == null) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.ext.colors.primaryLighter,
                context.ext.colors.primaryTint,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.r),
              bottomRight: Radius.circular(40.r),
            ),
          ),
          padding: EdgeInsetsDirectional.only(top: 60.h, bottom: 30.h),
          child: Column(
            children: [
              30.verticalSpace,
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomRight,
                children: [
                  GestureDetector(
                    onTap: () => _showPhotoOptions(context),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: CustomNetworkImage(
                          imageUrl: profile.profilePictureUrl ?? '',
                          width: 92.r,
                          height: 92.r,
                          placeholderWidget: (context, url) => Container(
                            color: context.ext.colors.greyExtraLight,
                            child: Icon(
                              Icons.person,
                              size: 50.r,
                              color: context.colors.primary.withAlpha(100),
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.person,
                            size: 50.r,
                            color: context.colors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    bottom: 0,
                    end: 0,
                    child: GestureDetector(
                      onTap: () => _pickAndUploadPhoto(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                  ),
                  if (state.status == ProfileStatus.uploadingPhoto ||
                      state.status == ProfileStatus.deletingPhoto)
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
              16.verticalSpace,
              Text(
                '${profile.firstName} ${profile.lastName}',
                style: context.text.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colors.onSurface.withAlpha(200),
                ),
              ),
              4.verticalSpace,
              Text(
                profile.email,
                style: context.text.bodyLarge!.copyWith(
                  color: context.colors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(context.trContext(TK.communityGallery)),
              onTap: () {
                context.pop();
                _pickAndUploadPhoto(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(
                context.trContext(TK.childrenRemove),
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                context.pop();
                _confirmDeletePhoto(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUploadPhoto(BuildContext context) async {
    final File? image = await ImagePickerHelper.pickFromGallery();
    if (image != null && context.mounted) {
      context.read<ProfileCubit>().uploadPhoto(image.path);
    }
  }

  Future<void> _confirmDeletePhoto(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: context.trContext(TK.profileDeletePhotoTitle),
        content: context.trContext(TK.profileDeletePhotoContent),
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<ProfileCubit>().deletePhoto();
    }
  }
}
