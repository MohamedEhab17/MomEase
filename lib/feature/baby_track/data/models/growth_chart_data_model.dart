import 'package:new_mama/feature/baby_track/domain/entities/growth_chart_data_entity.dart';

class GrowthChartPointModel extends GrowthChartPointEntity {
  const GrowthChartPointModel({
    required super.date,
    required super.ageInWeeks,
    required super.value,
  });

  factory GrowthChartPointModel.fromJson(Map<String, dynamic> json) {
    return GrowthChartPointModel(
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : DateTime.now(),
      ageInWeeks: json['ageInWeeks'] as int? ?? 0,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class GrowthChartDataModel extends GrowthChartDataEntity {
  const GrowthChartDataModel({
    required super.childName,
    required super.weightData,
    required super.heightData,
  });

  factory GrowthChartDataModel.fromJson(Map<String, dynamic> json) {
    return GrowthChartDataModel(
      childName: json['childName'] as String? ?? '',
      weightData: (json['weightData'] as List<dynamic>?)
              ?.map((e) => GrowthChartPointModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      heightData: (json['heightData'] as List<dynamic>?)
              ?.map((e) => GrowthChartPointModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
