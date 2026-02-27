import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/di/injection.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/feature/app_section/presentation/view/app_section_view.dart';
import 'package:new_mama/feature/auth/presentation/views/create_password.dart';
import 'package:new_mama/feature/auth/presentation/views/email_verification_view.dart';
import 'package:new_mama/feature/auth/presentation/views/forget_password.dart';
import 'package:new_mama/feature/auth/presentation/views/login_view.dart';
import 'package:new_mama/feature/auth/presentation/views/sign_up_view.dart';
import 'package:new_mama/feature/auth/widgets/email_verified_success_widget.dart';
import 'package:new_mama/feature/community/presentation/view/community_view.dart';
import 'package:new_mama/feature/community/presentation/view/create_post_view.dart';
import 'package:new_mama/feature/community/presentation/view/saved_posts_view.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/home/presentation/views/home_view.dart';
import 'package:new_mama/feature/onboarding/presentation/onboarding_view.dart';

class AppRouter {
  static late final GoRouter router;

  static Future<void> initRouter() async {
    router = GoRouter(
      initialLocation: AppRoutesPaths.appSectionView,
      routes: [
        GoRoute(
          path: AppRoutesPaths.onboarding,
          name: 'onboarding',
          builder: (context, state) => const OnboardingView(),
        ),
        GoRoute(
          path: AppRoutesPaths.appSectionView,
          name: 'appSectionView',
          builder: (context, state) => AppSectionView(),
        ),
        GoRoute(
          path: AppRoutesPaths.login,
          name: 'login',
          builder: (context, state) => const LoginView(),
        ),
        GoRoute(
          path: AppRoutesPaths.communityView,
          name: 'communityView',
          builder: (context, state) => const CommunityView(),
        ),
        GoRoute(
          path: AppRoutesPaths.createPostCommunityView,
          name: 'createPostCommunityView',
          builder: (context, state) => BlocProvider.value(
            value: sl<CommunityCubit>(),
            child: const CreatePostView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.savedPostsView,
          name: 'savedPostsView',
          builder: (context, state) => BlocProvider.value(
            value: sl<CommunityCubit>(),
            child: const SavedPostsView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.signup,
          name: 'signup',
          builder: (context, state) => const SignUpView(),
        ),
        GoRoute(
          path: AppRoutesPaths.emailVerification,
          name: 'emailVerification',
          builder: (context, state) => const EmailVerificationView(),
        ),
        GoRoute(
          path: AppRoutesPaths.emailVerifiedSuccess,
          name: 'emailVerifiedSuccess',
          builder: (context, state) => const EmailVerifiedSuccessWidget(),
        ),
        GoRoute(
          path: AppRoutesPaths.createPassword,
          name: 'createPassword',
          builder: (context, state) => const CreatePassword(),
        ),
        GoRoute(
          path: AppRoutesPaths.forgotPassword,
          name: 'forgotPassword',
          builder: (context, state) => const ForgetPassword(),
        ),
        GoRoute(
          path: AppRoutesPaths.homeView,
          name: 'homeView',
          builder: (context, state) => const HomeView(),
        ),
      ],
    );
  }
}
