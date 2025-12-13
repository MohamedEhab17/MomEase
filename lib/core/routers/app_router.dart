import 'package:go_router/go_router.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/feature/onboarding/presentation/onboarding_view.dart';

class AppRouter {
  static late final GoRouter router;

  static Future<void> initRouter() async {
    router = GoRouter(
      initialLocation: AppRoutesPaths.onboarding,
      routes: [
        // GoRoute(
        //   path: AppRoutesPaths.appSectionView,
        //   name: '/',
        //   builder: (context, state) =>  AppSectionView(),
        // ),
        // GoRoute(
        //   path: AppRoutesPaths.login,
        //   name: 'login',
        //   builder: (context, state) => const LoginView(),
        // ),
        GoRoute(
          path: AppRoutesPaths.onboarding,
          name: 'onboarding',
          builder: (context, state) => const OnboardingView(),
        ),
        // GoRoute(
        //   path: AppRoutesPaths.signup,
        //   name: 'signup',
        //   builder: (context, state) => const SignupView(),
        // ),
      ],
    );
  }
}
