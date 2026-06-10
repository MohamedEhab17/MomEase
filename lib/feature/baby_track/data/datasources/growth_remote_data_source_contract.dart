import 'package:new_mama/feature/baby_track/data/models/growth_record_model.dart';
import 'package:new_mama/feature/baby_track/data/models/add_growth_record_request_model.dart';
import 'package:new_mama/feature/baby_track/data/models/growth_chart_data_model.dart';
import 'package:new_mama/feature/baby_track/data/models/growth_statistics_model.dart';
import 'package:new_mama/feature/baby_track/data/models/weekly_growth_records_model.dart';
import 'package:new_mama/feature/baby_track/data/models/monthly_growth_records_model.dart';

abstract class GrowthRemoteDataSourceContract {
  Future<GrowthRecordModel> addGrowthRecord(
    int childId,
    AddGrowthRecordRequestModel body,
  );

  Future<List<GrowthRecordModel>> getGrowthRecords(int childId);
  Future<void> deleteGrowthRecord(int childId, int id);
  Future<GrowthChartDataModel> getGrowthChartData(int childId);
  Future<GrowthStatisticsModel> getGrowthStatistics(int childId);
  Future<WeeklyGrowthRecordsModel> getWeeklyGrowthRecords(int childId);
  Future<MonthlyGrowthRecordsModel> getMonthlyGrowthRecords(int childId);
}
