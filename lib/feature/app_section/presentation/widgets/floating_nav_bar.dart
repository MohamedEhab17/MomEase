import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/app_section/data/model/app_tab.dart';
import '../view_model/cubit/bottom_nav_cubit.dart';

class FloatingNavBar extends StatelessWidget {
  final List<AppTab> tabs;
  final PageController pageController;

  const FloatingNavBar({
    super.key,
    required this.tabs,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, BottomNavState>(
      builder: (context, state) {
        return AnimatedPositionedDirectional(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          start: 0,
          end: 0,
          bottom: state.visible ? 0 : -MediaQuery.sizeOf(context).height * 0.2,
          child: SafeArea(
            bottom: false,
            child: Container(
              margin: const EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 20),
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
              decoration: BoxDecoration(
                color: context.ext.colors.primaryBackground,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(tabs.length, (i) {
                  final bool isActive = i == state.index;
                  return GestureDetector(
                    onTap: () {
                      context.read<BottomNavCubit>().setIndex(i);
                      pageController.animateToPage(
                        i,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: SvgPicture.asset(
                        isActive ? tabs[i].activeIcon : tabs[i].inactiveIcon,
                        fit: BoxFit.contain,
                        height: 24.h,
                        width: 24.w,
                        colorFilter: ColorFilter.mode(
                          context.ext.colors.primaryDark,

                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}
