import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/widgets/custom_network_image.dart';
import 'package:new_mama/core/widgets/full_screen_image_gallery.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';

class PostImageGrid extends StatelessWidget {
  final List<PostMedia> media;

  const PostImageGrid({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    if (media.isEmpty) return const SizedBox.shrink();

    final count = media.length;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: count > 1
            ? count == 2
                ? 220.h
                : 280.h
            : 250.h,
        width: double.infinity,
        color: context.ext.colors.backgroundPink,
        child: _buildGrid(context, count),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, int count) {
    switch (count) {
      case 1:
        return _buildImage(context, media[0].mediaUrl, index: 0, fit: BoxFit.cover);
      case 2:
        return Row(
          children: [
            Expanded(
              child: _buildImage(
                context,
                media[0].mediaUrl,
                index: 0,
                fit: BoxFit.cover,
              ),
            ),
            2.horizontalSpace,
            Expanded(
              child: _buildImage(
                context,
                media[1].mediaUrl,
                index: 1,
                fit: BoxFit.cover,
              ),
            ),
          ],
        );
      case 3:
        return Row(
          children: [
            Expanded(flex: 2, child: _buildImage(context, media[0].mediaUrl, index: 0)),
            2.horizontalSpace,
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(child: _buildImage(context, media[1].mediaUrl, index: 1)),
                  2.verticalSpace,
                  Expanded(child: _buildImage(context, media[2].mediaUrl, index: 2)),
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
                  Expanded(child: _buildImage(context, media[0].mediaUrl, index: 0)),
                  2.horizontalSpace,
                  Expanded(child: _buildImage(context, media[1].mediaUrl, index: 1)),
                ],
              ),
            ),
            2.verticalSpace,
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildImage(context, media[2].mediaUrl, index: 2)),
                  2.horizontalSpace,
                  Expanded(child: _buildImage(context, media[3].mediaUrl, index: 3)),
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
                  Expanded(child: _buildImage(context, media[0].mediaUrl, index: 0)),
                  2.horizontalSpace,
                  Expanded(child: _buildImage(context, media[1].mediaUrl, index: 1)),
                ],
              ),
            ),
            2.verticalSpace,
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildImage(context, media[2].mediaUrl, index: 2)),
                  2.horizontalSpace,
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _openGallery(context, 3),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _buildImage(
                            context,
                            media[3].mediaUrl,
                            index: 3,
                            interactive: false,
                          ),
                          Container(
                            color: Colors.black.withAlpha(128),
                            alignment: Alignment.center,
                            child: Text(
                              '+${count - 4}',
                              style: context.text.displaySmall!.copyWith(
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
        builder: (_) => FullScreenImageGallery(
          images: media.map((e) => e.mediaUrl).toList(),
          initialIndex: initialIndex,
          showDownloadButton: true, // Enable download for community posts
        ),
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
    final imageWidget = CustomNetworkImage(
      imageUrl: url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
    );

    if (!interactive) return imageWidget;

    return GestureDetector(
      onTap: () => _openGallery(context, index),
      child: imageWidget,
    );
  }
}
