import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final _schema = S.object(
  properties: {
    'title': S.object(
      description: 'Timeline title. Use {"literalString": "..."}',
    ),
    'activities': S.list(
      description: 'List of activities to display.',
      items: S.object(
        properties: {
          'time': S.object(
            description: 'Activity time. Use {"literalString": "..."}',
          ),
          'type': S.object(
            description: 'Activity type. Use {"literalString": "..."}',
          ),
          'description': S.object(
            description: 'Activity description. Use {"literalString": "..."}',
          ),
        },
        required: ['time', 'type'],
      ),
    ),
  },
  required: ['title', 'activities'],
);

extension type _ActivityTimelineData.fromMap(Map<String, Object?> _json) {
  JsonMap get title => _json['title'] as JsonMap;
  List<Map<String, Object?>> get activities =>
      (_json['activities'] as List).cast<Map<String, Object?>>();
}

final activityTimeline = CatalogItem(
  name: 'ActivityTimeline',
  dataSchema: _schema,
  widgetBuilder: (itemContext) {
    final timelineData = _ActivityTimelineData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    return _ActivityTimeline(
      title: timelineData.title,
      activities: timelineData.activities,
      dataContext: itemContext.dataContext,
    );
  },
);

class _ActivityTimeline extends StatelessWidget {
  const _ActivityTimeline({
    required this.title,
    required this.activities,
    required this.dataContext,
  });

  final JsonMap title;
  final List<Map<String, Object?>> activities;
  final DataContext dataContext;

  @override
  Widget build(BuildContext context) {
    final titleNotifier = dataContext.subscribeToString(title);

    return Container(
      margin: EdgeInsets.all(16.w),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
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
              titleText ?? 'Recent Activities',
              style: AppStyles.styleRoboto24.copyWith(color: AppColors.primary),
            ),
          ),
          SizedBox(height: 16.h),
          ...activities.map((activity) {
            final timeRef = activity['time'] as JsonMap;
            final typeRef = activity['type'] as JsonMap;
            final descRef = activity['description'] as JsonMap?;

            final timeNotifier = dataContext.subscribeToString(timeRef);
            final typeNotifier = dataContext.subscribeToString(typeRef);
            final descNotifier = descRef != null
                ? dataContext.subscribeToString(descRef)
                : null;

            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder<String?>(
                          valueListenable: timeNotifier,
                          builder: (_, time, _) => Text(
                            time ?? '',
                            style: AppStyles.styleRoboto12.copyWith(
                              color: AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        ValueListenableBuilder<String?>(
                          valueListenable: typeNotifier,
                          builder: (_, type, _) => Text(
                            type ?? '',
                            style: AppStyles.styleRoboto16.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (descNotifier != null) ...[
                          SizedBox(height: 4.h),
                          ValueListenableBuilder<String?>(
                            valueListenable: descNotifier,
                            builder: (_, desc, _) => Text(
                              desc ?? '',
                              style: AppStyles.styleRoboto16,
                            ),
                          ),
                        ],
                      ],
                    ),
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
