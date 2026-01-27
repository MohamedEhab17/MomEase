import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final _schema = S.object(
  properties: {
    'title': S.object(
      description: 'Support action title. Use {"literalString": "..."}',
    ),
    'description': S.object(
      description: 'Support description. Use {"literalString": "..."}',
    ),
    'action': S.object(
      description: 'Action when tapped. Use {"name": "...", "context": [...]}',
    ),
  },
  required: ['title', 'action'],
);

extension type _AskForSupportActionData.fromMap(Map<String, Object?> _json) {
  JsonMap get title => _json['title'] as JsonMap;
  JsonMap? get description => _json['description'] as JsonMap?;
  JsonMap get action => _json['action'] as JsonMap;
}

final askForSupportAction = CatalogItem(
  name: 'AskForSupportAction',
  dataSchema: _schema,
  widgetBuilder: (itemContext) {
    final actionData = _AskForSupportActionData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    return _AskForSupportAction(
      title: actionData.title,
      description: actionData.description,
      action: actionData.action,
      widgetId: itemContext.id,
      dispatchEvent: itemContext.dispatchEvent,
      dataContext: itemContext.dataContext,
    );
  },
);

class _AskForSupportAction extends StatelessWidget {
  const _AskForSupportAction({
    required this.title,
    this.description,
    required this.action,
    required this.widgetId,
    required this.dispatchEvent,
    required this.dataContext,
  });

  final JsonMap title;
  final JsonMap? description;
  final JsonMap action;
  final String widgetId;
  final DispatchEventCallback dispatchEvent;
  final DataContext dataContext;

  @override
  Widget build(BuildContext context) {
    final titleNotifier = dataContext.subscribeToString(title);
    final descNotifier = description != null
        ? dataContext.subscribeToString(description!)
        : null;

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primarySoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
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
            debugPrint('Error dispatching support action event: $e');
          }
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Row(
            children: [
              Icon(Icons.support_agent, color: Colors.white, size: 32.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder<String?>(
                      valueListenable: titleNotifier,
                      builder: (_, titleText, __) => Text(
                        titleText ?? 'Ask for Support',
                        style: AppStyles.styleRoboto16.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (descNotifier != null) ...[
                      SizedBox(height: 4.h),
                      ValueListenableBuilder<String?>(
                        valueListenable: descNotifier,
                        builder: (_, desc, __) => Text(
                          desc ?? '',
                          style: AppStyles.styleRoboto12.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
