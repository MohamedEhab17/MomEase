import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_mama/core/helpers/child_image_helper.dart';

/// A robust, reusable image widget for displaying a child's profile photo.
///
/// ### Behaviour
/// - If [photoUrl] resolves to a valid URL, displays a [CachedNetworkImage]
///   with a shimmer [placeholder] and an asset [errorWidget].
/// - If [photoUrl] is null / empty, displays [fallback] (defaults to the local
///   `baby_placeholder.png` asset).
/// - Never throws or causes a red-screen from an image error.
///
/// ### Usage
/// ```dart
/// ChildImageWidget(
///   photoUrl: child.photoUrl,
///   width: 72,
///   height: 72,
///   fit: BoxFit.cover,
/// )
/// ```
class ChildImageWidget extends StatelessWidget {
  const ChildImageWidget({
    super.key,
    required this.photoUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallback,
    this.borderRadius,
    this.clipBehavior = Clip.antiAlias,
  });

  /// Raw URL or relative path from the API. May be null or empty.
  final String? photoUrl;

  final double? width;
  final double? height;
  final BoxFit fit;

  /// Widget to display when [photoUrl] is empty. Defaults to the asset placeholder.
  final Widget? fallback;

  /// Wraps the image in a [ClipRRect] with this radius when provided.
  final BorderRadius? borderRadius;

  final Clip clipBehavior;

  // ── Asset placeholder path ────────────────────────────────────────────────

  static const String _placeholderAsset = 'assets/images/baby_placeholder.png';

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final String resolvedUrl = ChildImageHelper.getChildImageUrl(photoUrl);

    Widget image;

    if (resolvedUrl.isEmpty) {
      image = fallback ?? _assetPlaceholder();
    } else {
      image = CachedNetworkImage(
        imageUrl: resolvedUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => _shimmerPlaceholder(),
        errorWidget: (context, url, error) => _assetPlaceholder(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        clipBehavior: clipBehavior,
        child: SizedBox(width: width, height: height, child: image),
      );
    }

    return SizedBox(width: width, height: height, child: image);
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  Widget _assetPlaceholder() {
    return Image.asset(
      _placeholderAsset,
      width: width,
      height: height,
      fit: fit,
    );
  }

  Widget _shimmerPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF3E5F5), // soft lavender
    );
  }
}

/// A circular variant of [ChildImageWidget] for avatar usage.
///
/// Wraps the image in a [ClipOval] and handles the placeholder / error
/// identically to [ChildImageWidget].
class CircularChildImageWidget extends StatelessWidget {
  const CircularChildImageWidget({
    super.key,
    required this.photoUrl,
    required this.size,
    this.fallback,
    this.fit = BoxFit.cover,
  });

  final String? photoUrl;
  final double size;
  final BoxFit fit;

  /// Widget to display when no photo is available (e.g. gender emoji).
  final Widget? fallback;

  static const String _placeholderAsset = 'assets/images/baby_placeholder.png';

  @override
  Widget build(BuildContext context) {
    final String resolvedUrl = ChildImageHelper.getChildImageUrl(photoUrl);

    Widget image;

    if (resolvedUrl.isEmpty) {
      image = fallback ??
          Image.asset(
            _placeholderAsset,
            width: size,
            height: size,
            fit: fit,
          );
    } else {
      image = CachedNetworkImage(
        imageUrl: resolvedUrl,
        width: size,
        height: size,
        fit: fit,
        placeholder: (context, url) => Container(
          width: size,
          height: size,
          color: const Color(0xFFF3E5F5),
        ),
        errorWidget: (context, url, error) => Image.asset(
          _placeholderAsset,
          width: size,
          height: size,
          fit: fit,
        ),
      );
    }

    return ClipOval(child: SizedBox(width: size, height: size, child: image));
  }
}
