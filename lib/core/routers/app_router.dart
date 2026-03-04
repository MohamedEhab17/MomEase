import 'package:go_router/go_router.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/feature/app_section/presentation/view/app_section_view.dart';
import 'package:new_mama/feature/articles/presentation/view/article_category_view.dart';
import 'package:new_mama/feature/articles/presentation/view/article_details_view.dart';
import 'package:new_mama/feature/articles/presentation/view/articles_view.dart';
import 'package:new_mama/feature/auth/presentation/views/create_password.dart';
import 'package:new_mama/feature/auth/presentation/views/email_verification_view.dart';
import 'package:new_mama/feature/auth/presentation/views/forget_password.dart';
import 'package:new_mama/feature/auth/presentation/views/login_view.dart';
import 'package:new_mama/feature/auth/presentation/views/sign_up_view.dart';
import 'package:new_mama/feature/auth/widgets/email_verified_success_widget.dart';
import 'package:new_mama/feature/baby_cry/presentation/views/cry_analyzing_view.dart';
import 'package:new_mama/feature/baby_cry/presentation/views/crying_insight_view.dart';
import 'package:new_mama/feature/baby_cry/presentation/views/crying_recording_session_view.dart';
import 'package:new_mama/feature/depression/presentation/views/depression_result_view.dart';
import 'package:new_mama/feature/depression/presentation/views/depression_test_view.dart';
import 'package:new_mama/feature/depression/presentation/views/depression_view.dart';
import 'package:new_mama/feature/home/presentation/views/home_view.dart';
import 'package:new_mama/feature/onboarding/presentation/onboarding_view.dart';

class AppRouter {
  static late final GoRouter router;

  static Future<void> initRouter() async {
    router = GoRouter(
      initialLocation: AppRoutesPaths.cryingRecordingSessionView,
      routes: [
        GoRoute(
          path: AppRoutesPaths.onboarding,
          name: 'onboarding',
          builder: (context, state) => const OnboardingView(),
        ),
        GoRoute(
          path: AppRoutesPaths.appSectionView,
          name: 'appSectionView',
          builder: (context, state) => const AppSectionView(),
        ),
        GoRoute(
          path: AppRoutesPaths.login,
          name: 'login',
          builder: (context, state) => const LoginView(),
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
        GoRoute(
          path: AppRoutesPaths.articlesView,
          name: 'articlesView',
          builder: (context, state) => const ArticlesView(),
        ),
        GoRoute(
          path: AppRoutesPaths.articleCategoryView,
          name: 'articleCategoryView',
          builder: (context, state) => const ArticleCategoryView(),
        ),
        GoRoute(
          path: AppRoutesPaths.articleDetailsView,
          name: 'articleDetailsView',
          builder: (context, state) => const ArticleDetailsView(),
        ),
        GoRoute(
          path: AppRoutesPaths.depressionView,
          name: 'depressionView',
          builder: (context, state) => const DepressionView(),
        ),
        GoRoute(
          path: AppRoutesPaths.depressionTestView,
          name: 'depressionTestView',
          builder: (context, state) => const DepressionTestView(),
        ),
        GoRoute(
          path: AppRoutesPaths.depressionResultView,
          name: 'depressionResultView',
          builder: (context, state) =>  DepressionResultView(),
        ),
        GoRoute(
          path: AppRoutesPaths.cryingInsightView,
          name: 'cryingInsightView',
          builder: (context, state) =>   CryingInsightView(),
        ),
      
        GoRoute(
          path: AppRoutesPaths.cryingRecordingSessionView,
          name: 'cryingRecordingSessionView',
          builder: (context, state) =>   CryingRecordingSessionView(),
        ),
        GoRoute(
          path: AppRoutesPaths.cryAnalyzingView,
          name: 'cryAnalyzingView',
          builder: (context, state) =>   CryAnalyzingView(),
        ),
       
      ],
    );
  }
}
