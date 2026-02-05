import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final _schema = S.object(
  properties: {
    'title': S.object(
      description: 'Tracker title. Use {"literalString": "..."}',
    ),
    'currentMood': S.object(
      description: 'Current mood value. Use {"literalString": "..."}',
    ),
    'trend': S.string(description: 'Trend: "up", "down", "stable".'),
  },
  required: ['title'],
);

extension type _MoodTrackerData.fromMap(Map<String, Object?> _json) {
  JsonMap get title => _json['title'] as JsonMap;
  JsonMap? get currentMood => _json['currentMood'] as JsonMap?;
  String? get trend => _json['trend'] as String?;
}

final moodTracker = CatalogItem(
  name: 'MoodTracker',
  dataSchema: _schema,
  widgetBuilder: (itemContext) {
    final trackerData = _MoodTrackerData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    return _MoodTracker(
      title: trackerData.title,
      currentMood: trackerData.currentMood,
      trend: trackerData.trend,
      dataContext: itemContext.dataContext,
    );
  },
);

class _MoodTracker extends StatelessWidget {
  const _MoodTracker({
    required this.title,
    this.currentMood,
    this.trend,
    required this.dataContext,
  });

  final JsonMap title;
  final JsonMap? currentMood;
  final String? trend;
  final DataContext dataContext;

  IconData _getTrendIcon(String? trendValue) {
    switch (trendValue) {
      case 'up':
        return Icons.trending_up;
      case 'down':
        return Icons.trending_down;
      default:
        return Icons.trending_flat;
    }
  }

  Color _getTrendColor(String? trendValue) {
    switch (trendValue) {
      case 'up':
        return Colors.green;
      case 'down':
        return Colors.red;
      default:
        return AppColors.lightTextSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleNotifier = dataContext.subscribeToString(title);
    final moodNotifier = currentMood != null
        ? dataContext.subscribeToString(currentMood!)
        : null;

    return Container(
      margin: EdgeInsets.all(16.w),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
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
              titleText ?? 'Mood Tracker',
              style: AppStyles.styleRoboto24.copyWith(color: AppColors.primary),
            ),
          ),
          if (moodNotifier != null) ...[
            SizedBox(height: 12.h),
            ValueListenableBuilder<String?>(
              valueListenable: moodNotifier,
              builder: (_, mood, _) => Text(
                'Current Mood: ${mood ?? "Not set"}',
                style: AppStyles.styleRoboto16,
              ),
            ),
          ],
          if (trend != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  _getTrendIcon(trend),
                  color: _getTrendColor(trend),
                  size: 20.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Trend: ${trend!.toUpperCase()}',
                  style: AppStyles.styleRoboto16.copyWith(
                    color: _getTrendColor(trend),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
