class SleepChartItem {
  final DateTime date;
  final double? sleepHours; // null if no data
  final String status;

  SleepChartItem({
    required this.date,
    required this.sleepHours,
    required this.status,
  });
}
