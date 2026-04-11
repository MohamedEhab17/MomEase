import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class ProfileHeader extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String subtitle;

  const ProfileHeader({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.ext.colors.primaryLighter,
            context.ext.colors.primaryTint,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.r),
          bottomRight: Radius.circular(40.r),
        ),
      ),
      padding: EdgeInsets.only(top: 60.h, bottom: 30.h),
      child: Column(
        children: [
          30.verticalSpace,
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 46.r,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
          16.verticalSpace,
          Text(
            name,
            style: context.text.headlineMedium!.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colors.onSurface.withAlpha(200),
            ),
          ),
          4.verticalSpace,
          Text(
            subtitle,
            style: context.text.bodyLarge!.copyWith(
              color: context.colors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
