import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/feature/chatbot/presentation/widgets/chat_message_list.dart';
import 'shared/shared_widgets.dart';

final _schema = S.object(
  description: 'Presents a list of follow-up topics as premium interactive chips. Selecting a chip automatically dispatches a prompt action with the selected topic.',
  properties: {
    'topics': S.list(
      description: 'A list of follow-up suggestion strings to display as chips.',
      items: A2uiSchemas.stringReference(description: 'A suggested prompt to explore.'),
    ),
    'action': A2uiSchemas.action(
      description: 'The tap action description. Tapped chip sends action and automatically appends "topic" to context.',
    ),
  },
  required: ['topics', 'action'],
);

extension type _TrailheadData.fromMap(Map<String, Object?> _json) {
  factory _TrailheadData({
    required List<JsonMap> topics,
    required JsonMap action,
  }) => _TrailheadData.fromMap({'topics': topics, 'action': action});

  List<JsonMap> get topics =>
      ((_json['topics'] as List?) ?? const <Object?>[]).cast<JsonMap>();
  JsonMap get action => _json['action'] as JsonMap;
}

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
                {"literalString": "Track Baby's Feeding"},
                {"literalString": "Postpartum Fatigue Tips"},
                {"literalString": "Ask a Lactation Expert"}
              ],
              "action": {"name": "select_topic", "context": []}
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
    final msgContext = ChatbotMessageContext.of(context);
    final bool isOld = msgContext?.isOld ?? false;

    if (topics.isEmpty || isOld) {
      return const SizedBox.shrink();
    }

    final colors = context.ext.colors;

    return GenUIEntranceAnimation(
      child: Padding(
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
                if (topic == null || topic.isEmpty) return const SizedBox.shrink();
                return InputChip(
                  label: Text(
                    topic,
                    style: AppStyles.styleRoboto16.copyWith(
                      color: colors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  labelStyle: AppStyles.styleRoboto16.copyWith(
                    color: colors.primaryDark,
                  ),
                  backgroundColor: colors.primaryExtraLight.withAlpha(128),
                  selectedColor: colors.primaryExtraLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    side: BorderSide(
                      color: colors.primary.withAlpha(64),
                      width: 1.2.w,
                    ),
                  ),
                  shadowColor: colors.primary.withAlpha(20),
                  elevation: 1.5,
                  pressElevation: 3.0,
                  onPressed: () => GenUIActionHelper.dispatch(
                    context: context,
                    action: action,
                    widgetId: widgetId,
                    dispatchEvent: dispatchEvent,
                    dataContext: dataContext,
                    additionalContext: {'topic': topic},
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
