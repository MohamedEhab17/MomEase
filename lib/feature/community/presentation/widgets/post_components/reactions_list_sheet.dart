import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
import 'package:new_mama/feature/community/data/models/reaction_model.dart';
import 'package:new_mama/feature/community/domain/usecase/community_usecases.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/reaction_picker.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'sheet/count_badge.dart';
import 'sheet/reactions_list.dart';

class ReactionsListSheet extends StatefulWidget {
  final int postId;
  final int reactionsCount;

  const ReactionsListSheet({
    super.key,
    required this.postId,
    required this.reactionsCount,
  });

  @override
  State<ReactionsListSheet> createState() => _ReactionsListSheetState();

  static void show(
    BuildContext context, {
    required int postId,
    required int reactionsCount,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReactionsListSheet(
        postId: postId,
        reactionsCount: reactionsCount,
      ),
    );
  }
}

class _ReactionsListSheetState extends State<ReactionsListSheet>
    with TickerProviderStateMixin {
  late TabController _tabCtrl;
  List<ReactionModel> _reactions = [];
  bool _isLoading = true;
  String? _error;

  List<String> get _presentTypes {
    final types = <String>[];
    for (final r in _reactions) {
      if (!types.contains(r.reactionType)) types.add(r.reactionType);
    }
    return types;
  }

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 1, vsync: this); // updated after load
    _loadReactions();
  }

  Future<void> _loadReactions() async {
    final useCase = getIt<GetPostReactionsUseCase>();
    final result = await useCase(postId: widget.postId);
    result.fold(
      (failure) => setState(() {
        _error = failure.message;
        _isLoading = false;
      }),
      (reactions) {
        final types = <String>[];
        for (final r in reactions) {
          if (!types.contains(r.reactionType)) types.add(r.reactionType);
        }
        _tabCtrl.dispose();
        _tabCtrl = TabController(length: types.length + 1, vsync: this);
        setState(() {
          _reactions = reactions;
          _isLoading = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  List<ReactionModel> _forTab(int index) {
    if (index == 0) return _reactions;
    final type = _presentTypes[index - 1];
    return _reactions.where((r) => r.reactionType == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: context.ext.colors.primaryExtraLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Column(
          children: [
            // ── Handle ─────────────────────────────────────────
            Column(
              children: [
                22.height,
                Container(
                  width: 124.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: context.ext.colors.primaryDark,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                22.height,
              ],
            ),

            // ── Header ─────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Row(
                children: [
                  Text(
                    context.isAr ? 'التفاعلات' : 'Reactions',
                    style: context.text.titleMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  6.width,
                  CountBadge(count: widget.reactionsCount, context: context),
                ],
              ),
            ),

            // ── Tabs: All | ❤️ Love | 👍 Like | etc. ──────────
            if (!_isLoading && _reactions.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.colors.onSurface.withAlpha(26),
                    ),
                  ),
                ),
                child: TabBar(
                  controller: _tabCtrl,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: context.ext.colors.primaryDark,
                  unselectedLabelColor:
                      context.colors.onSurface.withAlpha(128),
                  indicatorColor: context.ext.colors.primaryDark,
                  indicatorWeight: 2.5,
                  labelStyle: context.text.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                  ),
                  unselectedLabelStyle: context.text.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.sp,
                  ),
                  tabs: [
                    Tab(
                      child: Text(context.isAr ? 'الكل (${_reactions.length})' : 'All (${_reactions.length})'),
                    ),
                    ..._presentTypes.map((t) {
                      final config = ReactionConfig.byType(t);
                      final count =
                          _reactions.where((r) => r.reactionType == t).length;
                      return Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (config != null)
                              Icon(config.icon,
                                  size: 15.sp, color: config.color),
                            4.width,
                            Text('$count'),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

            // ── List ───────────────────────────────────────────
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: CustomLoadingIndicator(color: context.colors.primary),
      );
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium!.copyWith(
              color: context.colors.onSurface.withAlpha(128),
            ),
          ),
        ),
      );
    }
    if (_reactions.isEmpty) {
      return Center(
        child: Text(
          context.isAr ? 'لا توجد تفاعلات بعد' : 'No reactions yet',
          style: context.text.bodyMedium!.copyWith(
            color: context.colors.onSurface.withAlpha(102),
          ),
        ),
      );
    }

    return TabBarView(
      controller: _tabCtrl,
      children: List.generate(
        _presentTypes.length + 1,
        (i) => ReactionsList(reactions: _forTab(i)),
      ),
    );
  }
}
