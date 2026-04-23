import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hintText;
  final String? label;
  final bool isVisible;
  final String Function(String)? itemLabelBuilder;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText = "Select",
    this.label,
    this.isVisible = false,
    this.itemLabelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: isVisible,
          child: Text(label ?? "", style: context.text.titleSmall!),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(64.r),
            border: Border.all(color: context.ext.colors.primaryDark),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              focusColor: Colors.transparent,
              dropdownColor: context.theme.cardColor,
              borderRadius: BorderRadius.circular(8.r),
              value: value,
              elevation: 3,
              hint: Text(hintText, style: context.text.bodyLarge!),
              isExpanded: true,
              icon: SvgPicture.asset(
                AppIcons.iconsArrowDropDown,
                height: 7.h,
                width: 11.w,
                colorFilter: ColorFilter.mode(
                  context.ext.colors.primaryDark,
                  BlendMode.srcIn,
                ),
              ),
              menuMaxHeight: MediaQuery.sizeOf(context).height * 0.3,
              items: items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        itemLabelBuilder?.call(item) ?? item,
                        style: context.text.titleSmall!,
                      ),
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
