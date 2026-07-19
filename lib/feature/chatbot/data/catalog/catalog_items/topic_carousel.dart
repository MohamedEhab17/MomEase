import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'shared/shared_widgets.dart';

final _schema = S.object(
  description: 'A horizontal carousel of topics for postpartum exploration, allowing mothers to tap and easily inquire about specific postpartum guidance areas.',
  properties: {
    'title': S.object(
      description: 'The title displayed above the carousel. Must use {"literalString": "..."} format.',
    ),
    'topics': S.list(
      description: 'The collection of topic buttons to display.',
      items: S.object(
        properties: {
          'name': S.object(
            description: 'The name or label of the topic. Must use {"literalString": "..."} format.',
          ),
          'action': S.object(
            description: 'Action when the topic is selected. Must use {"name": "...", "context": [...]} structure.',
          ),
        },
        required: ['name', 'action'],
      ),
    ),
  },
  required: ['title', 'topics'],
);

extension type _TopicCarouselData.fromMap(Map<String, Object?> _json) {
  JsonMap get title => _json['title'] as JsonMap;
  List<Map<String, Object?>> get topics =>
      ((_json['topics'] as List?) ?? const <Object?>[]).cast<Map<String, Object?>>();
}

final topicCarousel = CatalogItem(
  name: 'TopicCarousel',
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "TopicCarousel": {
              "title": {"literalString": "Topics to Explore"},
              "topics": [
                {
                  "name": {"literalString": "Postpartum Healing"},
                  "action": {"name": "explore_topic", "context": []}
                },
                {
                  "name": {"literalString": "Breastfeeding Guide"},
                  "action": {"name": "explore_topic", "context": []}
                },
                {
                  "name": {"literalString": "Sleep Training"},
                  "action": {"name": "explore_topic", "context": []}
                }
              ]
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (itemContext) {
    final carouselData = _TopicCarouselData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    return _TopicCarousel(
      title: carouselData.title,
      topics: carouselData.topics,
      widgetId: itemContext.id,
      dispatchEvent: itemContext.dispatchEvent,
      dataContext: itemContext.dataContext,
    );
  },
);

class _TopicCarousel extends StatelessWidget {
  const _TopicCarousel({
    required this.title,
    required this.topics,
    required this.widgetId,
    required this.dispatchEvent,
    required this.dataContext,
  });

  final JsonMap title;
  final List<Map<String, Object?>> topics;
  final String widgetId;
  final DispatchEventCallback dispatchEvent;
  final DataContext dataContext;

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;
    final titleNotifier = dataContext.subscribeToString(title);

    if (topics.isEmpty) {
      return GenUIEntranceAnimation(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ValueListenableBuilder<String?>(
                valueListenable: titleNotifier,
                builder: (context, titleText, child) => Text(
                  titleText ?? 'Topics',
                  style: AppStyles.styleRoboto20.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.primaryDark,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            const GenUIEmptyState(
              message: 'No postpartum topics currently suggested.',
              icon: Icons.list_alt_rounded,
            ),
          ],
        ),
      );
    }

    return GenUIEntranceAnimation(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: Row(
              children: [
                Icon(
                  Icons.explore_rounded,
                  color: colors.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ValueListenableBuilder<String?>(
                    valueListenable: titleNotifier,
                    builder: (context, titleText, child) => Text(
                      titleText ?? 'Topics to Explore',
                      style: AppStyles.styleRoboto20.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.primaryDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 110.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              itemCount: topics.length,
              separatorBuilder: (context, index) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final topic = topics[index];
                final nameRef = topic['name'] as JsonMap?;
                final action = topic['action'] as JsonMap?;

                if (nameRef == null || action == null) {
                  return const SizedBox.shrink();
                }

                final nameNotifier = dataContext.subscribeToString(nameRef);

                return ValueListenableBuilder<String?>(
                  valueListenable: nameNotifier,
                  builder: (context, name, child) {
                    if (name == null || name.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return SizedBox(
                      width: 150.w,
                      child: GenUICard(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        borderRadius: BorderRadius.circular(16.r),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14.r),
                            onTap: () => GenUIActionHelper.dispatch(
                              context: context,
                              action: action,
                              widgetId: '$widgetId[$index]',
                              dispatchEvent: dispatchEvent,
                              dataContext: dataContext,
                              additionalContext: {'topic': name},
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.spa_rounded,
                                    size: 24.sp,
                                    color: colors.primary,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    name,
                                    style: AppStyles.styleRoboto16.copyWith(
                                      color: colors.primaryDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
