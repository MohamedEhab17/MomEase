import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final _schema = S.object(
  properties: {
    'topics': S.list(
      description:
          'A list of topics or follow-up suggestions to display as chips.',
      items: A2uiSchemas.stringReference(description: 'A topic to explore.'),
    ),
    'action': A2uiSchemas.action(
      description:
          'The action when a topic is selected. The selected topic '
          'will be added to the context with the key "topic".',
    ),
  },
  required: ['topics', 'action'],
);

extension type _TrailheadData.fromMap(Map<String, Object?> _json) {
  factory _TrailheadData({
    required List<JsonMap> topics,
    required JsonMap action,
  }) => _TrailheadData.fromMap({'topics': topics, 'action': action});

  List<JsonMap> get topics => (_json['topics'] as List).cast<JsonMap>();
  JsonMap get action => _json['action'] as JsonMap;
}

/// Presents follow-up topics as chips. When tapped, sends a new prompt to the AI.
final trailhead = CatalogItem(
  name: 'Trailhead',
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "Trailhead": {
              "topics": [
                {"literalString": "Log today's feeding"},
                {"literalString": "Check my mood"},
                {"literalString": "Postpartum recovery tips"}
              ],
              "action": {"name": "select_topic"}
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (itemContext) {
    final trailheadData = _TrailheadData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    return _Trailhead(
      topics: trailheadData.topics,
      action: trailheadData.action,
      widgetId: itemContext.id,
      dispatchEvent: itemContext.dispatchEvent,
      dataContext: itemContext.dataContext,
    );
  },
);

class _Trailhead extends StatelessWidget {
  const _Trailhead({
    required this.topics,
    required this.action,
    required this.widgetId,
    required this.dispatchEvent,
    required this.dataContext,
  });

  final List<JsonMap> topics;
  final JsonMap action;
  final String widgetId;
  final DispatchEventCallback dispatchEvent;
  final DataContext dataContext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: topics.map((topicRef) {
          final ValueNotifier<String?> notifier = dataContext.subscribeToString(
            topicRef,
          );

          return ValueListenableBuilder<String?>(
            valueListenable: notifier,
            builder: (context, topic, child) {
              if (topic == null) return const SizedBox.shrink();
              return InputChip(
                label: Text(
                  topic,
                  style: AppStyles.styleRoboto16.copyWith(
                    color: AppColors.lightTextPrimary.withAlpha(179),
                  ),
                ),
                labelStyle: AppStyles.styleRoboto16.copyWith(
                  color: AppColors.primarySoft,
                ),
                backgroundColor: AppColors.primarySoft,
                selectedColor: AppColors.primarySoft2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: const BorderSide(color: AppColors.primarySoft3),
                ),
                onPressed: () {
                  try {
                    final name = action['name'] as String;
                    final List<Object?> contextDefinition =
                        (action['context'] as List<Object?>?) ?? <Object?>[];
                    final JsonMap resolvedContext = resolveContext(
                      dataContext,
                      contextDefinition,
                    );
                    resolvedContext['topic'] = topic;
                    dispatchEvent(
                      UserActionEvent(
                        name: name,
                        sourceComponentId: widgetId,
                        context: resolvedContext,
                      ),
                    );
                  } catch (e) {
                    debugPrint('Error dispatching topic event: $e');
                  }
                },
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
