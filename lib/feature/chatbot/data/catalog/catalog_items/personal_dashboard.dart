import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'shared/shared_widgets.dart';

final _schema = S.object(
  description: 'A comprehensive, personalized visual dashboard for the mother displaying key postpartum sections, dynamic updates, and suggested action items.',
  properties: {
    'title': S.object(
      description: 'Title for the personal dashboard. Must use {"literalString": "..."} format.',
    ),
    'sections': S.list(
      description: 'List of progress, health, or recovery metrics sections.',
      items: S.object(
        properties: {
          'label': S.object(
            description: 'Label representing the metric. Must use {"literalString": "..."}.',
          ),
          'value': S.object(
            description: 'Current value or status of the metric. Must use {"literalString": "..."}.',
          ),
          'icon': S.string(
            description: 'Optional icon name for this section (e.g., "healing", "battery_charging", "calendar_today", "child_care").',
          ),
        },
        required: ['label', 'value'],
      ),
    ),
    'suggestedActions': S.list(
      description: 'Actionable suggestions or tasks for maternal care.',
      items: S.object(
        description: 'Suggested action label. Must use {"literalString": "..."} format.',
      ),
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
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "PersonalDashboard": {
              "title": {"literalString": "Mama's Status"},
              "sections": [
                {
                  "label": {"literalString": "Energy Level"},
                  "value": {"literalString": "Optimal"},
                  "icon": "battery_charging"
                },
                {
                  "label": {"literalString": "Recovery Day"},
                  "value": {"literalString": "Day 12"},
                  "icon": "healing"
                }
              ],
              "suggestedActions": [
                {"literalString": "Hydrate and drink 250ml water"},
                {"literalString": "Do pelvic floor exercises"}
              ]
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (itemContext) {
    final dashboardData = _PersonalDashboardData.fromMap(
      itemContext.data as Map<String, Object?>,
    );
    return _PersonalDashboard(
      title: dashboardData.title,
      sections: dashboardData.sections,
      suggestedActions: dashboardData.suggestedActions,
      widgetId: itemContext.id,
      dispatchEvent: itemContext.dispatchEvent,
      dataContext: itemContext.dataContext,
    );
  },
);

class _PersonalDashboard extends StatelessWidget {
  const _PersonalDashboard({
    required this.title,
    this.sections,
    this.suggestedActions,
    required this.widgetId,
    required this.dispatchEvent,
    required this.dataContext,
  });

  final JsonMap title;
  final List<Map<String, Object?>>? sections;
  final List<JsonMap>? suggestedActions;
  final String widgetId;
  final DispatchEventCallback dispatchEvent;
  final DataContext dataContext;

  IconData _getIcon(String? iconName) {
    switch (iconName?.toLowerCase()) {
      case 'healing':
        return Icons.healing_rounded;
      case 'battery_charging':
        return Icons.battery_charging_full_rounded;
      case 'calendar_today':
        return Icons.calendar_today_rounded;
      case 'child_care':
        return Icons.child_care_rounded;
      case 'favorite':
        return Icons.favorite_rounded;
      case 'spa':
        return Icons.spa_rounded;
      default:
        return Icons.dashboard_customize_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;
    final titleNotifier = dataContext.subscribeToString(title);

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
              // Header Row
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: colors.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.dashboard_rounded,
                      color: colors.primary,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ValueListenableBuilder<String?>(
                      valueListenable: titleNotifier,
                      builder: (context, titleText, child) => Text(
                        titleText ?? 'Your Dashboard',
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

              // Sections Display
              if (sections == null || sections!.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: const GenUIEmptyState(
                    message: 'No status information tracking currently.',
                    icon: Icons.info_outline_rounded,
                  ),
                )
              else
                ...sections!.map((section) {
                  final labelRef = section['label'] as JsonMap?;
                  final valueRef = section['value'] as JsonMap?;
                  final iconName = section['icon'] as String?;

                  if (labelRef == null || valueRef == null) {
                    return const SizedBox.shrink();
                  }

                  final labelNotifier = dataContext.subscribeToString(labelRef);
                  final valueNotifier = dataContext.subscribeToString(valueRef);

                  return Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: colors.lightBackground,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: colors.greyExtraLight.withAlpha(128),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getIcon(iconName),
                          size: 20.sp,
                          color: colors.primary.withAlpha(200),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: ValueListenableBuilder<String?>(
                            valueListenable: labelNotifier,
                            builder: (context, label, child) => Text(
                              label ?? '',
                              style: AppStyles.styleRoboto16.copyWith(
                                color: colors.lightTextPrimary.withAlpha(204),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        ValueListenableBuilder<String?>(
                          valueListenable: valueNotifier,
                          builder: (context, value, child) => Text(
                            value ?? '',
                            style: AppStyles.styleRoboto16.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

              // Suggested Actions
              if (suggestedActions != null && suggestedActions!.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Text(
                  'Suggested for You',
                  style: AppStyles.styleRoboto16.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.lightTextPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: suggestedActions!.map((actionRef) {
                    final actionNotifier = dataContext.subscribeToString(actionRef);
                    return ValueListenableBuilder<String?>(
                      valueListenable: actionNotifier,
                      builder: (context, actionText, child) {
                        if (actionText == null || actionText.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Material(
                          color: colors.primaryExtraLight.withAlpha(128),
                          borderRadius: BorderRadius.circular(24.r),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24.r),
                            onTap: () {
                              dispatchEvent(
                                UserActionEvent(
                                  name: 'dashboard_action_selected',
                                  sourceComponentId: widgetId,
                                  context: {
                                    'actionText': actionText,
                                  },
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 6.h,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14.sp,
                                    color: colors.primary,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    actionText,
                                    style: AppStyles.styleRoboto12.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colors.primaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
