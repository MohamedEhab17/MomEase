import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'shared/shared_widgets.dart';

final _schema = S.object(
  description: 'A horizontal scrollable list of wellbeing cards providing guidance, tasks, or supportive actions for postpartum moms.',
  properties: {
    'items': S.list(
      description: 'The collection of wellbeing support cards to be displayed.',
      items: S.object(
        properties: {
          'title': S.object(
            description: 'Main heading for the card. Must use {"literalString": "..."} format.',
          ),
          'description': S.object(
            description: 'Brief supportive description or tip. Must use {"literalString": "..."} format.',
          ),
          'icon': S.string(
            description: 'Icon displaying the category (e.g., "favorite", "child_care", "health_and_safety", "self_improvement", "spa", "mood", "psychology", "directions_run").',
          ),
          'action': S.object(
            description: 'Interactive tap event config. Must use {"name": "...", "context": [...]} structure.',
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
      ((_json['items'] as List?) ?? const <Object?>[]).cast<Map<String, Object?>>();
}

final wellbeingCarousel = CatalogItem(
  name: 'WellbeingCarousel',
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "WellbeingCarousel": {
              "items": [
                {
                  "title": {"literalString": "Meditation Time"},
                  "description": {"literalString": "Relax for 5 minutes with breathing exercises."},
                  "icon": "spa",
                  "action": {"name": "start_meditation", "context": []}
                },
                {
                  "title": {"literalString": "Mood Check"},
                  "description": {"literalString": "Check in with your feelings today."},
                  "icon": "mood",
                  "action": {"name": "check_mood", "context": []}
                }
              ]
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (itemContext) {
    final carouselData = _WellbeingCarouselData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    return _WellbeingCarousel(
      items: carouselData.items,
      widgetId: itemContext.id,
      dispatchEvent: itemContext.dispatchEvent,
      dataContext: itemContext.dataContext,
    );
  },
);

class _WellbeingCarousel extends StatelessWidget {
  const _WellbeingCarousel({
    required this.items,
    required this.widgetId,
    required this.dispatchEvent,
    required this.dataContext,
  });

  final List<Map<String, Object?>> items;
  final String widgetId;
  final DispatchEventCallback dispatchEvent;
  final DataContext dataContext;

  IconData _getIcon(String? iconName) {
    switch (iconName?.toLowerCase()) {
      case 'favorite':
        return Icons.favorite;
      case 'child_care':
        return Icons.child_care;
      case 'health_and_safety':
        return Icons.health_and_safety;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'spa':
        return Icons.spa_rounded;
      case 'mood':
        return Icons.mood_rounded;
      case 'directions_run':
        return Icons.directions_run_rounded;
      case 'medical_services':
        return Icons.medical_services_rounded;
      case 'psychology':
        return Icons.psychology_rounded;
      case 'family_restroom':
        return Icons.family_restroom_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const GenUIEntranceAnimation(
        child: GenUIEmptyState(
          message: 'No wellbeing suggestions available right now.',
          icon: Icons.spa_outlined,
        ),
      );
    }

    final colors = context.ext.colors;

    return GenUIEntranceAnimation(
      child: SizedBox(
        height: 200.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          itemCount: items.length,
          separatorBuilder: (context, index) => SizedBox(width: 12.w),
          itemBuilder: (context, index) {
            final item = items[index];
            final titleRef = item['title'] as JsonMap?;
            final descRef = item['description'] as JsonMap?;
            final action = item['action'] as JsonMap?;
            final iconName = item['icon'] as String?;

            if (titleRef == null || descRef == null) {
              return const SizedBox.shrink();
            }

            final titleNotifier = dataContext.subscribeToString(titleRef);
            final descNotifier = dataContext.subscribeToString(descRef);

            return SizedBox(
              width: 165.w,
              child: GenUICard(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(16.r),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14.r),
                    onTap: action == null
                        ? null
                        : () => GenUIActionHelper.dispatch(
                              context: context,
                              action: action,
                              widgetId: '$widgetId[$index]',
                              dispatchEvent: dispatchEvent,
                              dataContext: dataContext,
                            ),
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: colors.primaryExtraLight.withAlpha(128),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getIcon(iconName),
                              size: 32.sp,
                              color: colors.primary,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          ValueListenableBuilder<String?>(
                            valueListenable: titleNotifier,
                            builder: (context, title, child) => Text(
                              title ?? '',
                              style: AppStyles.styleRoboto16.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.primaryDark,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Expanded(
                            child: ValueListenableBuilder<String?>(
                              valueListenable: descNotifier,
                              builder: (context, desc, child) => Text(
                                desc ?? '',
                                style: AppStyles.styleRoboto12.copyWith(
                                  color: colors.lightTextSecondary,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
