import 'package:new_mama/feature/baby_track/domain/entities/monthly_sleep_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_sleep_records_entity.dart';
import 'package:new_mama/feature/baby_track/presentation/models/sleep_chart_item.dart';

/// Maps domain sleep entities to [SleepChartItem] presentation models.
///
/// Lives in the presentation layer because [SleepChartItem] is purely a UI
/// concern and must not pollute the domain layer.
class SleepChartMapper {
  SleepChartMapper._();

  static List<SleepChartItem> fromWeekly(WeeklySleepRecordsEntity records) =>
      records.dailySleep.map(_mapRecord).toList();

  static List<SleepChartItem> fromMonthly(MonthlySleepRecordsEntity records) =>
      records.dailySleep.map(_mapRecord).toList();

  static SleepChartItem _mapRecord(DailySleepRecordEntity record) =>
      SleepChartItem(
        date: record.date,
        sleepHours: record.sleepHoursAsDouble,
        status: record.status,
      );
}
