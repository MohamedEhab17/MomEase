import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';
import 'package:new_mama/feature/children/presentation/widgets/detail_components/child_profile_avatar.dart';

class ChildDetailAppBar extends StatelessWidget {
  final Child child;
  final VoidCallback onDelete;
  final VoidCallback? onImageTap;
  final VoidCallback? onActionTap;

  const ChildDetailAppBar({
    super.key,
    required this.child,
    required this.onDelete,
    this.onImageTap,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320.h,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: context.theme.cardColor.withAlpha(200),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.colors.onSurface,
            size: 18.sp,
          ),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: context.theme.cardColor.withAlpha(200),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.edit_outlined,
              color: context.colors.onSurface,
              size: 20.sp,
            ),
          ),
          onPressed: () => context.push(
            AppRoutesPaths.addChildView,
            extra: child,
          ),
        ),
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: context.colors.error.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              color: context.colors.error,
              size: 20.sp,
            ),
          ),
          onPressed: onDelete,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              40.height,
              ChildProfileAvatar(
                child: child,
                onImageTap: onImageTap,
                onActionTap: onActionTap,
              ),
              20.height,
              Text(
                child.fullName,
                style: context.text.headlineMedium!.copyWith(
                  color: context.colors.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
              6.height,
              Container(
                padding: 6.vhPadding,
                decoration: BoxDecoration(
                  color: context.theme.cardColor.withValues(alpha: 200),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  child.ageLabel,
                  style: context.text.titleSmall!.copyWith(
                    color: context.ext.colors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
