import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/enums/verification_type.dart'
    show VerificationType;
import 'package:new_mama/feature/articles/data/models/article_model.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_cubit.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/views/baby_profile_onboarding_layout.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/views/baby_profile_onboarding_view.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/all_set_up.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/baby_count.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/baby_gender.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/baby_name.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/birth_experience.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/date_of_birth.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/feeding_type.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/first_time_mama.dart';
import 'package:new_mama/feature/depression/presentation/view_model/depression_cubit.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/feature/app_section/presentation/view/app_section_view.dart';
import 'package:new_mama/feature/articles/presentation/view/article_category_view.dart';
import 'package:new_mama/feature/articles/presentation/view/article_details_view.dart';
import 'package:new_mama/feature/articles/presentation/view/articles_view.dart';
import 'package:new_mama/feature/articles/presentation/view/saved_articles_view.dart';
import 'package:new_mama/feature/articles/presentation/view_model/article_cubit.dart';
import 'package:new_mama/feature/auth/presentation/views/create_password.dart';
import 'package:new_mama/feature/auth/presentation/views/email_verification_view.dart';
import 'package:new_mama/feature/auth/presentation/views/forget_password.dart';
import 'package:new_mama/feature/auth/presentation/views/login_view.dart';
import 'package:new_mama/feature/auth/presentation/views/sign_up_view.dart';
import 'package:new_mama/feature/auth/widgets/email_verified_success_widget.dart';
import 'package:new_mama/feature/baby_cry/presentation/views/cry_analyzing_view.dart';
import 'package:new_mama/feature/baby_cry/presentation/views/crying_insight_view.dart';
import 'package:new_mama/feature/baby_cry/presentation/views/crying_recording_session_view.dart';
import 'package:new_mama/feature/baby_cry/presentation/views/crying_result_view.dart';
import 'package:new_mama/feature/depression/presentation/views/depression_result_view.dart';
import 'package:new_mama/feature/depression/presentation/views/depression_test_view.dart';
import 'package:new_mama/feature/depression/presentation/views/depression_view.dart';
import 'package:new_mama/feature/community/presentation/view/community_view.dart';
import 'package:new_mama/feature/community/presentation/view/create_post_view.dart';
import 'package:new_mama/feature/community/presentation/view/saved_posts_view.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/home/presentation/views/home_view.dart';
import 'package:new_mama/feature/onboarding/presentation/onboarding_view.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view/skin_diagnosis_analyzing_view.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view/skin_diagnosis_insight_view.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view/skin_diagnosis_photo_view.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view/skin_diagnosis_result_view.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view_model/skin_diagnosis_cubit.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/baby_track_cubit.dart';
import 'package:new_mama/feature/baby_track/presentation/views/baby_track_view.dart';
import 'package:new_mama/feature/baby_track/presentation/views/insights_view.dart';

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
            value: getIt<CommunityCubit>(),
            child: const CreatePostView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.savedPostsView,
          name: 'savedPostsView',
          builder: (context, state) => BlocProvider.value(
            value: getIt<CommunityCubit>(),
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
          builder: (context, state) {
            final type = state.extra as VerificationType;
            return EmailVerificationView(type: type);
          },
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
          builder: (context, state) => BlocProvider.value(
            value: getIt<ArticleCubit>(),
            child: const ArticlesView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.articleCategoryView,
          name: 'articleCategoryView',
          builder: (context, state) => BlocProvider.value(
            value: getIt<ArticleCubit>(),
            child: const ArticleCategoryView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.articleDetailsView,
          name: 'articleDetailsView',
          builder: (context, state) {
            final article = state.extra as ArticleModel;
            return BlocProvider.value(
              value: getIt<ArticleCubit>(),
              child: ArticleDetailsView(article: article),
            );
          },
        ),
        GoRoute(
          path: AppRoutesPaths.savedArticlesView,
          name: 'savedArticlesView',
          builder: (context, state) => BlocProvider.value(
            value: getIt<ArticleCubit>(),
            child: const SavedArticlesView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.depressionView,
          name: 'depressionView',
          builder: (context, state) => const DepressionView(),
        ),
        GoRoute(
          path: AppRoutesPaths.depressionTestView,
          name: 'depressionTestView',
          builder: (context, state) => BlocProvider(
            create: (context) => DepressionCubit()..startTest(),
            child: const DepressionTestView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.depressionResultView,
          name: 'depressionResultView',
          builder: (context, state) {
            final score = state.extra as int? ?? 0;
            return DepressionResultView(totalScore: score);
          },
        ),
        GoRoute(
          path: AppRoutesPaths.cryingInsightView,
          name: 'cryingInsightView',
          builder: (context, state) => CryingInsightView(),
        ),

        GoRoute(
          path: AppRoutesPaths.cryingRecordingSessionView,
          name: 'cryingRecordingSessionView',
          builder: (context, state) => CryingRecordingSessionView(),
        ),
        GoRoute(
          path: AppRoutesPaths.cryingResultView,
          name: 'cryingResultView',
          builder: (context, state) {
            final advices = state.extra as List<String>;

            return CryingResultView(advices: advices);
          },
        ),
        GoRoute(
          path: AppRoutesPaths.cryAnalyzingView,
          name: 'cryAnalyzingView',
          builder: (context, state) => CryAnalyzingView(),
        ),
        GoRoute(
          path: AppRoutesPaths.skinDiagnosisInsightView,
          name: 'skinDiagnosisInsightView',
          builder: (context, state) => const SkinDiagnosisInsightView(),
        ),
        GoRoute(
          path: AppRoutesPaths.skinDiagnosisAnalyzingView,
          name: 'skinDiagnosisAnalyzingView',
          builder: (context, state) => const SkinDiagnosisAnalyzingView(),
        ),
        GoRoute(
          path: AppRoutesPaths.skinDiagnosisPhotoView,
          name: 'skinDiagnosisPhoto',
          builder: (context, state) => BlocProvider(
            create: (context) => SkinDiagnosisCubit(),
            child: const SkinDiagnosisPhotoView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.skinDiagnosisResultView,
          name: 'skinDiagnosisResultView',
          builder: (context, state) {
            final advices = state.extra as List<String>;

            return SkinDiagnosisResultView(advices: advices);
          },
        ),
        GoRoute(
          path: AppRoutesPaths.babyTrackView,
          name: 'babyTrackView',
          builder: (context, state) => BlocProvider(
            create: (_) => BabyTrackCubit(),
            child: const BabyTrackView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.babyTrackInsightsView,
          name: 'babyTrackInsightsView',
          builder: (context, state) => const InsightsView(),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return BlocProvider(
              create: (context) => OnboardingCubit(totalSteps: 9),
              child: BabyProfileOnboardingLayout(child: child),
            );
          },
          routes: [
            GoRoute(
              path: AppRoutesPaths.babyProfileOnboardingView,
              name: 'babyProfileOnboardingView',
              pageBuilder: (context, state) {
                return const NoTransitionPage(
                  child: BabyProfileOnboardingView(),
                );
              },
              // builder: (context, state) => const BabyProfileOnboardingView(),
            ),
            GoRoute(
              path: AppRoutesPaths.firstTimeMama,
              name: 'firstTimeMama',
              // builder: (context, state) => const FirstTimeMama(),
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: FirstTimeMama());
              },
            ),
            GoRoute(
              path: AppRoutesPaths.babyCount,
              name: 'babyCount',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: BabyCount());
              },
              // builder: (context, state) => const BabyCount(),
            ),
            GoRoute(
              path: AppRoutesPaths.babyName,
              name: 'babyName',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: BabyName());
              },
            ),
            GoRoute(
              path: AppRoutesPaths.babyGender,
              name: 'babyGender',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: BabyGender());
              },
              // builder: (context, state) => const BabyGender(),
            ),
            GoRoute(
              path: AppRoutesPaths.dateOfBirth,
              name: 'dateOfBirth',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: DateOfBirth());
              },
              // builder: (context, state) => const DateOfBirth(),
            ),
            GoRoute(
              path: AppRoutesPaths.feedingType,
              name: 'feedingType',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: FeedingType());
              },
              // builder: (context, state) => const FeedingType(),
            ),
            GoRoute(
              path: AppRoutesPaths.birthExperience,
              name: 'birthExperience',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: BirthExperience());
              },
              // builder: (context, state) => const BirthExperience(),
            ),
            GoRoute(
              path: AppRoutesPaths.allSetUp,
              name: 'allSetUp',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: AllSetUp());
              },
              // builder: (context, state) => const AllSetUp(),
            ),
          ],
        ),
      ],
    );
  }
}
