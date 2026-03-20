import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/baby_track_cubit.dart';
import 'package:new_mama/feature/baby_track/presentation/views/feeding_tab_view.dart';
import 'package:new_mama/feature/baby_track/presentation/views/sleep_tab_view.dart';
import 'package:new_mama/feature/baby_track/presentation/views/vaccine_tab_view.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/baby_track_tab_bar.dart';

class BabyTrackView extends StatefulWidget {
  const BabyTrackView({super.key});

  @override
  State<BabyTrackView> createState() => _BabyTrackViewState();
}

class _BabyTrackViewState extends State<BabyTrackView>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;

  static const _tabs = ['Feeding', 'Sleep', 'Vaccine'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index, BabyTrackCubit cubit) {
    cubit.switchMainTab(index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BabyTrackCubit(),
      child: BlocBuilder<BabyTrackCubit, BabyTrackState>(
        builder: (context, state) {
          final cubit = context.read<BabyTrackCubit>();
          final currentTab = state is MainTabChanged
              ? state.tabIndex
              : cubit.mainTabIndex;

          return Scaffold(
            backgroundColor: AppColors.lightBackground,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              backgroundColor: AppColors.lightBackground,
              title: Text(
                'Baby Tracking',
                style: AppStyles.styleInter20.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 22.sp,
                  color: AppColors.primaryDark,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () =>
                      context.push(AppRoutesPaths.babyTrackInsightsView),
                  child: CircleAvatar(
                    backgroundColor: AppColors.primaryDark,
                    radius: 22.r,
                    child: SvgPicture.asset(
                      AppIcons.iconsInsightReport,
                      width: 24.w,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
              ],
            ),
            body: Column(
              children: [
                // Tab bar
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  child: BabyTrackTabBar(
                    tabs: _tabs,
                    selectedIndex: currentTab,
                    onTabSelected: (i) => _onTabSelected(i, cubit),
                  ),
                ),

                // Tab content with PageView for smooth transitions
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (i) => cubit.switchMainTab(i),
                    physics: const BouncingScrollPhysics(),
                    children: const [
                      FeedingTabView(),
                      SleepTabView(),
                      VaccineTabView(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
