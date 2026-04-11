import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/widgets/animated_dotted_container.dart';

class AddMoreImageTile extends StatelessWidget {
  const AddMoreImageTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedDottedContainer(
        color: context.colors.primary,
        dashPattern: const [8, 6],
        borderRadius: BorderRadius.circular(16),
        strokeWidth: 2.w,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.6,

          color: context.ext.colors.backgroundPink,
          alignment: .center,
          child: Column(
            mainAxisAlignment: .center,
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundColor: context.colors.surface,
                child: Transform.translate(
                  offset: const Offset(2, 0),
                  child: Icon(
                    Icons.add_photo_alternate,
                    color: context.colors.primary,
                    size: 32.r,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text("Add More", style: context.text.titleLarge!),
            ],
          ),
        ),
      ),
    );
  }
}
