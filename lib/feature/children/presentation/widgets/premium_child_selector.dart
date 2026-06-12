import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';
import 'package:new_mama/feature/children/presentation/cubit/active_child_cubit.dart';
import 'package:new_mama/feature/children/presentation/cubit/children_cubit.dart';
import 'package:new_mama/feature/children/presentation/cubit/children_state.dart';
import 'package:new_mama/feature/children/presentation/widgets/child_image_widget.dart';

class PremiumChildSelector extends StatelessWidget {
  const PremiumChildSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChildrenCubit, ChildrenState>(
      builder: (context, state) {
        final List<Child> children;
        if (state is ChildrenLoaded) {
          children = state.children;
        } else if (state is ChildActionSuccess) {
          children = state.children;
        } else {
          return const SizedBox.shrink();
        }

        if (children.isEmpty) return const SizedBox.shrink();

        return BlocBuilder<ActiveChildCubit, Child?>(
          builder: (context, activeChild) {
            // Auto-select first child if none selected
            if (activeChild == null && children.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<ActiveChildCubit>().setActiveChild(children.first);
              });
            }

            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: const BoxDecoration(
                color: Colors.transparent, // Avoid clipping shadows
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        Container(
                          width: 4.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: context.ext.colors.primaryDark,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                        8.width,
                        Text(
                          context.trContext(
                            TK.childrenMyChildren,
                          ), // Localized Title
                          style: context.text.titleSmall!.copyWith(
                            fontWeight: FontWeight.w800,
                            color: context.ext.colors.lightTextPrimary,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  12.height,
                  SizedBox(
                    height: 80.h, // Increased height to prevent shadow clipping
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ), // Added vertical padding
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none, // Allow shadows to spill out
                      itemCount: children.length,
                      separatorBuilder: (context, index) => 16.width,
                      itemBuilder: (context, index) {
                        final child = children[index];
                        final isSelected =
                            activeChild?.childId == child.childId;

                        return GestureDetector(
                          onTap: () => context
                              .read<ActiveChildCubit>()
                              .setActiveChild(child),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves
                                .easeOutBack, // Smoother than elastic for selective items
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isSelected
                                    ? [
                                        context.ext.colors.primaryDark,
                                        context.ext.colors.primaryAccent,
                                      ]
                                    : [
                                        context.theme.cardColor,
                                        context.theme.cardColor,
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : context.ext.colors.primaryLighter
                                          .withValues(alpha: 100),
                                width: 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: context.ext.colors.primaryDark
                                            .withValues(alpha: 80),
                                        blurRadius: 15,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 6),
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 10,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32.w,
                                  height: 32.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 100),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircularChildImageWidget(
                                    photoUrl: child.photoUrl,
                                    size: 32.w,
                                    fallback: Center(
                                      child: Text(
                                        child.isBoy ? '👦' : '👧',
                                        style: TextStyle(fontSize: 16.sp),
                                      ),
                                    ),
                                  ),
                                ),
                                10.width,
                                Text(
                                  child.fullName,
                                  style: context.text.bodyMedium!.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : context.ext.colors.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
