import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
import 'package:new_mama/feature/articles/presentation/view_model/saved_articles/saved_articles_cubit.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/profile/presentation/view_model/profile_cubit.dart';
import 'package:new_mama/feature/profile/presentation/view_model/profile_state.dart';
import 'package:new_mama/feature/profile/presentation/widgets/children_section.dart';
import 'package:new_mama/feature/profile/presentation/widgets/community_posts_section.dart';
import 'package:new_mama/feature/profile/presentation/widgets/logout_button.dart';
import 'package:new_mama/feature/profile/presentation/widgets/parenting_journey_section.dart';
import 'package:new_mama/feature/profile/presentation/widgets/profile_header.dart';
import 'package:new_mama/feature/profile/presentation/widgets/profile_section_title.dart';
import 'package:new_mama/feature/profile/presentation/widgets/saved_articles_section.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CommunityCubit>()..loadMyPosts()),
        BlocProvider(
          create: (_) => getIt<SavedArticlesCubit>()..loadSavedArticles(),
        ),
      ],
      child: const _ProfileBody(),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.scaffoldBackgroundColor,
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading && state.profile == null) {
            return Center(
              child: CustomLoadingIndicator(color: context.colors.primary),
            );
          } else if (state.status == ProfileStatus.error &&
              state.profile == null) {
            return Center(child: Text(state.errorMessage ?? 'Error'));
          }

          final profile = state.profile;
          if (profile == null) return const SizedBox.shrink();

          return RefreshIndicator(
            onRefresh: () => context.read<ProfileCubit>().loadProfile(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProfileHeader(),
                  24.height,

                  // Parenting Journey
                  // ProfileSectionTitle(
                  //   title: context.trContext(TK.profileParentingJourney),
                  //   onSeeAll: () {},
                  // ),
                  // ParentingJourneySection(
                  //   lastMoodStatus: profile.mentalHealthStatus,
                  //   depressionTestStatus: profile
                  //       .mentalHealthStatus, // Mapping mental health to depression status for now
                  //   babyTrackingStatus: profile.healthStatus,
                  // ),
                  // 24.height,

                  // ── My Children (live from API) ──────────────────
                  const ChildrenSection(),
                  24.height,

                  // Community Posts
                  ProfileSectionTitle(
                    title: context.trContext(TK.profileCommunityPosts),
                    onSeeAll: () {},
                  ),
                  const CommunityPostsSection(),
                  24.height,

                  // Saved Articles
                  ProfileSectionTitle(
                    title: context.trContext(TK.articlesSaved),
                    onSeeAll: () {
                      context.push(AppRoutesPaths.savedArticlesView);
                    },
                  ),
                  8.height,
                  const SavedArticlesSection(),
                  24.height,

                  // Logout Button
                  const LogoutButton(),
                  100.height,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
