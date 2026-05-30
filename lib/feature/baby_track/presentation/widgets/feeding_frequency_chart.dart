import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_track/domain/entities/feeding_statistics_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_feeding_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_feeding_records_entity.dart';
import 'package:new_mama/feature/baby_track/presentation/mappers/feeding_chart_mapper.dart';
import 'package:new_mama/feature/baby_track/presentation/models/chart_item.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/feeding_chart/feeding_bar_chart_painter.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/feeding_chart/feeding_chart_header.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/feeding_chart/feeding_chart_tooltip.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/feeding_chart/feeding_period_summary.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/feeding_chart/feeding_reference_card.dart';

class FeedingFrequencyChart extends StatefulWidget {
  const FeedingFrequencyChart({
    super.key,
    required this.weeklyRecords,
    required this.monthlyRecords,
    required this.statistics,
  });

  final WeeklyFeedingRecordsEntity weeklyRecords;
  final MonthlyFeedingRecordsEntity monthlyRecords;
  final FeedingStatisticsEntity statistics;

  @override
  State<FeedingFrequencyChart> createState() => _FeedingFrequencyChartState();
}

class _FeedingFrequencyChartState extends State<FeedingFrequencyChart>
    with SingleTickerProviderStateMixin {
  // ── State ────────────────────────────────────────────────────────────────
  bool _isWeekly = true;
  int _selectedIndex = -1;

  // ── Animation ────────────────────────────────────────────────────────────
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  // ── Chart data (computed once and cached) ────────────────────────────────
  late final List<ChartItem> _weeklyItems;
  late final List<ChartItem> _monthlyItems;

  // ── Getters ──────────────────────────────────────────────────────────────

  /// Items for whichever period is currently selected.
  List<ChartItem> get _currentItems => _isWeekly ? _weeklyItems : _monthlyItems;

  /// Human-readable date-range / period label shown in the header.
  String get _dateRangeLabel {
    if (_isWeekly) {
      final records = widget.weeklyRecords.dailyRecords;
      if (records.isEmpty) return '';
      return '${records.first.date.day} ${_monthName(records.first.date.month)}'
          ' - '
          '${records.last.date.day} ${_monthName(records.last.date.month)}';
    }
    return widget.monthlyRecords.monthName;
  }

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();

    _weeklyItems = FeedingChartMapper.fromWeekly(widget.weeklyRecords);
    _monthlyItems = FeedingChartMapper.fromMonthly(widget.monthlyRecords);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  String _monthName(int month) {
    const keys = [
      TK.commonMonthJan, TK.commonMonthFeb, TK.commonMonthMar,
      TK.commonMonthApr, TK.commonMonthMay, TK.commonMonthJun,
      TK.commonMonthJul, TK.commonMonthAug, TK.commonMonthSep,
      TK.commonMonthOct, TK.commonMonthNov, TK.commonMonthDec,
    ];
    return context.trContext(keys[month - 1]);
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

  void _onBarTap(TapUpDetails details, double chartWidth, double barSpacing) {
    final double localX = details.localPosition.dx - 25;
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
    final items = _currentItems;
    final colors = context.ext.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FeedingChartHeader(
          isWeekly: _isWeekly,
          weeklyRecords: widget.weeklyRecords,
          monthlyRecords: widget.monthlyRecords,
          dateRangeLabel: _dateRangeLabel,
          onToggleWeekly: _onToggleWeekly,
          onToggleMonthly: _onToggleMonthly,
        ),
        24.h.height,

        // ── Chart canvas + tooltip overlay ──
        LayoutBuilder(
          builder: (context, constraints) {
            final double chartWidth = constraints.maxWidth - 25;
            final double barSpacing =
                items.isNotEmpty ? chartWidth / items.length : 1;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTapUp: (d) => _onBarTap(d, chartWidth, barSpacing),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      height: 140.h,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: FeedingBarChartPainter(
                          items: items,
                          selectedIndex: _selectedIndex,
                          primaryDark: colors.primaryDark,
                          primaryAccent: colors.primaryAccent,
                          gridColor: colors.greyLight,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_selectedIndex >= 0 && _selectedIndex < items.length)
                  _buildTooltip(
                    context,
                    items[_selectedIndex],
                    _selectedIndex,
                    barSpacing,
                    constraints.maxWidth,
                  ),
              ],
            );
          },
        ),
        12.h.height,

        // ── X-axis labels ──
        _XAxisLabels(
          isWeekly: _isWeekly,
          items: items,
          monthName: _monthName,
        ),
        24.h.height,

        // ── Period summary ──
        FeedingPeriodSummary(
          isWeekly: _isWeekly,
          weeklyRecords: widget.weeklyRecords,
          monthlyRecords: widget.monthlyRecords,
          items: items,
        ),
        16.h.height,

        // ── Pediatrician reference card ──
        FeedingReferenceCard(statistics: widget.statistics),
      ],
    );
  }

  /// Positions the tooltip above the selected bar, clamped to screen edges.
  Widget _buildTooltip(
    BuildContext context,
    ChartItem item,
    int index,
    double barSpacing,
    double maxWidth,
  ) {
    const double tooltipWidth = 145;
    final double barCenterX = 25 + (index * barSpacing) + (barSpacing / 2);
    double left = barCenterX - (tooltipWidth / 2);
    left = left.clamp(4.0, maxWidth - tooltipWidth - 4);

    return Positioned(
      top: -65.h,
      left: left,
      child: FeedingChartTooltip(
        item: item,
        monthName: _monthName(item.date.month),
      ),
    );
  }
}

// ── Private sub-widget ───────────────────────────────────────────────────────

/// X-axis label row rendered below the chart canvas.
class _XAxisLabels extends StatelessWidget {
  const _XAxisLabels({
    required this.isWeekly,
    required this.items,
    required this.monthName,
  });

  final bool isWeekly;
  final List<ChartItem> items;

  /// Callback that returns the localised month name for a 1-based [month].
  final String Function(int month) monthName;

  static const _weekdayKeys = [
    TK.commonDayMon, TK.commonDayTue, TK.commonDayWed,
    TK.commonDayThu, TK.commonDayFri, TK.commonDaySat, TK.commonDaySun,
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;
    final labelStyle = context.text.bodySmall!.copyWith(
      fontSize: 10.sp,
      fontWeight: FontWeight.w600,
      color: colors.lightTextSecondary,
    );

    return Padding(
      padding: EdgeInsets.only(left: 25.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: isWeekly
            ? _weeklyLabels(context, labelStyle)
            : _monthlyLabels(labelStyle),
      ),
    );
  }

  List<Widget> _weeklyLabels(BuildContext context, TextStyle style) =>
      items.map((item) {
        final label = context.trContext(_weekdayKeys[item.date.weekday - 1]);
        return Expanded(
          child: Center(child: Text(label, style: style)),
        );
      }).toList();

  List<Widget> _monthlyLabels(TextStyle style) {
    if (items.isEmpty) return [];
    final int step = ((items.length - 1) / 4).round().clamp(1, items.length);
    return List.generate(5, (i) {
      final itemIndex = (step * i).clamp(0, items.length - 1);
      final item = items[itemIndex];
      return Text(
        '${item.date.day} ${monthName(item.date.month)}',
        style: style,
      );
    });
  }
}
