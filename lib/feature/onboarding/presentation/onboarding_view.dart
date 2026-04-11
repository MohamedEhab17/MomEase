import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/feature/onboarding/data/onboarding_data.dart';
import 'package:new_mama/feature/onboarding/data/onboarding_model.dart';
import 'package:new_mama/feature/onboarding/widgets/custom_animated_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 38.w, vertical: 80.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 250,
                child: PageView.builder(
                  controller: pageViewController,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemCount: onboardingList.length,
                  itemBuilder: (context, index) => CustomAnimatedWidget(
                    delay: index,
                    child: Image.asset(
                      onboardingList[index].imgPath,
                      height: 336.h,
                      width: 345.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              //! indicator
              SizedBox(height: 23),
              SmoothPageIndicator(
                controller: pageViewController,
                count: onboardingList.length,
                effect: ExpandingDotsEffect(
                  spacing: 7,
                  radius: 64,
                  dotWidth: 15,
                  dotHeight: 8,
                  dotColor: context.ext.colors.greyLight,
                  activeDotColor: context.ext.colors.primaryTint,
                ),
              ),
              SizedBox(height: 24),
              //! Title
              CustomAnimatedWidget(
                delay: (currentPage + 1) * 100,
                child: Column(
                  spacing: 5,
                  children: [
                    Text(
                      onboardingList[currentPage].title,
                      textAlign: TextAlign.center,
                      style: context.text.headlineLarge!,
                    ),
                    Text(
                      onboardingList[currentPage].description,
                      textAlign: TextAlign.center,
                      style: context.text.titleMedium!,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: currentPage == onboardingList.length - 1
            ? CustomElevatedButton(
                text: "Start",
                onPressed: () {
                  context.go(AppRoutesPaths.login);
                },
                minimumSize: Size(double.infinity, 52.h),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomElevatedButton(
                    text: 'Skip',
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    onPressed: () {
                      pageViewController.animateToPage(
                        onboardingList.length - 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                  ),
                  CustomElevatedButton(
                    text: "Next",
                    onPressed: () {
                      if (currentPage < onboardingList.length - 1) {
                        pageViewController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                  ),
                ],
              ),
      ),
    );
  }

  late final PageController pageViewController;

  int currentPage = 0;
  late List<OnBoardingModel> onboardingList;
  @override
  void initState() {
    super.initState();
    pageViewController = PageController();
    onboardingList = dataOnboarding();
  }

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }
}
