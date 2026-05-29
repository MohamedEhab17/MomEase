import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/widgets/custom_network_image.dart';
import 'package:new_mama/feature/profile/presentation/view_model/profile_cubit.dart';
import 'package:new_mama/feature/profile/presentation/view_model/profile_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DrawerUserHeader extends StatelessWidget {
  final Animation<double> animation;

  const DrawerUserHeader({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
    );

    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return AnimatedBuilder(
      animation: curved,
      builder: (context, _) {
        final offsetX = isRTL
            ? 40 * (1 - curved.value)
            : -40 * (1 - curved.value);

        return Transform.translate(
          offset: Offset(offsetX, 0),
          child: Opacity(
            opacity: curved.value.clamp(0.0, 1.0),
            child: Container(
              padding: EdgeInsetsDirectional.only(
                top: MediaQuery.of(context).padding.top + 24.h,
                bottom: 24.h,
                start: 24.w,
                end: 24.w,
              ),
              decoration: BoxDecoration(
                color: context.colors.primary,
                borderRadius: BorderRadiusDirectional.only(
                  bottomEnd: Radius.circular(30.r),
                  bottomStart: Radius.circular(30.r),
                ),
                gradient: LinearGradient(
                  colors: [
                    context.colors.primary,
                    context.ext.colors.primaryLight,
                  ],
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.theme.shadowColor.withAlpha(63),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  final profile = state.profile;
                  final isLoading = state.status == ProfileStatus.loading && profile == null;

                  String name = isLoading ? 'Loading Name' : (profile != null ? '${profile.firstName} ${profile.lastName}' : 'Guest User');
                  String email = isLoading ? 'loading.email@example.com' : (profile != null ? profile.email : 'Could not load profile');
                  String? imageUrl = profile?.profilePictureUrl;

                  return Skeletonizer(
                    enabled: isLoading,
                    child: Row(
                      children: [
                        ClipOval(
                          child: Container(
                            width: 60.r,
                            height: 60.r,
                            color: context.theme.cardColor,
                            child: (imageUrl != null && imageUrl.isNotEmpty)
                                ? CustomNetworkImage(
                                    imageUrl: imageUrl,
                                    width: 60.r,
                                    height: 60.r,
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.person,
                                      size: 30.sp,
                                      color: context.colors.primary,
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 30.sp,
                                    color: context.colors.primary,
                                  ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: context.text.displaySmall!.copyWith(
                                  color: context.ext.colors.lightTextPrimary,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                email,
                                style: context.text.titleSmall!.copyWith(
                                  color: context.ext.colors.lightTextPrimary,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
