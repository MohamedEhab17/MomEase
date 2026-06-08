import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/string_ex.dart';

final _schema = S.object(
  properties: {
    'title': S.object(
      description: 'Insight title. Use {"literalString": "..."}',
    ),
    'message': S.object(
      description: 'Insight message. Use {"literalString": "..."}',
    ),
    'type': S.string(
      description: 'Type of insight: "info", "warning", "success".',
    ),
  },
  required: ['title', 'message'],
);

extension type _InsightCardData.fromMap(Map<String, Object?> _json) {
  JsonMap get title => _json['title'] as JsonMap;
  JsonMap get message => _json['message'] as JsonMap;
  String? get type => _json['type'] as String?;
}

final insightCard = CatalogItem(
  name: 'InsightCard',
  dataSchema: _schema,
  widgetBuilder: (itemContext) {
    final cardData = _InsightCardData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    return _InsightCard(
      title: cardData.title,
      message: cardData.message,
      type: cardData.type ?? 'info',
      dataContext: itemContext.dataContext,
    );
  },
);

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.title,
    required this.message,
    required this.type,
    required this.dataContext,
  });

  final JsonMap title;
  final JsonMap message;
  final String type;
  final DataContext dataContext;

  Color _getColor(BuildContext context) {
    switch (type) {
      case 'warning':
        return Colors.orange;
      case 'success':
        return Colors.green;
      default:
        return context.ext.colors.primary;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case 'warning':
        return Icons.warning;
      case 'success':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleNotifier = dataContext.subscribeToString(title);
    final messageNotifier = dataContext.subscribeToString(message);
    final color = _getColor(context);
    final icon = _getIcon();

    return Container(
      margin: EdgeInsets.all(16.w),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ValueListenableBuilder<String?>(
                  valueListenable: titleNotifier,
                  builder: (_, titleText, _) {
                    final textVal = titleText ?? '';
                    final isAr = textVal.isArabic;
                    return Text(
                      textVal,
                      textAlign: isAr ? TextAlign.right : TextAlign.left,
                      textDirection: isAr
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      style: AppStyles.styleRoboto16.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    );
                  },
                ),
                SizedBox(height: 4.h),
                ValueListenableBuilder<String?>(
                  valueListenable: messageNotifier,
                  builder: (_, messageText, _) {
                    final textVal = messageText ?? '';
                    final isAr = textVal.isArabic;
                    return Text(
                      textVal,
                      textAlign: isAr ? TextAlign.right : TextAlign.left,
                      textDirection: isAr
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      style: AppStyles.styleRoboto16,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
