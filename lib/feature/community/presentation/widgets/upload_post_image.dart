import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/helper/pick_image_helper.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/animated_dotted_container.dart';

class UploadPostImage extends StatefulWidget {
  const UploadPostImage({super.key, required this.onImageChanged});
  final Function(File?) onImageChanged;

  @override
  State<UploadPostImage> createState() => _UploadPostImageState();
}

class _UploadPostImageState extends State<UploadPostImage> {
  File? selectedImage;

  Future<void> _pickImage() async {
    final image = await ImagePickerHelper.pickFromGallery();
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
      widget.onImageChanged(image);
    }
  }

  void _openPreview() {
    if (selectedImage == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: Hero(
                tag: "previewImage",
                child: Image.file(selectedImage!),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectedImage == null ? _pickImage : _openPreview,
      child: selectedImage != null
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                Hero(
                  tag: "previewImage",
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: ClipRRect(
                      key: ValueKey(selectedImage!.path),
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.file(selectedImage!, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 12,
                  right: 12,
                  child: _buildCircleButton(
                    icon: Icons.close,
                    onTap: () {
                      setState(() {
                        selectedImage = null;
                        widget.onImageChanged(null);
                      });
                    },
                  ),
                ),

                Positioned(
                  top: 12,
                  left: 12,
                  child: _buildCircleButton(
                    icon: Icons.edit,
                    onTap: _pickImage,
                  ),
                ),
              ],
            )
          : AnimatedDottedContainer(
              color: AppColors.primary,
              dashPattern: [16, 12],
              borderRadius: BorderRadius.circular(16),
              strokeWidth: 3.w,
              child: Container(
                height: 184.h,
                width: double.infinity,
                color: AppColors.lightBackground2,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .center,
                  spacing: 20,
                  children: [
                    CircleAvatar(
                      radius: 42.r,
                      backgroundColor: AppColors.lightBackground,
                      child: Transform.translate(
                        offset: const Offset(2, 0),
                        child: SvgPicture.asset(
                          AppIcons.iconsAddPhoto,
                          width: 38.w,
                        ),
                      ),
                    ),
                    Text("Add a Photo", style: AppStyles.styleInter20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        width: 36,
        decoration: const BoxDecoration(
          color: AppColors.lightBackground,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 20, color: AppColors.primaryHard),
      ),
    );
  }
}
