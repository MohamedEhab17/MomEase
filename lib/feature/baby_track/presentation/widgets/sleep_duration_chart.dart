import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/date_time_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_sleep_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/sleep_statistics_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_sleep_records_entity.dart';
import 'package:new_mama/feature/baby_track/presentation/mappers/sleep_chart_mapper.dart';
import 'package:new_mama/feature/baby_track/presentation/models/sleep_chart_item.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/sleep_chart/sleep_chart_header.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/sleep_chart/sleep_chart_view.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/sleep_chart/sleep_period_summary.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/sleep_chart/sleep_reference_card.dart';

class SleepDurationChart extends StatefulWidget {
  const SleepDurationChart({
    super.key,
    required this.weeklyRecords,
    required this.monthlyRecords,
    required this.statistics,
  });

  final WeeklySleepRecordsEntity weeklyRecords;
  final MonthlySleepRecordsEntity monthlyRecords;
  final SleepStatisticsEntity statistics;

  @override
  State<SleepDurationChart> createState() => _SleepDurationChartState();
}

class _SleepDurationChartState extends State<SleepDurationChart>
    with SingleTickerProviderStateMixin {
  // ── State ────────────────────────────────────────────────────────────────
  bool _isWeekly = true;
  int _selectedIndex = -1;

  // ── Animation ────────────────────────────────────────────────────────────
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  // ── Chart data (computed once and cached) ────────────────────────────────
  late final List<SleepChartItem> _weeklyItems;
  late final List<SleepChartItem> _monthlyItems;

  // ── Getters ──────────────────────────────────────────────────────────────

  /// Items for whichever period is currently selected.
  List<SleepChartItem> get _currentItems =>
      _isWeekly ? _weeklyItems : _monthlyItems;

  /// Human-readable date-range / period label shown in the header.
  String get _dateRangeLabel {
    if (_isWeekly) {
      final records = widget.weeklyRecords.dailySleep;
      if (records.isEmpty) return '';
      return records.first.date.formatChartDateRange(context, records.last.date);
    }
    return widget.monthlyRecords.monthName;
  }

  /// Pre-formatted average sleep string for the period overview card.
  String get _formattedAverage => _isWeekly
      ? _formatHours(_parseHours(widget.weeklyRecords.weeklyAverageSleep))
      : _formatHours(_parseHours(widget.monthlyRecords.monthlyAverageSleep));

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();

    _weeklyItems = SleepChartMapper.fromWeekly(widget.weeklyRecords);
    _monthlyItems = SleepChartMapper.fromMonthly(widget.monthlyRecords);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  /// Parses "HH:mm:ss" → fractional hours. Returns 0.0 on failure.
  double _parseHours(String hms) {
    final parts = hms.split(':');
    if (parts.length < 2) return 0.0;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    return h + m / 60.0;
  }

  /// Formats fractional hours into a human-readable string (e.g. "7h 30m").
  String _formatHours(double h) {
    final hours = h.floor();
    final mins = ((h - hours) * 60).round();
    if (hours == 0) return '${mins}m';
    if (mins == 0) return '${hours}h';
    return '${hours}h ${mins}m';
  }

  void _onToggleWeekly() {
    if (!_isWeekly) _switchPeriod(weekly: true);
  }

  void _onToggleMonthly() {
    if (_isWeekly) _switchPeriod(weekly: false);
  }

  void _switchPeriod({required bool weekly}) {
    setState(() {
      _isWeekly = weekly;
      _selectedIndex = -1;
      _animationController
        ..reset()
        ..forward();
    });
  }

  void _onBarTap(
    TapUpDetails details,
    double chartWidth,
    double barSpacing,
  ) {
    final double localX = details.localPosition.dx - 28;
    if (localX < 0 || localX > chartWidth) return;

    final int index = (localX / barSpacing).floor();
    if (index < 0 || index >= _currentItems.length) return;

    setState(() {
      _selectedIndex = (_selectedIndex == index) ? -1 : index;
    });
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SleepChartHeader(
          isWeekly: _isWeekly,
          dateRangeLabel: _dateRangeLabel,
          onToggleWeekly: _onToggleWeekly,
          onToggleMonthly: _onToggleMonthly,
        ),
        24.h.height,

        SleepChartView(
          items: _currentItems,
          selectedIndex: _selectedIndex,
          fadeAnimation: _fadeAnimation,
          isWeekly: _isWeekly,
          onTapUp: _onBarTap,
        ),
        24.h.height,

        SleepPeriodSummary(
          isWeekly: _isWeekly,
          weeklyRecords: widget.weeklyRecords,
          monthlyRecords: widget.monthlyRecords,
          formattedAverage: _formattedAverage,
        ),
        16.h.height,

        SleepReferenceCard(statistics: widget.statistics),
      ],
    );
  }
}
