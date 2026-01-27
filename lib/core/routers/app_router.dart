import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/feature/auth/presentation/views/email_verification_view.dart';
import 'package:new_mama/feature/auth/presentation/views/login_view.dart';
import 'package:new_mama/feature/auth/presentation/views/sign_up_view.dart';
import 'package:new_mama/feature/auth/widgets/email_verified_success_widget.dart';
import 'package:new_mama/feature/chatbot/di/chatbot_di.dart';
import 'package:new_mama/feature/chatbot/presentation/views/chatbot_view.dart';
import 'package:new_mama/feature/onboarding/presentation/onboarding_view.dart';

class AppRouter {
  static late final GoRouter router;

  static Future<void> initRouter() async {
    router = GoRouter(
      initialLocation: AppRoutesPaths.chatbot,
      routes: [
        GoRoute(
          path: AppRoutesPaths.onboarding,
          name: 'onboarding',
          builder: (context, state) => const OnboardingView(),
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
          path: AppRoutesPaths.chatbot,
          name: 'chatbot',
          builder: (context, state) => BlocProvider(
            create: (context) => ChatbotDI.createCubit(),
            child: const ChatbotView(),
          ),
        ),
      ],
    );
  }
}
