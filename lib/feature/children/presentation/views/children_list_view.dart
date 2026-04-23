import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';
import 'package:new_mama/feature/children/presentation/cubit/children_cubit.dart';
import 'package:new_mama/feature/children/presentation/cubit/children_state.dart';
import 'package:new_mama/feature/children/presentation/widgets/child_card.dart';
import 'package:new_mama/feature/children/presentation/widgets/children_ui_components.dart';
import 'package:new_mama/feature/children/presentation/widgets/empty_children_state.dart';

class ChildrenListView extends StatelessWidget {
  const ChildrenListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChildrenCubit, ChildrenState>(
      listener: (context, state) {
        if (state is ChildrenError) {
          AppToast.error(context, message: state.message);
        }
      },
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        body: BlocBuilder<ChildrenCubit, ChildrenState>(
          builder: (context, state) {
            List<Child> children = [];
            if (state is ChildrenLoaded) children = state.children;
            if (state is ChildActionSuccess) children = state.children;
            if (state is ChildrenActionLoading) children = state.children;

            return RefreshIndicator(
              onRefresh: () => context.read<ChildrenCubit>().loadChildren(),
              color: context.ext.colors.primaryDark,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  // Premium Sliver Header
                  SliverAppBar(
                    expandedHeight: 200.h,
                    pinned: true,
                    stretch: true,
                    backgroundColor: context.theme.scaffoldBackgroundColor,
                    leading: IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: context.theme.cardColor.withValues(alpha: 200),
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
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                      ],
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          ChildBackgroundDecoration(
                            colors: [
                              context.ext.colors.primaryTint,
                              context.ext.colors.backgroundBlue,
                            ],
                            blurSigma: 30,
                          ),
                          PositionedDirectional(
                            start: 24.w,
                            bottom: 24.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  context.trContext(TK.childrenMyChildren),
                                  style: context.text.displaySmall!.copyWith(
                                    fontWeight: FontWeight.w800,
                                    height: 1.1,
                                    color: context.ext.colors.primaryDark,
                                  ),
                                ),
                                8.height,
                                Text(
                                  children.isEmpty
                                      ? context.trContext(TK.childrenSpaceLittleOnes)
                                      : context.trContext(TK.childrenYouHaveBabies, namedArgs: {'count': children.length.toString()}),
                                  style: context.text.titleSmall!.copyWith(
                                    color: context.ext.colors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Loading State
                  if (state is ChildrenLoading)
                    SliverFillRemaining(
                      child: Center(
                        child: CustomLoadingIndicator(
                            color: context.colors.primary),
                      ),
                    )
                  // Empty State
                  else if (children.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyChildrenState(
                        onAdd: () => context.push(AppRoutesPaths.addChildView),
                      ),
                    )
                  // Grid View
                  else
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.w,
                          mainAxisSpacing: 16.h,
                          childAspectRatio: 0.72,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final child = children[index];
                            return ChildCard(
                              child: child,
                              onTap: () => context.push(
                                AppRoutesPaths.childDetailView,
                                extra: child,
                              ),
                            );
                          },
                          childCount: children.length,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push(AppRoutesPaths.addChildView),
          backgroundColor: context.ext.colors.primaryDark,
          icon: Icon(Icons.add_rounded, color: context.colors.onPrimary, size: 22.sp),
          label: Text(
            context.trContext(TK.childrenAddBaby),
            style: context.text.titleMedium!.copyWith(
              color: context.colors.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
      ),
    );
  }
}


