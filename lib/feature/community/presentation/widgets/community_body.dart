import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_state.dart';
import 'package:new_mama/feature/community/presentation/widgets/community_header.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_item.dart';

class CommunityBody extends StatefulWidget {
  const CommunityBody({super.key});

  @override
  State<CommunityBody> createState() => _CommunityBodyState();
}

class _CommunityBodyState extends State<CommunityBody> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<CommunityCubit>().refresh(),
      child: BlocBuilder<CommunityCubit, CommunityState>(
        builder: (context, state) {
          return Column(
            children: [
              CommunityHeader(controller: _animateToController),
              Expanded(
                child: CustomScrollView(
                  clipBehavior: Clip.hardEdge,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => PostItem(
                          post: state.posts[i],
                          controller: _animateToController,
                        ),
                        childCount: state.posts.length,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  late AnimateToController _animateToController;

  @override
  void initState() {
    super.initState();
    _animateToController = AnimateToController();
  }
}
