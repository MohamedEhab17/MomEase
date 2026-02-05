import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final _schema = S.object(
  properties: {
    'title': S.object(
      description: 'Action card title. Use {"literalString": "..."}',
    ),
    'description': S.object(
      description: 'Action description. Use {"literalString": "..."}',
    ),
    'icon': S.string(description: 'Icon name.'),
    'action': S.object(
      description:
          'Acperform when tapped. Use {"name": "...", "context": [...]}',
    ),
  },
  required: ['title', 'action'],
);

extension type _ActionCardData.fromMap(Map<String, Object?> _json) {
  JsonMap get title => _json['title'] as JsonMap;
  JsonMap? get description => _json['description'] as JsonMap?;
  String? get icon => _json['icon'] as String?;
  JsonMap get action => _json['action'] as JsonMap;
}

final actionCard = CatalogItem(
  name: 'ActionCard',
  dataSchema: _schema,
  widgetBuilder: (itemContext) {
    final cardData = _ActionCardData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    return _ActionCard(
      title: cardData.title,
      description: cardData.description,
      icon: cardData.icon,
      action: cardData.action,
      widgetId: itemContext.id,
      dispatchEvent: itemContext.dispatchEvent,
      dataContext: itemContext.dataContext,
    );
  },
);

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    this.description,
    this.icon,
    required this.action,
    required this.widgetId,
    required this.dispatchEvent,
    required this.dataContext,
  });

  final JsonMap title;
  final JsonMap? description;
  final String? icon;
  final JsonMap action;
  final String widgetId;
  final DispatchEventCallback dispatchEvent;
  final DataContext dataContext;

  IconData _getIcon(String? iconName) {
    switch (iconName) {
      case 'mic':
        return Icons.mic;
      case 'camera':
        return Icons.camera_alt;
      case 'upload':
        return Icons.upload;
      default:
        return Icons.touch_app;
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleNotifier = dataContext.subscribeToString(title);
    final descNotifier = description != null
        ? dataContext.subscribeToString(description!)
        : null;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      child: Card(
        color: AppColors.primarySoft,
        child: InkWell(
          onTap: () {
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
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(_getIcon(icon), size: 32.sp, color: AppColors.primary),
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValueListenableBuilder<String?>(
                        valueListenable: titleNotifier,
                        builder: (_, titleText, _) => Text(
                          titleText ?? '',
                          style: AppStyles.styleRoboto16.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      if (descNotifier != null) ...[
                        SizedBox(height: 4.h),
                        ValueListenableBuilder<String?>(
                          valueListenable: descNotifier,
                          builder: (_, desc, _) =>
                              Text(desc ?? '', style: AppStyles.styleRoboto16),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward, color: AppColors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
