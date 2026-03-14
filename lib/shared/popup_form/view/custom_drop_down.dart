import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hintText;
  final String? label;
  final bool isVisible;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText = "Select",
    this.label,
    this.isVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: isVisible,
          child: Text(label ?? "", style: AppStyles.styleInter14),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(64.r),
            border: Border.all(color: AppColors.primaryDark),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              focusColor: Colors.transparent,
              dropdownColor: AppColors.lightBackground,
              value: value,
              hint: Text(hintText, style: AppStyles.styleInter12),
              isExpanded: true,
              icon: SvgPicture.asset(
                AppIcons.iconsArrowDropDown,
                height: 7.h,
                width: 11.w,
              ),
              menuMaxHeight: MediaQuery.sizeOf(context).height * 0.3,
              items: items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: AppStyles.styleInter14),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
