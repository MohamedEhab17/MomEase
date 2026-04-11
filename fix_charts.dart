import 'dart:io';

void main() {
  var f1 = File(
    'lib/feature/baby_track/presentation/widgets/feeding_frequency_chart.dart',
  );
  var content = f1.readAsStringSync();
  content = content.replaceAll(
    'painter: _BarChartPainter(data: data),',
    'painter: _BarChartPainter(data: data, primaryDark: Theme.of(context).extension<AppThemeExtension>()!.primaryDark, primaryLighter: Theme.of(context).extension<AppThemeExtension>()!.primaryLighter,),',
  );
  content = content.replaceAll(
    '  _BarChartPainter({required this.data});',
    '  final Color primaryDark;\n  final Color primaryLighter;\n\n  _BarChartPainter({required this.data, required this.primaryDark, required this.primaryLighter});',
  );
  content = content.replaceAll(
    '? Theme.of(context).extension<AppThemeExtension>()!.primaryDark',
    '? primaryDark',
  );
  content = content.replaceAll(
    ': Theme.of(context).extension<AppThemeExtension>()!.primaryLighter.withAlpha(180)',
    ': primaryLighter.withAlpha(180)',
  );
  f1.writeAsStringSync(content);

  var f2 = File(
    'lib/feature/baby_track/presentation/widgets/mood_trend_chart.dart',
  );
  content = f2.readAsStringSync();
  content = content.replaceAll(
    'painter: _MoodLinePainter(points: points)',
    'painter: _MoodLinePainter(points: points, primaryDark: Theme.of(context).extension<AppThemeExtension>()!.primaryDark,)',
  );
  content = content.replaceAll(
    '  _MoodLinePainter({required this.points});',
    '  final Color primaryDark;\n\n  _MoodLinePainter({required this.points, required this.primaryDark});',
  );
  content = content.replaceAll(
    'Theme.of(context).extension<AppThemeExtension>()!.primaryDark.withAlpha(40)',
    'primaryDark.withAlpha(40)',
  );
  content = content.replaceAll(
    '..color = Theme.of(context).extension<AppThemeExtension>()!.primaryDark',
    '..color = primaryDark',
  );
  f2.writeAsStringSync(content);

  var f3 = File(
    'lib/feature/baby_track/presentation/widgets/sleep_duration_chart.dart',
  );
  content = f3.readAsStringSync();
  content = content.replaceAll(
    'painter: _LineChartPainter(points: points),',
    'painter: _LineChartPainter(points: points, primaryDark: Theme.of(context).extension<AppThemeExtension>()!.primaryDark,),',
  );
  content = content.replaceAll(
    '  _LineChartPainter({required this.points});',
    '  final Color primaryDark;\n\n  _LineChartPainter({required this.points, required this.primaryDark});',
  );
  content = content.replaceAll(
    'Theme.of(context).extension<AppThemeExtension>()!.primaryDark.withAlpha(50)',
    'primaryDark.withAlpha(50)',
  );
  content = content.replaceAll(
    'Theme.of(context).extension<AppThemeExtension>()!.primaryDark.withAlpha(0)',
    'primaryDark.withAlpha(0)',
  );
  content = content.replaceAll(
    'Theme.of(context).extension<AppThemeExtension>()!.primaryDark',
    'primaryDark',
  );
  f3.writeAsStringSync(content);
}
