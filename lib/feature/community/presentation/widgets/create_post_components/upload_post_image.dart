import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/helper/pick_image_helper.dart';
import 'package:new_mama/core/widgets/full_screen_local_gallery.dart';
import 'package:new_mama/feature/community/presentation/widgets/upload_post_image_components/add_more_image_tile.dart';
import 'package:new_mama/feature/community/presentation/widgets/upload_post_image_components/empty_upload_placeholder.dart';
import 'package:new_mama/feature/community/presentation/widgets/upload_post_image_components/uploaded_image_tile.dart';

class UploadPostImage extends StatefulWidget {
  const UploadPostImage({super.key, required this.onImagesChanged});
  final Function(List<File>) onImagesChanged;

  @override
  State<UploadPostImage> createState() => _UploadPostImageState();
}

class _UploadPostImageState extends State<UploadPostImage> {
  List<File> selectedImages = [];

  Future<void> _pickImages() async {
    final images = await ImagePickerHelper.pickMultipleFromGallery();
    if (images.isNotEmpty) {
      setState(() {
        selectedImages.addAll(images);
      });
      widget.onImagesChanged(selectedImages);
    }
  }

  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
    widget.onImagesChanged(selectedImages);
  }

  Future<void> _cropImage(File imageFile, int index) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Edit Image',
          toolbarColor: context.ext.colors.primaryDark,
          toolbarWidgetColor: context.colors.onSurface,
          activeControlsWidgetColor: context.ext.colors.primaryDark,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Edit Image'),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        selectedImages[index] = File(croppedFile.path);
      });
      widget.onImagesChanged(selectedImages);
    }
  }

  void _openGallery(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            FullScreenLocalGallery(images: selectedImages, initialIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (selectedImages.isEmpty) {
      return EmptyUploadPlaceholder(onTap: _pickImages);
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: selectedImages.length + 1,
        separatorBuilder: (_, _) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          if (index == selectedImages.length) {
            return AddMoreImageTile(onTap: _pickImages);
          }

          final imageFile = selectedImages[index];
          return UploadedImageTile(
            imageFile: imageFile,
            onTapImage: () => _openGallery(index),
            onTapRemove: () => _removeImage(index),
            onTapCrop: () => _cropImage(imageFile, index),
          );
        },
      ),
    );
  }
}
