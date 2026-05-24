import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';
import 'package:new_mama/feature/children/presentation/cubit/children_cubit.dart';
import 'package:new_mama/feature/children/presentation/cubit/children_state.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/feature/children/presentation/widgets/child_card.dart';
import 'package:shimmer/shimmer.dart';

class ChildrenSection extends StatelessWidget {
  const ChildrenSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ChildrenCubit>()..loadChildren(),
      child: const _ChildrenSectionBody(),
    );
  }
}

class _ChildrenSectionBody extends StatelessWidget {
  const _ChildrenSectionBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Text(
                '${context.trContext(TK.childrenMyChildren)} 👶',
                style: context.text.titleLarge!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              // View all
              GestureDetector(
                onTap: () => context.push(AppRoutesPaths.childrenListView),
                child: Text(
                  context.trContext(TK.commonViewAll),
                  style: context.text.bodyMedium!.copyWith(
                    color: context.ext.colors.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              12.width,
              // Add button
              GestureDetector(
                onTap: () => context.push(AppRoutesPaths.addChildView),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.ext.colors.primaryExtraLight,
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    size: 20.sp,
                    color: context.ext.colors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
        ),
        12.height,
        BlocBuilder<ChildrenCubit, ChildrenState>(
          builder: (context, state) {
            if (state is ChildrenLoading) {
              return _LoadingShimmer();
            }

            List<Child> children = [];
            if (state is ChildrenLoaded) children = state.children;
            if (state is ChildActionSuccess) children = state.children;
            if (state is ChildrenActionLoading) children = state.children;

            if (children.isEmpty) {
              return _EmptyBanner(
                onTap: () => context.push(AppRoutesPaths.addChildView),
              );
            }

            return SizedBox(
              height: 190.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: children.length,
                itemBuilder: (_, i) {
                  final child = children[i];
                  return ChildCard(
                    child: child,
                    onTap: () => context.push(
                      AppRoutesPaths.childDetailView,
                      extra: child,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: 3,
        separatorBuilder: (_, _) => 12.width,
        itemBuilder: (_, _) => Shimmer.fromColors(
          baseColor: context.ext.colors.greyExtraLight,
          highlightColor: context.ext.colors.greyLight,
          child: Container(
            width: 150.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptyBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.ext.colors.primaryExtraLight,
              context.ext.colors.primaryTint,
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: context.ext.colors.primaryLighter.withAlpha(80),
          ),
        ),
        child: Row(
          children: [
            Text('👶', style: TextStyle(fontSize: 40.sp)),
            16.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.trContext(TK.childrenAddFirstBaby),
                    style: context.text.titleMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  4.height,
                  Text(
                    context.trContext(TK.childrenAddFirstBabySubtitle),
                    style: context.text.bodySmall!.copyWith(
                      color: context.ext.colors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.add_circle_rounded,
              color: context.ext.colors.primaryDark,
              size: 32.sp,
            ),
          ],
        ),
      ),
    );
  }
}
