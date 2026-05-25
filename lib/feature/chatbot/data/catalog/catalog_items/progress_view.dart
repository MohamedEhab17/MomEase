import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'shared/shared_widgets.dart';

final _schema = S.object(
  description: 'A visual progress chart displaying various metrics or recovery levels (e.g. hydration, sleep, exercise) using comparative bars.',
  properties: {
    'title': S.object(
      description: 'Progress chart title. Must use {"literalString": "..."} format.',
    ),
    'dataPoints': S.list(
      description: 'The progress metrics to plot.',
      items: S.object(
        properties: {
          'label': S.object(
            description: 'The metric name. Must use {"literalString": "..."}.',
          ),
          'value': S.number(description: 'Dynamic value for the metric (e.g. 5.0).'),
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
      ((_json['dataPoints'] as List?) ?? const <Object?>[]).cast<Map<String, Object?>>();
}

final progressView = CatalogItem(
  name: 'ProgressView',
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "ProgressView": {
              "title": {"literalString": "Weekly Recovery Progress"},
              "dataPoints": [
                {
                  "label": {"literalString": "Sleep Quality"},
                  "value": 7.5
                },
                {
                  "label": {"literalString": "Hydration (Liters)"},
                  "value": 2.2
                },
                {
                  "label": {"literalString": "Activity Minutes"},
                  "value": 30.0
                }
              ]
            }
          }
        }
      ]
    ''',
  ],
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
    final colors = context.ext.colors;
    final titleNotifier = dataContext.subscribeToString(title);

    if (dataPoints.isEmpty) {
      return GenUIEntranceAnimation(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: GenUICard(
            child: const GenUIEmptyState(
              message: 'No progress data points available to show.',
              icon: Icons.trending_up_rounded,
            ),
          ),
        ),
      );
    }

    // Safely calculate the max value across all data points
    final double maxValue = dataPoints
        .map((dp) => (dp['value'] as num?)?.toDouble() ?? 0.0)
        .fold(0.0, (a, b) => a > b ? a : b);

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
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: colors.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.poll_rounded,
                      color: colors.primary,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ValueListenableBuilder<String?>(
                      valueListenable: titleNotifier,
                      builder: (context, titleText, child) => Text(
                        titleText ?? 'Your Progress',
                        style: AppStyles.styleRoboto20.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.primaryDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                child: const Divider(),
              ),

              ...dataPoints.map((dp) {
                final labelRef = dp['label'] as JsonMap?;
                final value = (dp['value'] as num?)?.toDouble() ?? 0.0;

                if (labelRef == null) {
                  return const SizedBox.shrink();
                }

                final labelNotifier = dataContext.subscribeToString(labelRef);
                final double percentage = maxValue > 0 ? (value / maxValue) : 0.0;

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
                              builder: (context, label, child) => Text(
                                label ?? '',
                                style: AppStyles.styleRoboto16.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: colors.lightTextPrimary.withAlpha(204),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            value.toStringAsFixed(1),
                            style: AppStyles.styleRoboto16.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(6.r)),
                        child: Stack(
                          children: [
                            // Background track
                            Container(
                              height: 10.h,
                              color: colors.primaryExtraLight.withAlpha(100),
                            ),
                            // Animated percentage indicator
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return Container(
                                  width: constraints.maxWidth * percentage,
                                  height: 10.h,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        colors.primary,
                                        colors.primaryDark,
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6.r),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
