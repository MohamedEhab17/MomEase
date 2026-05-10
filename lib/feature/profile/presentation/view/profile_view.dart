import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
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
        BlocProvider(create: (_) => getIt<ProfileCubit>()..loadProfile()),
        BlocProvider(create: (_) => getIt<CommunityCubit>()..loadMyPosts()),
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
          if (state is ProfileLoading) {
            return Center(
              child: CustomLoadingIndicator(color: context.colors.primary),
            );
          } else if (state is ProfileError) {
            return Center(child: Text(context.trContext(state.message)));
          } else if (state is ProfileLoaded) {
            final profile = state.profile;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeader(
                    avatarUrl: profile.avatarUrl,
                    name: profile.name,
                    subtitle: profile.subtitle,
                  ),
                  24.height,

                  // Parenting Journey
                  ProfileSectionTitle(
                    title: context.trContext(TK.profileParentingJourney),
                  ),
                  ParentingJourneySection(journey: profile.journey),
                  24.height,

                  // ── My Children (live from API) ──────────────────
                  const ChildrenSection(),
                  24.height,

                  // Community Posts
                  ProfileSectionTitle(
                    title: context.trContext(TK.profileCommunityPosts),
                  ),
                  const CommunityPostsSection(),
                  24.height,

                  // Saved Articles
                  ProfileSectionTitle(
                    title: context.trContext(TK.articlesSaved),
                  ),
                  8.height,
                  SavedArticlesSection(articles: profile.savedArticles),
                  24.height,

                  // Logout Button
                  LogoutButton(),
                  100.height,
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
