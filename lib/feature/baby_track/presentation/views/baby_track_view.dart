import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_icons.dart';
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

  // Localized tabs will be calculated in build
  static const _tabsKeys = [
    TK.babyFeedingTitle,
    TK.babySleepTitle,
    TK.babyVaccineTitle
  ];

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
          final tabs = _tabsKeys.map((key) => context.trContext(key)).toList();

          return Scaffold(
            backgroundColor: context.theme.scaffoldBackgroundColor,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              backgroundColor: context.theme.appBarTheme.backgroundColor,
              title: Text(
                context.trContext(TK.babyTracking),
                style: context.text.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.ext.colors.primaryDark,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 22.sp,
                  color: context.ext.colors.primaryDark,
                ),
              ),

              actions: [
                GestureDetector(
                  onTap: () =>
                      context.push(AppRoutesPaths.babyTrackInsightsView),
                  child: CircleAvatar(
                    backgroundColor:
                        context.theme.buttonTheme.colorScheme!.primary,
                    radius: 22.r,
                    child: SvgPicture.asset(
                      AppIcons.iconsInsightReport,
                      width: 24.w,
                      colorFilter: ColorFilter.mode(
                        context.theme.buttonTheme.colorScheme!.onPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                16.w.width,
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
                    tabs: tabs,
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
