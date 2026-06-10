import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/enums/verification_type.dart'
    show VerificationType;
import 'package:new_mama/feature/articles/domain/entities/article.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/feature/articles/domain/entities/article_category.dart';
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
import 'package:new_mama/feature/depression/presentation/view_model/assessments_cubit/assessments_cubit.dart';
import 'package:new_mama/feature/depression/domain/entities/assessments.dart';
import 'package:new_mama/feature/depression/presentation/view_model/questions_cubit/questions_cubit.dart';
import 'package:new_mama/feature/depression/presentation/view_model/submit_cubit/submit_cubit.dart';
import 'package:new_mama/feature/depression/presentation/view_model/assessment_result_cubit/assessment_result_cubit.dart';
import 'package:new_mama/feature/children/data/models/child_model.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/feature/app_section/presentation/view/app_section_view.dart';
import 'package:new_mama/feature/app_section/presentation/view/manage_profile_view.dart';
import 'package:new_mama/feature/app_section/presentation/view/change_password_view.dart';
import 'package:new_mama/feature/app_section/presentation/view_model/profile_cubit/profile_cubit.dart';
import 'package:new_mama/feature/articles/presentation/view/article_category_view.dart';
import 'package:new_mama/feature/articles/presentation/view/article_details_view.dart';
import 'package:new_mama/feature/articles/presentation/view/articles_view.dart';
import 'package:new_mama/feature/articles/presentation/view/saved_articles_view.dart';
import 'package:new_mama/feature/articles/presentation/view_model/categories_cubit/category_cubit.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';
import 'package:new_mama/feature/children/presentation/cubit/children_cubit.dart';
import 'package:new_mama/feature/children/presentation/views/add_edit_child_view.dart';
import 'package:new_mama/feature/children/presentation/views/child_detail_view.dart';
import 'package:new_mama/feature/children/presentation/views/children_list_view.dart';
import 'package:new_mama/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:new_mama/feature/auth/presentation/views/create_password.dart';
import 'package:new_mama/feature/auth/presentation/views/email_verification_view.dart';
import 'package:new_mama/feature/auth/presentation/views/forget_password.dart';
import 'package:new_mama/feature/auth/presentation/views/login_view.dart';
import 'package:new_mama/feature/auth/presentation/views/reset_password_view.dart';
import 'package:new_mama/feature/auth/presentation/views/sign_up_view.dart';
import 'package:new_mama/feature/auth/presentation/widgets/email_verified_success_widget.dart';
import 'package:new_mama/feature/baby_cry/domain/entities/cry_analysis.dart';
import 'package:new_mama/feature/baby_cry/presentation/view_model/cubit/baby_cry_cubit.dart';
import 'package:new_mama/feature/baby_cry/presentation/views/cry_analyzing_view.dart';
import 'package:new_mama/feature/baby_cry/presentation/views/crying_history_view.dart';
import 'package:new_mama/feature/baby_cry/presentation/views/crying_insight_view.dart';
import 'package:new_mama/feature/baby_cry/presentation/views/crying_recording_session_view.dart';
import 'package:new_mama/feature/baby_cry/presentation/views/crying_result_view.dart';
import 'package:new_mama/feature/depression/presentation/views/depression_result_view.dart';
import 'package:new_mama/feature/depression/presentation/views/depression_test_options_view.dart';
import 'package:new_mama/feature/depression/presentation/views/depression_test_view.dart';
import 'package:new_mama/feature/depression/presentation/views/depression_view.dart';
import 'package:new_mama/feature/depression/presentation/views/depression_history_view.dart';
import 'package:new_mama/feature/depression/presentation/view_model/depression_history_cubit/depression_history_cubit.dart';
import 'package:new_mama/feature/community/presentation/view/community_view.dart';
import 'package:new_mama/feature/community/presentation/view/create_post_view.dart';
import 'package:new_mama/feature/community/presentation/view/saved_posts_view.dart';
import 'package:new_mama/feature/community/presentation/view/post_details_view.dart';
import 'package:new_mama/feature/community/presentation/view/my_posts_view.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/view_model/post_details_cubit/post_details_cubit.dart';
import 'package:new_mama/feature/home/presentation/views/home_view.dart';
import 'package:new_mama/feature/notifications/presentation/view/notification_view.dart';
import 'package:new_mama/feature/onboarding/presentation/view/onboarding_view.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view/skin_diagnosis_analyzing_view.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view/skin_diagnosis_history_view.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view/skin_diagnosis_insight_view.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view/skin_diagnosis_photo_view.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view/skin_diagnosis_result_view.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view_model/skin_diagnosis_cubit.dart';
import 'package:new_mama/feature/skin_diagnosis/domain/entities/skin_analysis.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/baby_track_cubit.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/feeding_insights_cubit.dart';
import 'package:new_mama/feature/baby_track/presentation/views/baby_track_view.dart';
import 'package:new_mama/feature/baby_track/presentation/views/insights_view.dart';

