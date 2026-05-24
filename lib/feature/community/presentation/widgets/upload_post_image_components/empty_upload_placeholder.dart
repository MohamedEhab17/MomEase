import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';
import 'package:new_mama/core/widgets/animated_dotted_container.dart';

class EmptyUploadPlaceholder extends StatelessWidget {
  const EmptyUploadPlaceholder({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedDottedContainer(
        color: context.colors.primary,
        dashPattern: const [16, 12],
        borderRadius: BorderRadius.circular(16),
        strokeWidth: 3.w,
        child: Container(
          height: 184.h,
          width: double.infinity,
          color: context.ext.colors.backgroundPink,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 42.r,
                backgroundColor: context.colors.surface,
                child: Transform.translate(
                  offset: const Offset(2, 0),
                  child: SvgPicture.asset(
                    AppIcons.iconsAddPhoto,
                    width: 38.w,

                    colorMapper: AppSvgColorMapper(
                      from: Color(0xffFF3381),
                      to: context.ext.colors.primaryDark,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(context.trContext(TK.communityAddPhotos), style: context.text.headlineMedium!),
            ],
          ),
        ),
      ),
    );
  }
}
