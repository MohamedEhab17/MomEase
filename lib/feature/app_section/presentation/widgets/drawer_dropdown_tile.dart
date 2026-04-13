import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'drawer_list_tile.dart';

class DrawerDropdownTile<T> extends StatefulWidget {
  final String title;
  final Widget leading;
  final String trailingText;
  final List<PopupMenuEntry<T>> items;
  final ValueChanged<T> onSelected;

  const DrawerDropdownTile({
    super.key,
    required this.title,
    required this.leading,
    required this.trailingText,
    required this.items,
    required this.onSelected,
  });

  @override
  State<DrawerDropdownTile<T>> createState() => _DrawerDropdownTileState<T>();
}

class _DrawerDropdownTileState<T> extends State<DrawerDropdownTile<T>> {
  final GlobalKey<PopupMenuButtonState<T>> _popupKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DrawerListTile(
      title: widget.title,
      leading: widget.leading,
      flipX: false,
      onTap: () {
        _popupKey.currentState?.showButtonMenu();
      },
      trailing: PopupMenuButton<T>(
        key: _popupKey,
        color: context.theme.cardColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        position: PopupMenuPosition.over,
        onSelected: widget.onSelected,
        itemBuilder: (context) => widget.items,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.trailingText,
              style: context.theme.textTheme.titleSmall!.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8.w),
            SvgPicture.asset(
              AppIcons.iconsArrowDropDown,
              height: 7.h,
              width: 11.w,
              colorFilter: ColorFilter.mode(
                context.ext.colors.primaryDark,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
