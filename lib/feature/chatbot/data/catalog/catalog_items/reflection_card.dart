import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'shared/shared_widgets.dart';

final _schema = S.object(
  description: 'An interactive card displaying a self-care reflection prompt, encouraging postpartum emotional checking and journaling responses.',
  properties: {
    'prompt': S.object(
      description: 'The meditative self-care reflection prompt text. Must use {"literalString": "..."} format.',
    ),
    'action': S.object(
      description: 'The interactive event triggered when the mom initiates the reflection. Must use {"name": "...", "context": [...]} structure.',
    ),
  },
  required: ['prompt', 'action'],
);

extension type _ReflectionCardData.fromMap(Map<String, Object?> _json) {
  JsonMap get prompt => _json['prompt'] as JsonMap;
  JsonMap get action => _json['action'] as JsonMap;
}

final reflectionCard = CatalogItem(
  name: 'ReflectionCard',
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "ReflectionCard": {
              "prompt": {"literalString": "What are three things you feel grateful for today, even if they are very small?"},
              "action": {"name": "start_reflection_dialog", "context": []}
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (itemContext) {
    final cardData = _ReflectionCardData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    return _ReflectionCard(
      prompt: cardData.prompt,
      action: cardData.action,
      widgetId: itemContext.id,
      dispatchEvent: itemContext.dispatchEvent,
      dataContext: itemContext.dataContext,
    );
  },
);

class _ReflectionCard extends StatelessWidget {
  const _ReflectionCard({
    required this.prompt,
    required this.action,
    required this.widgetId,
    required this.dispatchEvent,
    required this.dataContext,
  });

  final JsonMap prompt;
  final JsonMap action;
  final String widgetId;
  final DispatchEventCallback dispatchEvent;
  final DataContext dataContext;

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;
    final promptNotifier = dataContext.subscribeToString(prompt);

    return GenUIEntranceAnimation(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: GenUICard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Meditative Header
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: colors.primary.withAlpha(26),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.self_improvement_rounded,
                      color: colors.primary,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'Self-Care Reflection',
                      style: AppStyles.styleRoboto16.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.primaryDark,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                child: const Divider(),
              ),

              // Meditative Prompt
              ValueListenableBuilder<String?>(
                valueListenable: promptNotifier,
                builder: (context, promptText, child) {
                  if (promptText == null || promptText.isEmpty) {
                    return const GenUIEmptyState(
                      message: 'No reflection prompt defined.',
                      icon: Icons.chat_bubble_outline_rounded,
                    );
                  }
                  return Text(
                    promptText,
                    style: AppStyles.styleRoboto16.copyWith(
                      height: 1.5,
                      color: colors.lightTextPrimary.withAlpha(220),
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),

              // Reflect Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => GenUIActionHelper.dispatch(
                    context: context,
                    action: action,
                    widgetId: widgetId,
                    dispatchEvent: dispatchEvent,
                    dataContext: dataContext,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 1.5,
                  ),
                  icon: Icon(
                    Icons.favorite_rounded,
                    size: 16.sp,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Reflect Now',
                    style: AppStyles.styleRoboto16.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
