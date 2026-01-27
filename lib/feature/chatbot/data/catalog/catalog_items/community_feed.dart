import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final _schema = S.object(
  properties: {
    'title': S.object(description: 'Feed title. Use {"literalString": "..."}'),
    'posts': S.list(
      description: 'List of community posts.',
      items: S.object(
        properties: {
          'author': S.object(
            description: 'Post author. Use {"literalString": "..."}',
          ),
          'content': S.object(
            description: 'Post content. Use {"literalString": "..."}',
          ),
          'timestamp': S.object(
            description: 'Post timestamp. Use {"literalString": "..."}',
          ),
        },
        required: ['author', 'content'],
      ),
    ),
  },
  required: ['title'],
);

extension type _CommunityFeedData.fromMap(Map<String, Object?> _json) {
  JsonMap get title => _json['title'] as JsonMap;
  List<Map<String, Object?>>? get posts =>
      (_json['posts'] as List?)?.cast<Map<String, Object?>>();
}

final communityFeed = CatalogItem(
  name: 'CommunityFeed',
  dataSchema: _schema,
  widgetBuilder: (itemContext) {
    final feedData = _CommunityFeedData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    return _CommunityFeed(
      title: feedData.title,
      posts: feedData.posts,
      dataContext: itemContext.dataContext,
    );
  },
);

class _CommunityFeed extends StatelessWidget {
  const _CommunityFeed({
    required this.title,
    this.posts,
    required this.dataContext,
  });

  final JsonMap title;
  final List<Map<String, Object?>>? posts;
  final DataContext dataContext;

  @override
  Widget build(BuildContext context) {
    final titleNotifier = dataContext.subscribeToString(title);

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primarySoft3,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<String?>(
            valueListenable: titleNotifier,
            builder: (_, titleText, __) => Text(
              titleText ?? 'Community Feed',
              style: AppStyles.styleRoboto24.copyWith(color: AppColors.primary),
            ),
          ),
          if (posts != null && posts!.isNotEmpty) ...[
            SizedBox(height: 16.h),
            ...posts!.map((post) {
              final authorRef = post['author'] as JsonMap;
              final contentRef = post['content'] as JsonMap;
              final timestampRef = post['timestamp'] as JsonMap?;

              final authorNotifier = dataContext.subscribeToString(authorRef);
              final contentNotifier = dataContext.subscribeToString(contentRef);
              final timestampNotifier = timestampRef != null
                  ? dataContext.subscribeToString(timestampRef)
                  : null;

              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder<String?>(
                      valueListenable: authorNotifier,
                      builder: (_, author, __) => Text(
                        author ?? '',
                        style: AppStyles.styleRoboto16.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (timestampNotifier != null) ...[
                      SizedBox(height: 4.h),
                      ValueListenableBuilder<String?>(
                        valueListenable: timestampNotifier,
                        builder: (_, timestamp, __) => Text(
                          timestamp ?? '',
                          style: AppStyles.styleRoboto12.copyWith(
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 8.h),
                    ValueListenableBuilder<String?>(
                      valueListenable: contentNotifier,
                      builder: (_, content, __) =>
                          Text(content ?? '', style: AppStyles.styleRoboto16),
                    ),
                  ],
                ),
              );
            }),
          ] else ...[
            SizedBox(height: 16.h),
            Text(
              'No posts yet. Be the first to share!',
              style: AppStyles.styleRoboto16.copyWith(
                color: AppColors.lightTextSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
