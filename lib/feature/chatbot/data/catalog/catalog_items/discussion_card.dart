import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final _schema = S.object(
  properties: {
    'title': S.object(
      description: 'Discussion title. Use {"literalString": "..."}',
    ),
    'content': S.object(
      description: 'Discussion content. Use {"literalString": "..."}',
    ),
    'replies': S.number(description: 'Number of replies.'),
    'action': S.object(
      description: 'Action when tapped. Use {"name": "...", "context": [...]}',
    ),
  },
  required: ['title', 'content', 'action'],
);

extension type _DiscussionCardData.fromMap(Map<String, Object?> _json) {
  JsonMap get title => _json['title'] as JsonMap;
  JsonMap get content => _json['content'] as JsonMap;
  num? get replies => _json['replies'] as num?;
  JsonMap get action => _json['action'] as JsonMap;
}

final discussionCard = CatalogItem(
  name: 'DiscussionCard',
  dataSchema: _schema,
  widgetBuilder: (itemContext) {
    final cardData = _DiscussionCardData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    return _DiscussionCard(
      title: cardData.title,
      content: cardData.content,
      replies: cardData.replies,
      action: cardData.action,
      widgetId: itemContext.id,
      dispatchEvent: itemContext.dispatchEvent,
      dataContext: itemContext.dataContext,
    );
  },
);

class _DiscussionCard extends StatelessWidget {
  const _DiscussionCard({
    required this.title,
    required this.content,
    this.replies,
    required this.action,
    required this.widgetId,
    required this.dispatchEvent,
    required this.dataContext,
  });

  final JsonMap title;
  final JsonMap content;
  final num? replies;
  final JsonMap action;
  final String widgetId;
  final DispatchEventCallback dispatchEvent;
  final DataContext dataContext;

  @override
  Widget build(BuildContext context) {
    final titleNotifier = dataContext.subscribeToString(title);
    final contentNotifier = dataContext.subscribeToString(content);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primarySoft3,
            AppColors.primarySoft3.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            try {
              final name = action['name'] as String;
              final List<Object?> contextDefinition =
                  (action['context'] as List<Object?>?) ?? <Object?>[];
              final JsonMap resolvedContext = resolveContext(
                dataContext,
                contextDefinition,
              );
              dispatchEvent(
                UserActionEvent(
                  name: name,
                  sourceComponentId: widgetId,
                  context: resolvedContext,
                ),
              );
            } catch (e) {
              debugPrint('Error dispatching discussion event: $e');
            }
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<String?>(
                  valueListenable: titleNotifier,
                  builder: (_, titleText, __) => Text(
                    titleText ?? '',
                    style: AppStyles.styleRoboto16.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                ValueListenableBuilder<String?>(
                  valueListenable: contentNotifier,
                  builder: (_, contentText, __) => Text(
                    contentText ?? '',
                    style: AppStyles.styleRoboto16,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (replies != null) ...[
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.comment,
                        size: 16.sp,
                        color: AppColors.lightTextSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${replies!.toInt()} replies',
                        style: AppStyles.styleRoboto12.copyWith(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
