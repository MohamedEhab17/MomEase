import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/animated_dotted_container.dart';

class AddMoreImageTile extends StatelessWidget {
  const AddMoreImageTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedDottedContainer(
        color: AppColors.primary,
        dashPattern: const [8, 6],
        borderRadius: BorderRadius.circular(16),
        strokeWidth: 2.w,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.6,

          color: AppColors.lightBackground2,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundColor: AppColors.lightBackground,
                child: Transform.translate(
                  offset: const Offset(2, 0),
                  child: Icon(
                    Icons.add_photo_alternate,
                    color: AppColors.primary,
                    size: 32.r,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text("Add More", style: AppStyles.styleInter16),
            ],
          ),
        ),
      ),
    );
  }
}
