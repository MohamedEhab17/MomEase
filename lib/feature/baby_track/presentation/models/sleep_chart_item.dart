/// Presentation-layer model used exclusively for sleep chart rendering.
/// Must NOT be moved to the domain layer.
class SleepChartItem {
  final DateTime date;

  /// Sleep duration in fractional hours, or null if no data was logged.
  final double? sleepHours;

  /// Raw status string from the API (e.g. 'good', 'normal', 'poor').
  final String status;

  const SleepChartItem({
    required this.date,
    required this.sleepHours,
    required this.status,
  });
}
