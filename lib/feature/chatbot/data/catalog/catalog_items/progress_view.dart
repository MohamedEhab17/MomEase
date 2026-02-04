import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final _schema = S.object(
  properties: {
    'title': S.object(
      description: 'Progress view title. Use {"literalString": "..."}',
    ),
    'dataPoints': S.list(
      description: 'List of data points for the progress chart.',
      items: S.object(
        properties: {
          'label': S.object(
            description: 'Data point label. Use {"literalString": "..."}',
          ),
          'value': S.number(description: 'Data point value.'),
        },
        required: ['label', 'value'],
      ),
    ),
  },
  required: ['title', 'dataPoints'],
);

extension type _ProgressViewData.fromMap(Map<String, Object?> _json) {
  JsonMap get title => _json['title'] as JsonMap;
  List<Map<String, Object?>> get dataPoints =>
      (_json['dataPoints'] as List).cast<Map<String, Object?>>();
}

final progressView = CatalogItem(
  name: 'ProgressView',
  dataSchema: _schema,
  widgetBuilder: (itemContext) {
    final viewData = _ProgressViewData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    return _ProgressView(
      title: viewData.title,
      dataPoints: viewData.dataPoints,
      dataContext: itemContext.dataContext,
    );
  },
);

class _ProgressView extends StatelessWidget {
  const _ProgressView({
    required this.title,
    required this.dataPoints,
    required this.dataContext,
  });

  final JsonMap title;
  final List<Map<String, Object?>> dataPoints;
  final DataContext dataContext;

  @override
  Widget build(BuildContext context) {
    final titleNotifier = dataContext.subscribeToString(title);
    final maxValue = dataPoints
        .map((dp) => (dp['value'] as num?)?.toDouble() ?? 0.0)
        .fold(0.0, (a, b) => a > b ? a : b);

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primarySoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<String?>(
            valueListenable: titleNotifier,
            builder: (_, titleText, _) => Text(
              titleText ?? 'Progress',
              style: AppStyles.styleRoboto24.copyWith(color: AppColors.primary),
            ),
          ),
          SizedBox(height: 16.h),
          ...dataPoints.map((dp) {
            final labelRef = dp['label'] as JsonMap;
            final value = (dp['value'] as num?)?.toDouble() ?? 0.0;
            final labelNotifier = dataContext.subscribeToString(labelRef);
            final percentage = maxValue > 0 ? (value / maxValue) : 0.0;

            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ValueListenableBuilder<String?>(
                          valueListenable: labelNotifier,
                          builder: (_, label, _) =>
                              Text(label ?? '', style: AppStyles.styleRoboto16),
                        ),
                      ),
                      Text(
                        value.toStringAsFixed(1),
                        style: AppStyles.styleRoboto16.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: AppColors.primarySoft3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                    minHeight: 8.h,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
