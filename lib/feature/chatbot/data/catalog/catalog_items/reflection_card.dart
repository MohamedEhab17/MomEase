import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final _schema = S.object(
  properties: {
    'prompt': S.object(
      description: 'Reflection prompt. Use {"literalString": "..."}',
    ),
    'action': S.object(
      description:
          'Action when user responds. Use {"name": "...", "context": [...]}',
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
    final promptNotifier = dataContext.subscribeToString(prompt);

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primarySoft3,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primarySoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.self_improvement,
                color: AppColors.primary,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Self-Care Reflection',
                style: AppStyles.styleRoboto16.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ValueListenableBuilder<String?>(
            valueListenable: promptNotifier,
            builder: (_, promptText, __) =>
                Text(promptText ?? '', style: AppStyles.styleRoboto16),
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: () {
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
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text('Reflect', style: AppStyles.styleRoboto16),
          ),
        ],
      ),
    );
  }
}
