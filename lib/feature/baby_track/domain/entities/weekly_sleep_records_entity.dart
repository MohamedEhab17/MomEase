import 'package:equatable/equatable.dart';

class WeeklySleepRecordsEntity extends Equatable {
  final DateTime weekStart;
  final DateTime weekEnd;
  final List<DailySleepRecordEntity> dailySleep;
  final String weeklyAverageSleep;
  final int totalRecords;

  const WeeklySleepRecordsEntity({
    required this.weekStart,
    required this.weekEnd,
    required this.dailySleep,
    required this.weeklyAverageSleep,
    required this.totalRecords,
  });

  @override
  List<Object?> get props => [
        weekStart,
        weekEnd,
        dailySleep,
        weeklyAverageSleep,
        totalRecords,
      ];
}

class DailySleepRecordEntity extends Equatable {
  final DateTime date;
  final String? sleepHours; // nullable – "HH:mm:ss" or null
  final String status;

  const DailySleepRecordEntity({
    required this.date,
    required this.sleepHours,
    required this.status,
  });

  /// Returns sleep duration as fractional hours, or null if no data.
  double? get sleepHoursAsDouble {
    if (sleepHours == null) return null;
    final parts = sleepHours!.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    return h + m / 60.0;
  }

  @override
  List<Object?> get props => [date, sleepHours, status];
}
