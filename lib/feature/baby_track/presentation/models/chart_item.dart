/// Presentation-layer model used exclusively for chart rendering.
/// Must NOT be moved to the domain layer.
class ChartItem {
  final DateTime date;
  final int timesPerDay;
  final String primaryFeedingType;
  final String status;

  const ChartItem({
    required this.date,
    required this.timesPerDay,
    required this.primaryFeedingType,
    required this.status,
  });
}
