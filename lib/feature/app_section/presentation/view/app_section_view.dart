import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/feature/app_section/data/model/app_tab.dart';
import 'package:new_mama/feature/app_section/presentation/widgets/app_header.dart';
import 'package:new_mama/feature/app_section/presentation/widgets/drawer_backdrop.dart';
import 'package:new_mama/feature/app_section/presentation/widgets/drawer_slide_wrapper.dart';
import 'package:new_mama/feature/app_section/presentation/widgets/floating_nav_bar.dart';
import 'package:new_mama/feature/app_section/presentation/widgets/scroll_visibility_wrapper.dart';
import 'package:new_mama/feature/app_section/presentation/widgets/custom_drawer_menu.dart';
import 'package:new_mama/feature/community/presentation/view/community_view.dart';
import 'package:new_mama/feature/home/presentation/views/home_view.dart';
import 'package:new_mama/feature/notifications/presentation/view/notification_view.dart';
import 'package:new_mama/feature/profile/presentation/view/profile_view.dart';
import 'package:new_mama/feature/articles/presentation/view_model/categories_cubit/category_cubit.dart';
import 'package:new_mama/feature/home/presentation/view_model/home_articles/home_articles_cubit.dart';
import 'package:new_mama/core/localization/cubit/language_cubit.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/feature/app_section/presentation/view_model/logout_cubit/logout_cubit.dart';
import 'package:new_mama/feature/app_section/presentation/view_model/profile_cubit/profile_cubit.dart';
import '../view_model/cubit/bottom_nav_cubit.dart';

class AppSectionView extends StatefulWidget {
  const AppSectionView({super.key});

  @override
  State<AppSectionView> createState() => _AppSectionViewState();
}

class _AppSectionViewState extends State<AppSectionView>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _drawerController;
  late final List<AppTab> tabs;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _drawerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    tabs = [
      AppTab(
        activeIcon: AppIcons.iconsActiveHome,
        inactiveIcon: AppIcons.iconsInActiveHome,
        view: const HomeView(),
      ),
      AppTab(
        activeIcon: AppIcons.iconsActiveCommunity,
        inactiveIcon: AppIcons.iconsInActiveCommunity,
        view: const CommunityView(),
      ),
      AppTab(
        activeIcon: AppIcons.iconsActiveNotification,
        inactiveIcon: AppIcons.iconsInActiveNotification,
        view: const NotificationView(),
      ),
      AppTab(
        activeIcon: AppIcons.iconsActiveProfile,
        inactiveIcon: AppIcons.iconsInActiveProfile,
        view: const ProfileView(),
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _drawerController.dispose();
    super.dispose();
  }

  void _toggleDrawer() {
    if (_drawerController.isDismissed) {
      _drawerController.forward();
    } else {
      _drawerController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BottomNavCubit()),
        BlocProvider(create: (_) => getIt<CategoryCubit>()..fetchArticlesCategory()),
        BlocProvider(create: (_) => getIt<HomeArticlesCubit>()..loadHomeArticles()),
        BlocProvider(create: (_) => getIt<LogoutCubit>()),
        BlocProvider(create: (_) => getIt<ProfileCubit>()..getProfile()),
      ],
      child: BlocListener<LanguageCubit, Locale>(
        listener: (context, locale) {
          // Refetch data when language changes
          context.read<CategoryCubit>().fetchArticlesCategory();
          context.read<HomeArticlesCubit>().loadHomeArticles();
        },
        child: BlocBuilder<BottomNavCubit, BottomNavState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.theme.scaffoldBackgroundColor,
            // No appBar here — it lives inside the Stack so the drawer covers it
            body: Stack(
              children: [
                // 1. Main content column (header + pages)
                Column(
                  children: [
                    if (state.index != 3)
                      AppHeader(onMenuPressed: _toggleDrawer),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: tabs.length,
                        onPageChanged: (i) {
                          context.read<BottomNavCubit>().setIndex(i);
                          context.read<BottomNavCubit>().show();
                        },
                        itemBuilder: (_, i) =>
                            ScrollVisibilityWrapper(child: tabs[i].view),
                      ),
                    ),
                  ],
                ),

                // 2. Floating Bottom Nav Bar (overlaps pages)
                FloatingNavBar(tabs: tabs, pageController: _pageController),

                // 3. Dim + Blur Backdrop — covers header + pages
                DrawerBackdrop(
                  animation: _drawerController,
                  onTap: _toggleDrawer,
                ),

                // 4. Sliding Drawer Panel — covers header + pages
                DrawerSlideWrapper(
                  animation: _drawerController,
                  child: CustomDrawerMenu(
                    onClose: _toggleDrawer,
                    animation: _drawerController,
                  ),
                ),
              ],
            ),
          );
        },
      ),)
    );
  }
}
