import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';
import 'package:new_mama/feature/children/presentation/widgets/children_ui_components.dart';

class ChildProfileAvatar extends StatelessWidget {
  final Child child;
  final VoidCallback? onImageTap;
  final VoidCallback? onActionTap;

  const ChildProfileAvatar({
    super.key,
    required this.child,
    this.onImageTap,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isBoy = child.isBoy;
    final elementGradient = isBoy
        ? [context.ext.colors.primaryDark, context.ext.colors.primary]
        : [context.ext.colors.primaryAccent, context.ext.colors.primaryLighter];

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onTap: child.photoUrl != null ? onImageTap : onActionTap,
          child: Container(
            width: 130.w,
            height: 130.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: elementGradient[0].withAlpha(80),
                  blurRadius: 30,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(
                color: context.theme.cardColor,
                width: 4,
              ),
            ),
            child: child.photoUrl != null
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: child.photoUrl!.startsWith('http')
                          ? child.photoUrl!
                          : 'http://momease.runasp.net${child.photoUrl}',
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (_, __, ___) => GenderEmoji(child: child),
                    ),
                  )
                : GenderEmoji(child: child),
          ),
        ),
        GestureDetector(
          onTap: onActionTap,
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: context.theme.cardColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: context.colors.onSurface.withValues(alpha: 20),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              child.photoUrl != null
                  ? Icons.delete_outline_rounded
                  : Icons.camera_alt_rounded,
              size: 20.sp,
              color: child.photoUrl != null
                  ? context.colors.error
                  : elementGradient[1],
            ),
          ),
        ),
      ],
    );
  }
}
