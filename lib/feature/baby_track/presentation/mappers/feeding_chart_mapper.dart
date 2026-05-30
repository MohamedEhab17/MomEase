import 'package:new_mama/feature/baby_track/domain/entities/monthly_feeding_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_feeding_records_entity.dart';
import 'package:new_mama/feature/baby_track/presentation/models/chart_item.dart';

/// Maps domain entities to [ChartItem] presentation models.
/// Lives in the presentation layer because [ChartItem] is purely a UI concern.
class FeedingChartMapper {
  FeedingChartMapper._();

  static List<ChartItem> fromWeekly(WeeklyFeedingRecordsEntity records) =>
      records.dailyRecords.map(_mapRecord).toList();

  static List<ChartItem> fromMonthly(MonthlyFeedingRecordsEntity records) =>
      records.dailyRecords.map(_mapRecord).toList();

  static ChartItem _mapRecord(dynamic record) {
    var times = 0;
    var type = 'None';
    var status = 'Normal';

    if (record.records.isNotEmpty) {
      times = record.records.fold<int>(0, (sum, item) => sum + item.timesPerDay as int);
      type = record.records.first.feedingType as String;
      status = record.records.first.status as String;
    }

    return ChartItem(
      date: record.date as DateTime,
      timesPerDay: times,
      primaryFeedingType: type,
      status: status,
    );
  }
}