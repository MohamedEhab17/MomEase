import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final _schema = S.object(
  properties: {
    'title': S.object(
      description: 'Carousel title. Use {"literalString": "..."}',
    ),
    'topics': S.list(
      description: 'List of topics to display.',
      items: S.object(
        properties: {
          'name': S.object(
            description: 'Topic name. Use {"literalString": "..."}',
          ),
          'action': S.object(
            description:
                'Action when topic is selected. Use {"name": "...", "context": [...]}',
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
      (_json['topics'] as List).cast<Map<String, Object?>>();
}

final topicCarousel = CatalogItem(
  name: 'TopicCarousel',
  dataSchema: _schema,
  widgetBuilder: (itemContext) {
    final carouselData = _TopicCarouselData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    return _TopicCarousel(
      title: carouselData.title,
      topics: carouselData.topics,
      dispatchEvent: itemContext.dispatchEvent,
      dataContext: itemContext.dataContext,
    );
  },
);

class _TopicCarousel extends StatelessWidget {
  const _TopicCarousel({
    required this.title,
    required this.topics,
    required this.dispatchEvent,
    required this.dataContext,
  });

  final JsonMap title;
  final List<Map<String, Object?>> topics;
  final DispatchEventCallback dispatchEvent;
  final DataContext dataContext;

  @override
  Widget build(BuildContext context) {
    final titleNotifier = dataContext.subscribeToString(title);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ValueListenableBuilder<String?>(
            valueListenable: titleNotifier,
            builder: (_, titleText, _) => Text(
              titleText ?? 'Topics',
              style: AppStyles.styleRoboto24.copyWith(color: AppColors.primary),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 120.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: topics.length,
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final topic = topics[index];
              final nameRef = topic['name'] as JsonMap;
              final action = topic['action'] as JsonMap;
              final nameNotifier = dataContext.subscribeToString(nameRef);

              return ValueListenableBuilder<String?>(
                valueListenable: nameNotifier,
                builder: (_, name, _) {
                  if (name == null) return const SizedBox.shrink();
                  return InkWell(
                    onTap: () {
                      final actionName = action['name'] as String;
                      final List<Object?> contextDefinition =
                          (action['context'] as List<Object?>?) ?? <Object?>[];
                      final JsonMap resolvedContext = resolveContext(
                        dataContext,
                        contextDefinition,
                      );
                      resolvedContext['topic'] = name;
                      dispatchEvent(
                        UserActionEvent(
                          name: actionName,
                          sourceComponentId: '',
                          context: resolvedContext,
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: 140.w,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft3,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.primarySoft),
                      ),
                      child: Center(
                        child: Text(
                          name,
                          style: AppStyles.styleRoboto16.copyWith(
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.center,
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
    );
  }
}
