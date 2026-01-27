import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final _schema = S.object(
  properties: {
    'title': S.object(
      description: 'Analysis title. Use {"literalString": "..."}',
    ),
    'result': S.object(
      description: 'Analysis result. Use {"literalString": "..."}',
    ),
    'confidence': S.number(description: 'Confidence level (0-100).'),
    'disclaimer': S.object(
      description:
          'Disclaimer text about AI analysis. Use {"literalString": "..."}',
    ),
  },
  required: ['title', 'result'],
);

extension type _AnalysisResultCardData.fromMap(Map<String, Object?> _json) {
  JsonMap get title => _json['title'] as JsonMap;
  JsonMap get result => _json['result'] as JsonMap;
  num? get confidence => _json['confidence'] as num?;
  JsonMap? get disclaimer => _json['disclaimer'] as JsonMap?;
}

final analysisResultCard = CatalogItem(
  name: 'AnalysisResultCard',
  dataSchema: _schema,
  widgetBuilder: (itemContext) {
    final cardData = _AnalysisResultCardData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    return _AnalysisResultCard(
      title: cardData.title,
      result: cardData.result,
      confidence: cardData.confidence,
      disclaimer: cardData.disclaimer,
      dataContext: itemContext.dataContext,
    );
  },
);

class _AnalysisResultCard extends StatelessWidget {
  const _AnalysisResultCard({
    required this.title,
    required this.result,
    this.confidence,
    this.disclaimer,
    required this.dataContext,
  });

  final JsonMap title;
  final JsonMap result;
  final num? confidence;
  final JsonMap? disclaimer;
  final DataContext dataContext;

  @override
  Widget build(BuildContext context) {
    final titleNotifier = dataContext.subscribeToString(title);
    final resultNotifier = dataContext.subscribeToString(result);
    final disclaimerNotifier = disclaimer != null
        ? dataContext.subscribeToString(disclaimer!)
        : null;

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primarySoft3,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<String?>(
            valueListenable: titleNotifier,
            builder: (_, titleText, __) => Text(
              titleText ?? 'Analysis Result',
              style: AppStyles.styleRoboto24.copyWith(color: AppColors.primary),
            ),
          ),
          SizedBox(height: 12.h),
          ValueListenableBuilder<String?>(
            valueListenable: resultNotifier,
            builder: (_, resultText, __) =>
                Text(resultText ?? '', style: AppStyles.styleRoboto16),
          ),
          if (confidence != null) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Text('Confidence: ', style: AppStyles.styleRoboto16),
                Text(
                  '${confidence!.toInt()}%',
                  style: AppStyles.styleRoboto16.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
          if (disclaimerNotifier != null) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 20.sp, color: Colors.orange),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ValueListenableBuilder<String?>(
                      valueListenable: disclaimerNotifier,
                      builder: (_, disclaimerText, __) => Text(
                        disclaimerText ?? '',
                        style: AppStyles.styleRoboto12.copyWith(
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
