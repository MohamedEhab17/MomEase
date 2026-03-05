import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadedImageTile extends StatelessWidget {
  const UploadedImageTile({
    super.key,
    required this.imageFile,
    required this.onTapImage,
    required this.onTapRemove,
    required this.onTapCrop,
  });

  final File imageFile;
  final VoidCallback onTapImage;
  final VoidCallback onTapRemove;
  final VoidCallback onTapCrop;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTapImage,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              imageFile,
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.6,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            onTap: onTapRemove,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(150),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 16.r, color: Colors.white),
            ),
          ),
        ),
        Positioned(
          bottom: 6,
          right: 6,
          child: GestureDetector(
            onTap: onTapCrop,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(150),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.crop, size: 16.r, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