import 'package:new_mama/feature/articles/presentation/view/article_search_view.dart';
import 'package:new_mama/feature/articles/presentation/view_model/article_detail/article_detail_cubit.dart';
import 'package:new_mama/feature/articles/presentation/view_model/category_articles/category_articles_cubit.dart';
import 'package:new_mama/feature/articles/presentation/view_model/saved_articles/saved_articles_cubit.dart';
import 'package:new_mama/feature/articles/presentation/view_model/search_articles/search_articles_cubit.dart';
import 'package:new_mama/feature/auth/data/datasources/auth_local_data_source_contract.dart';


class AppRouter {
  static late final GoRouter router;

  static Future<void> initRouter() async {
    String initialLocation = AppRoutesPaths.login;
    try {
      final authLocalDataSource = getIt<AuthLocalDataSource>();
      final isOnboardingCompleted = authLocalDataSource.isOnboardingCompleted();
      final tokens = await authLocalDataSource.getTokens();
      final isUserLoggedIn = tokens != null;
      final isBabySetupCompleted = authLocalDataSource.isBabySetupCompleted();

      if (!isOnboardingCompleted) {
        initialLocation = AppRoutesPaths.onboarding;
      } else if (isUserLoggedIn && !isBabySetupCompleted) {
        initialLocation = AppRoutesPaths.babyProfileOnboardingView;
      } else if (isUserLoggedIn) {
        initialLocation = AppRoutesPaths.appSectionView;
      } else {
        initialLocation = AppRoutesPaths.login;
      }
    } catch (e, stackTrace) {
      debugPrint(
        'AppRouter.initRouter failed: $e\n$stackTrace',
      );
      initialLocation = AppRoutesPaths.login;
    }

    router = GoRouter(
      initialLocation:
       initialLocation
      //AppRoutesPaths.depressionTestOptionsView
      ,
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
          builder: (context, state) => BlocProvider.value(
            value: getIt<AuthCubit>(),
            child: const LoginView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.communityView,
          name: 'communityView',
          builder: (context, state) => const CommunityView(),
        ),
        GoRoute(
          path: AppRoutesPaths.createPostCommunityView,
          name: 'createPostCommunityView',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<CommunityCubit>(),
            child: const CreatePostView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.savedPostsView,
          name: 'savedPostsView',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<CommunityCubit>()..loadSavedPosts(),
            child: const SavedPostsView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.myPostsView,
          name: 'myPostsView',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<CommunityCubit>()..loadMyPosts(),
            child: const MyPostsView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.postDetailsView,
          name: 'postDetailsView',
          builder: (context, state) {
            final postIdStr = state.pathParameters['postId'];
            final postId = int.tryParse(postIdStr ?? '');
            if (postId == null) {
              return const Scaffold(body: Center(child: Text('Invalid post ID')));
            }
            final action = state.uri.queryParameters['action'];
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => getIt<CommunityCubit>()),
                BlocProvider(create: (_) => getIt<PostDetailsCubit>()..fetchPostDetails(postId)),
              ],
              child: PostDetailsView(postId: postId, action: action),
            );
          },
        ),
        GoRoute(
          path: AppRoutesPaths.signup,
          name: 'signup',
          builder: (context, state) => BlocProvider.value(
            value: getIt<AuthCubit>(),
            child: const SignUpView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.emailVerification,
          name: 'emailVerification',
          builder: (context, state) {
            final args = state.extra;
            if (args is Map<String, dynamic>) {
              final type = args['type'] as VerificationType;
              final email = args['email'] as String;
              return BlocProvider.value(
                value: getIt<AuthCubit>(),
                child: EmailVerificationView(type: type, email: email),
              );
            }
            return const Scaffold(
              body: Center(child: Text('Invalid Verification Data')),
            );
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
          builder: (context, state) => BlocProvider.value(
            value: getIt<AuthCubit>(),
            child: const CreatePassword(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.forgotPassword,
          name: 'forgotPassword',
          builder: (context, state) => const ForgetPassword(),
        ),
        GoRoute(
          path: AppRoutesPaths.resetPassword,
          name: 'resetPassword',
          builder: (context, state) {
            final args = state.extra;
            if (args is Map<String, dynamic>) {
              return BlocProvider.value(
                value: getIt<AuthCubit>(),
                child: ResetPasswordView(
                  email: args['email'] as String,
                  resetToken: args['resetToken'] as String? ?? '',
                ),
              );
            }
            return const Scaffold(
              body: Center(child: Text('Invalid Reset Data')),
            );
          },
        ),
        GoRoute(
          path: AppRoutesPaths.homeView,
          name: 'homeView',
          builder: (context, state) => const HomeView(),
        ),
        GoRoute(
          path: AppRoutesPaths.articlesView,
          name: 'articlesView',
          builder: (context, state) {
            final extra = state.extra;
            if (extra is ArticleCategory) {
              return BlocProvider(
                create: (_) => getIt<CategoryArticlesCubit>(),
                child: ArticlesView(categoryId: extra.id),
              );
            }
            // Fallback: If extra is missing or wrong type, go back or show empty
            return const Scaffold(
              body: Center(child: Text('Invalid Category Data')),
            );
          },
        ),
        GoRoute(
          path: AppRoutesPaths.articleCategoryView,
          name: 'articleCategoryView',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<CategoryCubit>()..fetchArticlesCategory(),
            child: const ArticleCategoryView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.articleDetailsView,
          name: 'articleDetailsView',
          builder: (context, state) {
            final extra = state.extra;
            if (extra is Article) {
              return BlocProvider(
                create: (_) => getIt<ArticleDetailCubit>(),
                child: ArticleDetailsView(article: extra),
              );
            }
            return const Scaffold(
              body: Center(child: Text('Invalid Article Data')),
            );
          },
        ),
        GoRoute(
          path: AppRoutesPaths.savedArticlesView,
          name: 'savedArticlesView',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<SavedArticlesCubit>(),
            child: const SavedArticlesView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.articleSearchView,
          name: 'articleSearchView',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<SearchArticlesCubit>(),
            child: const ArticleSearchView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.depressionView,
          name: 'depressionView',
          builder: (context, state) => const DepressionView(),
        ),
        GoRoute(
          path: AppRoutesPaths.depressionTestOptionsView,
          name: 'depressionTestOptionsView',
          builder: (context, state) => BlocProvider(
            create: (context) =>getIt<AssessmentsCubit> ()..fetchAssessments(),
            child: const DepressionTestOptionsView()),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => getIt<SubmitCubit>()),
                BlocProvider(create: (context) => getIt<QuestionsCubit>()),
              ],
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: AppRoutesPaths.depressionTestView,
              name: 'depressionTestView',
              builder: (context, state) {
                final extra = state.extra;
                if (extra is Assessments) {
                  return DepressionTestView(assessment: extra);
                }
                return const Scaffold(
                  body: Center(child: Text('Invalid Assessment Data')),
                );
              },
            ),
            GoRoute(
              path: AppRoutesPaths.depressionResultView,
              name: 'depressionResultView',
              builder: (context, state) {
                final extra = state.extra;
                if (extra is Map<String, dynamic>) {
                  final assessment = extra['assessment'] as Assessments;
                  final resultId = extra['resultId'] as int;

                  return BlocProvider(
                    create: (context) =>
                        getIt<AssessmentResultCubit>()..getResult(resultId),
                    child: DepressionResultView(assessment: assessment),
                  );
                }
                return const Scaffold(
                  body: Center(child: Text('Invalid Result Data')),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: AppRoutesPaths.depressionHistoryView,
          name: 'depressionHistoryView',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<DepressionHistoryCubit>(),
            child: const DepressionHistoryView(),
          ),
        ),

        ShellRoute(
          builder: (context, state, child) => BlocProvider(
            create: (_) => getIt<BabyCryCubit>(),
            child: child,
          ),
          routes: [
            GoRoute(
              path: AppRoutesPaths.cryingInsightView,
              name: 'cryingInsightView',
              builder: (context, state) => const CryingInsightView(),
            ),
            GoRoute(
              path: AppRoutesPaths.cryingRecordingSessionView,
              name: 'cryingRecordingSessionView',
              builder: (context, state) => const CryingRecordingSessionView(),
            ),
            GoRoute(
              path: AppRoutesPaths.cryingResultView,
              name: 'cryingResultView',
              builder: (context, state) {
                final extra = state.extra;
                if (extra is CryAnalysis) {
                  return CryingResultView(analysis: extra);
                }
                return const Scaffold(
                  body: Center(child: Text('Invalid Analysis Data')),
                );
              },
            ),
            GoRoute(
              path: AppRoutesPaths.cryAnalyzingView,
              name: 'cryAnalyzingView',
              builder: (context, state) => const CryAnalyzingView(),
            ),
            GoRoute(
              path: AppRoutesPaths.cryingHistoryView,
              name: 'cryingHistoryView',
              builder: (context, state) => const CryingHistoryView(),
            ),
          ],
        ),
        // Shell gives insight → photo → analyzing → result → history a shared cubit
        ShellRoute(
          builder: (context, state, child) => BlocProvider(
            create: (_) => getIt<SkinDiagnosisCubit>(),
            child: child,
          ),
          routes: [
            GoRoute(
              path: AppRoutesPaths.skinDiagnosisInsightView,
              name: 'skinDiagnosisInsightView',
              builder: (context, state) => const SkinDiagnosisInsightView(),
            ),
            GoRoute(
              path: AppRoutesPaths.skinDiagnosisPhotoView,
              name: 'skinDiagnosisPhoto',
              builder: (context, state) => const SkinDiagnosisPhotoView(),
            ),
            GoRoute(
              path: AppRoutesPaths.skinDiagnosisAnalyzingView,
              name: 'skinDiagnosisAnalyzingView',
              builder: (context, state) =>
                  const SkinDiagnosisAnalyzingView(),
            ),
            GoRoute(
              path: AppRoutesPaths.skinDiagnosisResultView,
              name: 'skinDiagnosisResultView',
              builder: (context, state) {
                final analysis = state.extra as SkinAnalysis;
                return SkinDiagnosisResultView(analysis: analysis);
              },
            ),
            GoRoute(
              path: AppRoutesPaths.skinDiagnosisHistoryView,
              name: 'skinDiagnosisHistoryView',
              builder: (context, state) =>
                  const SkinDiagnosisHistoryView(),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutesPaths.babyTrackView,
          name: 'babyTrackView',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<BabyTrackCubit>(),
            child: const BabyTrackView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.babyTrackInsightsView,
          name: 'babyTrackInsightsView',
          builder: (context, state) => BlocProvider(
            create: (context) => getIt<FeedingInsightsCubit>(),
            child: const InsightsView(),
          ),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => OnboardingCubit(totalSteps: 9),
                ),
                BlocProvider.value(
                  value: getIt<ChildrenCubit>(),
                ),
              ],
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
            ),
            GoRoute(
              path: AppRoutesPaths.firstTimeMama,
              name: 'firstTimeMama',
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
            ),
            GoRoute(
              path: AppRoutesPaths.dateOfBirth,
              name: 'dateOfBirth',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: DateOfBirth());
              },
            ),
            GoRoute(
              path: AppRoutesPaths.feedingType,
              name: 'feedingType',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: FeedingType());
              },
            ),
            GoRoute(
              path: AppRoutesPaths.birthExperience,
              name: 'birthExperience',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: BirthExperience());
              },
            ),
            GoRoute(
              path: AppRoutesPaths.allSetUp,
              name: 'allSetUp',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: AllSetUp());
              },
            ),
          ],
        ),
        
        //  Children Feature Routes 
        GoRoute(
          path: AppRoutesPaths.childrenListView,
          name: 'childrenListView',
          builder: (context, state) => BlocProvider.value(
            value: getIt<ChildrenCubit>()..loadChildren(),
            child: const ChildrenListView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.childDetailView,
          name: 'childDetailView',
          builder: (context, state) {
            final extra = state.extra;
            final Child child;
            if (extra is Child) {
              child = extra;
            } else if (extra is Map<String, dynamic>) {
              child = ChildModel.fromJson(extra);
            } else {
              // Fallback or error handling
              return const Scaffold(body: Center(child: Text('Invalid Child Data')));
            }
            return BlocProvider.value(
              value: getIt<ChildrenCubit>(),
              child: ChildDetailView(child: child),
            );
          },
        ),
         GoRoute(
          path: AppRoutesPaths.addChildView,
          name: 'addChildView',
          builder: (context, state) {
            final extra = state.extra;
            final child = extra is Child
                ? extra
                : (extra is Map<String, dynamic> ? ChildModel.fromJson(extra) : null);
            return BlocProvider.value(
              value: getIt<ChildrenCubit>(),
              child: AddEditChildView(child: child),
            );
          },
        ),
        GoRoute(
          path: AppRoutesPaths.manageProfileView,
          name: 'manageProfileView',
          builder: (context, state) => BlocProvider.value(
            value: getIt<ProfileCubit>(),
            child: const ManageProfileView(),
          ),
        ),
        GoRoute(
          path: AppRoutesPaths.changePasswordView,
          name: 'changePasswordView',
          builder: (context, state) => const ChangePasswordView(),
        ),
         GoRoute(
          path: AppRoutesPaths.notificationView,
          name: 'notificationView',
          builder: (context, state) => const NotificationView(),
        ),
        GoRoute(
          path: '/assessments/results/:resultId',
          name: 'notificationAssessmentResult',
          builder: (context, state) {
            final resultIdStr = state.pathParameters['resultId'];
            final resultId = int.tryParse(resultIdStr ?? '') ?? 0;
            return BlocProvider(
              create: (context) =>
                  getIt<AssessmentResultCubit>()..getResult(resultId),
              child: const DepressionResultView(assessment: null),
            );
          },
        ),
        GoRoute(
          path: '/assessments/follow-up/:followUpId',
          name: 'notificationAssessmentFollowUp',
          builder: (context, state) => BlocProvider(
            create: (context) => getIt<AssessmentsCubit>()..fetchAssessments(),
            child: const DepressionTestOptionsView(),
          ),
        ),
        GoRoute(
          path: '/mental-health/tips/:tipId',
          name: 'notificationMentalHealthTip',
          builder: (context, state) => const DepressionView(),
        ),
        GoRoute(
          path: '/tracking',
          name: 'notificationTrackingBase',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<BabyTrackCubit>(),
            child: const BabyTrackView(),
          ),
        ),
        GoRoute(
          path: '/tracking/child/:childId',
          name: 'notificationTrackingChild',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<BabyTrackCubit>(),
            child: const BabyTrackView(),
          ),
        ),
        GoRoute(
          path: '/my-posts',
          name: 'notificationMyPostsDashed',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<CommunityCubit>()..loadMyPosts(),
            child: const MyPostsView(),
          ),
        ),
        GoRoute(
          path: '/myposts',
          name: 'notificationMyPostsRaw',
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<CommunityCubit>()..loadMyPosts(),
            child: const MyPostsView(),
          ),
        ),
      ],
    );
  }
}
