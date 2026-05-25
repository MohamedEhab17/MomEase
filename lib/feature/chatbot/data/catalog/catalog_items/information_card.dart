import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final _schema = S.object(
  properties: {
    'imageChildId': S.string(
      description:
          'The ID of the Image widget to display at the top of the '
          'card. Create an Image widget with a matching ID.',
    ),
    'title': A2uiSchemas.stringReference(description: 'The title of the card.'),
    'subtitle': A2uiSchemas.stringReference(
      description: 'The subtitle of the card.',
    ),
    'body': A2uiSchemas.stringReference(
      description: 'The body text of the card.',
    ),
  },
  required: ['title', 'body'],
);

extension type _InformationCardData.fromMap(Map<String, Object?> _json) {
  factory _InformationCardData({
    String? imageChildId,
    required JsonMap title,
    JsonMap? subtitle,
    required JsonMap body,
  }) => _InformationCardData.fromMap({
    'imageChildId': ?imageChildId,
    'title': title,
    'subtitle': ?subtitle,
    'body': body,
  });

  String? get imageChildId => _json['imageChildId'] as String?;
  JsonMap get title => _json['title'] as JsonMap;
  JsonMap? get subtitle => _json['subtitle'] as JsonMap?;
  JsonMap get body => _json['body'] as JsonMap;
}

final informationCard = CatalogItem(
  name: 'InformationCard',
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "InformationCard": {
              "title": {
                "literalString": "Postpartum Recovery Tips"
              },
              "subtitle": {
                "literalString": "Essential guidance for new mothers"
              },
              "body": {
                "literalString": "Take time to rest and recover. Your body has been through a lot."
              }
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (context) {
    final cardData = _InformationCardData.fromMap(
      context.data as Map<String, Object?>,
    );
    final Widget? imageChild = cardData.imageChildId != null
        ? context.buildChild(cardData.imageChildId!)
        : null;

    final ValueNotifier<String?> titleNotifier = context.dataContext
        .subscribeToString(cardData.title);
    final ValueNotifier<String?> subtitleNotifier = context.dataContext
        .subscribeToString(cardData.subtitle);
    final ValueNotifier<String?> bodyNotifier = context.dataContext
        .subscribeToString(cardData.body);

    return _InformationCard(
      imageChild: imageChild,
      titleNotifier: titleNotifier,
      subtitleNotifier: subtitleNotifier,
      bodyNotifier: bodyNotifier,
    );
  },
);

class _InformationCard extends StatelessWidget {
  const _InformationCard({
    this.imageChild,
    required this.titleNotifier,
    required this.subtitleNotifier,
    required this.bodyNotifier,
  });

  final Widget? imageChild;
  final ValueNotifier<String?> titleNotifier;
  final ValueNotifier<String?> subtitleNotifier;
  final ValueNotifier<String?> bodyNotifier;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primarySoft3,
            AppColors.primarySoft3.withAlpha(179),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(38),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: AppColors.primary.withAlpha(26), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageChild != null)
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 200.h,
                child: imageChild,
              ),
            ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<String?>(
                  valueListenable: titleNotifier,
                  builder: (context, title, _) => Text(
                    title ?? '',
                    style: AppStyles.styleRoboto24.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                ValueListenableBuilder<String?>(
                  valueListenable: subtitleNotifier,
                  builder: (context, subtitle, _) {
                    if (subtitle == null) return const SizedBox.shrink();
                    return Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        subtitle,
                        style: AppStyles.styleRoboto16.copyWith(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 8.h),
                ValueListenableBuilder<String?>(
                  valueListenable: bodyNotifier,
                  builder: (context, body, _) =>
                      Text(body ?? '', style: AppStyles.styleRoboto16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
