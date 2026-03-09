import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/full_screen_image_gallery.dart';

class PostImageGrid extends StatelessWidget {
  final List<String> images;

  const PostImageGrid({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();

    final count = images.length;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: count > 1
            ? count == 2
                  ? 220.h
                  : 280.h
            : null,
        width: double.infinity,
        color: AppColors.backgroundPink,
        child: _buildGrid(context, count),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, int count) {
    switch (count) {
      case 1:
        return _buildImage(context, images[0], index: 0, fit: BoxFit.cover);
      case 2:
        return Row(
          children: [
            Expanded(
              child: _buildImage(
                context,
                images[0],
                index: 0,
                fit: BoxFit.cover,
              ),
            ),
            2.horizontalSpace,
            Expanded(
              child: _buildImage(
                context,
                images[1],
                index: 1,
                fit: BoxFit.cover,
              ),
            ),
          ],
        );
      case 3:
        return Row(
          children: [
            Expanded(flex: 2, child: _buildImage(context, images[0], index: 0)),
            2.horizontalSpace,
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(child: _buildImage(context, images[1], index: 1)),
                  2.verticalSpace,
                  Expanded(child: _buildImage(context, images[2], index: 2)),
                ],
              ),
            ),
          ],
        );
      case 4:
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildImage(context, images[0], index: 0)),
                  2.horizontalSpace,
                  Expanded(child: _buildImage(context, images[1], index: 1)),
                ],
              ),
            ),
            2.verticalSpace,
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildImage(context, images[2], index: 2)),
                  2.horizontalSpace,
                  Expanded(child: _buildImage(context, images[3], index: 3)),
                ],
              ),
            ),
          ],
        );
      default:
        // 5 or more images
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildImage(context, images[0], index: 0)),
                  2.horizontalSpace,
                  Expanded(child: _buildImage(context, images[1], index: 1)),
                ],
              ),
            ),
            2.verticalSpace,
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildImage(context, images[2], index: 2)),
                  2.horizontalSpace,
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _openGallery(context, 3),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _buildImage(
                            context,
                            images[3],
                            index: 3,
                            interactive: false,
                          ),
                          Container(
                            color: Colors.black.withAlpha(128),
                            alignment: Alignment.center,
                            child: Text(
                              '+${count - 4}',
                              style: AppStyles.styleInter24.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }

  void _openGallery(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            FullScreenImageGallery(images: images, initialIndex: initialIndex),
      ),
    );
  }

  Widget _buildImage(
    BuildContext context,
    String url, {
    BoxFit fit = BoxFit.cover,
    int index = 0,
    bool interactive = true,
  }) {
    final imageWidget = CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: double.infinity,
      placeholder: (_, _) => const Center(child: CircularProgressIndicator()),
      errorWidget: (_, _, _) =>
          const Center(child: Icon(Icons.error, color: AppColors.primary)),
    );

    if (!interactive) return imageWidget;

    return GestureDetector(
      onTap: () => _openGallery(context, index),
      child: imageWidget,
    );
  }
}
