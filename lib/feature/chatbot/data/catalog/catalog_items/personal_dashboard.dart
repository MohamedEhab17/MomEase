import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final _schema = S.object(
  properties: {
    'title': S.object(
      description: 'Title for the dashboard. Use {"literalString": "..."}',
    ),
    'sections': S.list(
      description: 'List of dashboard sections.',
      items: S.object(
        properties: {
          'label': S.object(
            description: 'Section label. Use {"literalString": "..."}',
          ),
          'value': S.object(
            description: 'Section value. Use {"literalString": "..."}',
          ),
          'icon': S.string(description: 'Icon name.'),
        },
        required: ['label', 'value'],
      ),
    ),
    'suggestedActions': S.list(
      description: 'List of suggested actions.',
      items: S.object(description: 'Action text. Use {"literalString": "..."}'),
    ),
  },
  required: ['title'],
);

extension type _PersonalDashboardData.fromMap(Map<String, Object?> _json) {
  JsonMap get title => _json['title'] as JsonMap;
  List<Map<String, Object?>>? get sections =>
      (_json['sections'] as List?)?.cast<Map<String, Object?>>();
  List<JsonMap>? get suggestedActions =>
      (_json['suggestedActions'] as List?)?.cast<JsonMap>();
}

final personalDashboard = CatalogItem(
  name: 'PersonalDashboard',
  dataSchema: _schema,
  widgetBuilder: (itemContext) {
    final dashboardData = _PersonalDashboardData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    return _PersonalDashboard(
      title: dashboardData.title,
      sections: dashboardData.sections,
      suggestedActions: dashboardData.suggestedActions,
      dataContext: itemContext.dataContext,
    );
  },
);

class _PersonalDashboard extends StatelessWidget {
  const _PersonalDashboard({
    required this.title,
    this.sections,
    this.suggestedActions,
    required this.dataContext,
  });

  final JsonMap title;
  final List<Map<String, Object?>>? sections;
  final List<JsonMap>? suggestedActions;
  final DataContext dataContext;

  @override
  Widget build(BuildContext context) {
    final titleNotifier = dataContext.subscribeToString(title);

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primarySoft2,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<String?>(
            valueListenable: titleNotifier,
            builder: (_, titleText, _) => Text(
              titleText ?? 'Your Dashboard',
              style: AppStyles.styleRoboto24.copyWith(color: AppColors.primary),
            ),
          ),
          if (sections != null) ...[
            SizedBox(height: 16.h),
            ...sections!.map((section) {
              final labelRef = section['label'] as JsonMap;
              final valueRef = section['value'] as JsonMap;
              final labelNotifier = dataContext.subscribeToString(labelRef);
              final valueNotifier = dataContext.subscribeToString(valueRef);

              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ValueListenableBuilder<String?>(
                      valueListenable: labelNotifier,
                      builder: (_, label, _) =>
                          Text(label ?? '', style: AppStyles.styleRoboto16),
                    ),
                    ValueListenableBuilder<String?>(
                      valueListenable: valueNotifier,
                      builder: (_, value, _) => Text(
                        value ?? '',
                        style: AppStyles.styleRoboto16.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
          if (suggestedActions != null) ...[
            SizedBox(height: 16.h),
            Text(
              'Suggested Actions',
              style: AppStyles.styleRoboto16.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            ...suggestedActions!.map((actionRef) {
              final actionNotifier = dataContext.subscribeToString(actionRef);
              return Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: ValueListenableBuilder<String?>(
                  valueListenable: actionNotifier,
                  builder: (_, action, _) => Row(
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        size: 16.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8.w),
                      Text(action ?? '', style: AppStyles.styleRoboto16),
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
