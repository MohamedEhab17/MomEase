import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final _schema = S.object(
  properties: {
    'items': S.list(
      description: 'A list of wellbeing support areas to display.',
      items: S.object(
        properties: {
          'title': S.object(
            description:
                'Title of the support area. Use {"literalString": "..."}',
          ),
          'description': S.object(
            description:
                'Description of the support area. Use {"literalString": "..."}',
          ),
          'icon': S.string(
            description:
                'Icon name (e.g., "favorite", "child_care", "health_and_safety").',
          ),
          'action': S.object(
            description:
                'Action when item is tapped. Use {"name": "...", "context": [...]}',
          ),
        },
        required: ['title', 'description', 'action'],
      ),
    ),
  },
  required: ['items'],
);

extension type _WellbeingCarouselData.fromMap(Map<String, Object?> _json) {
  List<Map<String, Object?>> get items =>
      (_json['items'] as List).cast<Map<String, Object?>>();
}

final wellbeingCarousel = CatalogItem(
  name: 'WellbeingCarousel',
  dataSchema: _schema,
  widgetBuilder: (itemContext) {
    final carouselData = _WellbeingCarouselData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    return _WellbeingCarousel(
      items: carouselData.items,
      dispatchEvent: itemContext.dispatchEvent,
      dataContext: itemContext.dataContext,
    );
  },
);

class _WellbeingCarousel extends StatelessWidget {
  const _WellbeingCarousel({
    required this.items,
    required this.dispatchEvent,
    required this.dataContext,
  });

  final List<Map<String, Object?>> items;
  final DispatchEventCallback dispatchEvent;
  final DataContext dataContext;

  IconData _getIcon(String? iconName) {
    switch (iconName) {
      case 'favorite':
        return Icons.favorite;
      case 'child_care':
        return Icons.child_care;
      case 'health_and_safety':
        return Icons.health_and_safety;
      case 'self_improvement':
        return Icons.self_improvement;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final item = items[index];
          final titleRef = item['title'] as JsonMap;
          final descRef = item['description'] as JsonMap;
          final action = item['action'] as JsonMap;
          final iconName = item['icon'] as String?;

          final titleNotifier = dataContext.subscribeToString(titleRef);
          final descNotifier = dataContext.subscribeToString(descRef);

          return SizedBox(
            width: 160.w,
            child: Card(
              color: AppColors.primarySoft3,
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
                      sourceComponentId: '',
                      context: resolvedContext,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getIcon(iconName),
                        size: 40.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(height: 8.h),
                      ValueListenableBuilder<String?>(
                        valueListenable: titleNotifier,
                        builder: (_, title, __) => Text(
                          title ?? '',
                          style: AppStyles.styleRoboto16.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      ValueListenableBuilder<String?>(
                        valueListenable: descNotifier,
                        builder: (_, desc, __) => Text(
                          desc ?? '',
                          style: AppStyles.styleRoboto12,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
