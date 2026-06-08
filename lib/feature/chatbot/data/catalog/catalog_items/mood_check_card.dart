import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/chatbot/presentation/widgets/chat_message_list.dart';

final _schema = S.object(
  properties: {
    'title': A2uiSchemas.stringReference(
      description: 'Title for the mood check card.',
    ),
    'moods': S.list(
      description:
          'List of mood options (e.g. calm, tired, anxious, overwhelmed).',
      items: A2uiSchemas.stringReference(description: 'A mood option.'),
    ),
    'action': A2uiSchemas.action(
      description:
          'The action when a mood is selected. The selected mood '
          'will be added to the context with the key "mood".',
    ),
  },
  required: ['title', 'moods', 'action'],
);

extension type _MoodCheckCardData.fromMap(Map<String, Object?> _json) {
  factory _MoodCheckCardData({
    required JsonMap title,
    required List<JsonMap> moods,
    required JsonMap action,
  }) => _MoodCheckCardData.fromMap({
    'title': title,
    'moods': moods,
    'action': action,
  });

  JsonMap get title => _json['title'] as JsonMap;
  List<JsonMap> get moods => (_json['moods'] as List).cast<JsonMap>();
  JsonMap get action => _json['action'] as JsonMap;
}

final moodCheckCard = CatalogItem(
  name: 'MoodCheckCard',
  dataSchema: _schema,
  widgetBuilder: (itemContext) {
    final cardData = _MoodCheckCardData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    return _MoodCheckCard(
      title: cardData.title,
      moods: cardData.moods,
      action: cardData.action,
      widgetId: itemContext.id,
      dispatchEvent: itemContext.dispatchEvent,
      dataContext: itemContext.dataContext,
    );
  },
);

class _MoodCheckCard extends StatelessWidget {
  const _MoodCheckCard({
    required this.title,
    required this.moods,
    required this.action,
    required this.widgetId,
    required this.dispatchEvent,
    required this.dataContext,
  });

  final JsonMap title;
  final List<JsonMap> moods;
  final JsonMap action;
  final String widgetId;
  final DispatchEventCallback dispatchEvent;
  final DataContext dataContext;

  @override
  Widget build(BuildContext context) {
    final titleNotifier = dataContext.subscribeToString(title);
    final msgContext = ChatbotMessageContext.of(context);
    final bool isOld = msgContext?.isOld ?? false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: context.ext.colors.primaryTint,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: context.ext.colors.primary.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: context.ext.colors.primary.withAlpha(26), width: 1.2.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<String?>(
            valueListenable: titleNotifier,
            builder: (context, titleText, _) => Text(
              titleText ?? 'How are you feeling today?',
              style: AppStyles.styleRoboto24.copyWith(
                color: context.ext.colors.primaryDark,
              ),
            ),
          ),
          if (!isOld) ...[
            SizedBox(height: 16.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: moods.map((moodRef) {
                final moodNotifier = dataContext.subscribeToString(moodRef);
                return ValueListenableBuilder<String?>(
                  valueListenable: moodNotifier,
                  builder: (context, mood, _) {
                    if (mood == null) return const SizedBox.shrink();
                    return ChoiceChip(
                      label: Text(mood),
                      selected: false,
                      onSelected: (selected) {
                        try {
                          final name = action['name'] as String;
                          final List<Object?> contextDefinition =
                              (action['context'] as List<Object?>?) ??
                              <Object?>[];
                          final JsonMap resolvedContext = resolveContext(
                            dataContext,
                            contextDefinition,
                          );
                          resolvedContext['mood'] = mood;
                          dispatchEvent(
                            UserActionEvent(
                              name: name,
                              sourceComponentId: widgetId,
                              context: resolvedContext,
                            ),
                          );
                        } catch (e) {
                          debugPrint('Error dispatching mood event: $e');
                        }
                      },
                      backgroundColor: Colors.white,
                      selectedColor: context.ext.colors.primary,
                      labelStyle: AppStyles.styleRoboto16.copyWith(
                        color: context.ext.colors.lightTextPrimary.withAlpha(178),
                        fontWeight: FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(64.r),
                        side: const BorderSide(color: Colors.transparent),
                      ),
                      shadowColor: context.ext.colors.primary.withAlpha(26),
                      elevation: 10,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
