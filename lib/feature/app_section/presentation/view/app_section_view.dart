import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/feature/app_section/data/model/app_tab.dart';
import 'package:new_mama/feature/app_section/presentation/widgets/app_header.dart';
import 'package:new_mama/feature/app_section/presentation/widgets/floating_nav_bar.dart';
import 'package:new_mama/feature/app_section/presentation/widgets/scroll_visibility_wrapper.dart';
import 'package:new_mama/feature/community/presentation/view/community_view.dart';
import 'package:new_mama/feature/home/presentation/views/home_view.dart';
import '../view_model/cubit/bottom_nav_cubit.dart';

class AppSectionView extends StatefulWidget {
  const AppSectionView({super.key});

  @override
  State<AppSectionView> createState() => _AppSectionViewState();
}

class _AppSectionViewState extends State<AppSectionView> {
  late final PageController _pageController;
  late final List<AppTab> tabs;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    tabs = [
      AppTab(
        activeIcon: AppIcons.iconsActiveHome,
        inactiveIcon: AppIcons.iconsInActiveHome,
        view: const HomeView(),
      ), // wrap inside pages where needed
      AppTab(
        activeIcon: AppIcons.iconsActiveCommunity,
        inactiveIcon: AppIcons.iconsInActiveCommunity,
        view: const CommunityView(),
      ),
      AppTab(
        activeIcon: AppIcons.iconsActiveNotification,
        inactiveIcon: AppIcons.iconsInActiveNotification,
        view: const Scaffold(),
      ),
      AppTab(
        activeIcon: AppIcons.iconsActiveProfile,
        inactiveIcon: AppIcons.iconsInActiveProfile,
        view: const Scaffold(),
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildWrappedView(int i) {
    return ScrollVisibilityWrapper(child: tabs[i].view);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavCubit(),
      child: BlocBuilder<BottomNavCubit, BottomNavState>(
        builder: (context, state) {
          return Scaffold(
            appBar: const AppHeader(),
            drawer: const Drawer(),
            backgroundColor: AppColors.lightBackground,
            body: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: tabs.length,
                  onPageChanged: (i) {
                    context.read<BottomNavCubit>().setIndex(i);
                    context.read<BottomNavCubit>().show();
                  },
                  itemBuilder: (_, i) => _buildWrappedView(i),
                ),

                // floating nav bar on top
                FloatingNavBar(tabs: tabs, pageController: _pageController),
              ],
            ),
          );
        },
      ),
    );
  }
}
