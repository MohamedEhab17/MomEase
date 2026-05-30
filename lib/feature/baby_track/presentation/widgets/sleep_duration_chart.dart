import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_sleep_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_sleep_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/sleep_statistics_entity.dart';

import 'sleep_chart/sleep_chart_item.dart';
import 'sleep_chart/sleep_bar_chart_painter.dart';
import 'sleep_chart/sleep_toggle_tab.dart';
import 'sleep_chart/sleep_metric_item.dart';
import 'sleep_chart/sleep_stat_label.dart';

class SleepDurationChart extends StatefulWidget {
  final WeeklySleepRecordsEntity weeklyRecords;
  final MonthlySleepRecordsEntity monthlyRecords;
  final SleepStatisticsEntity statistics;

  const SleepDurationChart({
    super.key,
    required this.weeklyRecords,
    required this.monthlyRecords,
    required this.statistics,
  });

  @override
  State<SleepDurationChart> createState() => _SleepDurationChartState();
}

class _SleepDurationChartState extends State<SleepDurationChart>
    with SingleTickerProviderStateMixin {
  bool _isWeekly = true;
  int _selectedIndex = -1;

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<SleepChartItem> _getItems() {
    final records =
        _isWeekly ? widget.weeklyRecords.dailySleep : widget.monthlyRecords.dailySleep;

    return records.map((r) {
      return SleepChartItem(
        date: r.date,
        sleepHours: r.sleepHoursAsDouble,
        status: r.status,
      );
    }).toList();
  }

  String _getMonthName(int month) {
    final keys = [
      TK.commonMonthJan,
      TK.commonMonthFeb,
      TK.commonMonthMar,
      TK.commonMonthApr,
      TK.commonMonthMay,
      TK.commonMonthJun,
      TK.commonMonthJul,
      TK.commonMonthAug,
      TK.commonMonthSep,
      TK.commonMonthOct,
      TK.commonMonthNov,
      TK.commonMonthDec,
    ];
    return context.trContext(keys[month - 1]);
  }

  Color _statusColor(String status) {
    final colors = context.ext.colors;
    switch (status.toLowerCase()) {
      case 'good':
        return colors.severityMinimal;
      case 'normal':
        return colors.severityMild;
      case 'poor':
        return colors.severityHigh;
      default:
        return colors.lightTextDisabled;
    }
  }

  Color _statusBgColor(String status) {
    final colors = context.ext.colors;
    switch (status.toLowerCase()) {
      case 'good':
        return colors.severityMinimalBg;
      case 'normal':
        return colors.severityMildBg;
      case 'poor':
        return colors.severityHighBg;
      default:
        return colors.primaryLighter.withValues(alpha: 20);
    }
  }

  String _formatStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'good':
        return context.trContext(TK.babySleepStatusGood);
      case 'normal':
        return context.trContext(TK.babySleepStatusNormal);
      case 'poor':
        return context.trContext(TK.babySleepStatusPoor);
      default:
        return context.trContext(TK.babySleepStatusUnknown);
    }
  }

  /// Parses "HH:mm:ss" -> fractional hours. Returns 0.0 on failure.
  double _parseHours(String hms) {
    final parts = hms.split(':');
    if (parts.length < 2) return 0.0;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    return h + m / 60.0;
  }

  String _formatHours(double h) {
    final hours = h.floor();
    final mins = ((h - hours) * 60).round();
    if (hours == 0) return '${mins}m';
    if (mins == 0) return '${hours}h';
    return '${hours}h ${mins}m';
  }

  @override
  Widget build(BuildContext context) {
    final items = _getItems();
    final colors = context.ext.colors;
    final stats = widget.statistics;

    return Column(
      crossAxisAlignment: .start,
      children: [
        // ── Header & Segment Toggle ──
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.trContext(TK.babySleepDuration),
                  style: context.text.titleMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.lightTextPrimary,
                  ),
                ),
                4.h.height,
                Text(
                  _isWeekly
                      ? (widget.weeklyRecords.dailySleep.isEmpty
                          ? ''
                          : '${widget.weeklyRecords.dailySleep.first.date.day} ${_getMonthName(widget.weeklyRecords.dailySleep.first.date.month)} - '
                              '${widget.weeklyRecords.dailySleep.last.date.day} ${_getMonthName(widget.weeklyRecords.dailySleep.last.date.month)}')
                      : widget.monthlyRecords.monthName,
                  style: context.text.bodySmall!.copyWith(
                    color: colors.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            // Segmented Toggle
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: colors.primaryLighter.withValues(alpha: 40),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  SleepToggleTab(
                    label: context.trContext(TK.babySleepWeekly),
                    isActive: _isWeekly,
                    onTap: () {
                      if (!_isWeekly) {
                        setState(() {
                          _isWeekly = true;
                          _selectedIndex = -1;
                          _animationController.reset();
                          _animationController.forward();
                        });
                      }
                    },
                  ),
                  SleepToggleTab(
                    label: context.trContext(TK.babySleepMonthly),
                    isActive: !_isWeekly,
                    onTap: () {
                      if (_isWeekly) {
                        setState(() {
                          _isWeekly = false;
                          _selectedIndex = -1;
                          _animationController.reset();
                          _animationController.forward();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        24.h.height,

        // ── Bar Chart Area ──
        LayoutBuilder(
          builder: (context, constraints) {
            final double chartWidth = constraints.maxWidth - 28;
            final double barSpacing =
                items.isEmpty ? 1 : chartWidth / items.length;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTapUp: (details) {
                    final double localX = details.localPosition.dx - 28;
                    if (localX >= 0 && localX <= chartWidth) {
                      final int index = (localX / barSpacing).floor();
                      if (index >= 0 && index < items.length) {
                        setState(() {
                          _selectedIndex =
                              (_selectedIndex == index) ? -1 : index;
                        });
                      }
                    }
                  },
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      height: 140.h,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: SleepBarChartPainter(
                          items: items,
                          selectedIndex: _selectedIndex,
                          primaryDark: colors.primaryDark,
                          primaryAccent: colors.primaryAccent,
                          gridColor: colors.greyLight,
                          poorColor: colors.severityHigh,
                        ),
                      ),
                    ),
                  ),
                ),

                // Tooltip
                if (_selectedIndex != -1 && _selectedIndex < items.length) ...[
                  (() {
                    final sel = items[_selectedIndex];
                    final double barCenterX =
                        28 + (_selectedIndex * barSpacing) + (barSpacing / 2);
                    final double tooltipWidth = 148.w;
                    double left = barCenterX - (tooltipWidth / 2);
                    if (left < 0) left = 4;
                    if (left + tooltipWidth > constraints.maxWidth) {
                      left = constraints.maxWidth - tooltipWidth - 4;
                    }

                    return Positioned(
                      top: -70.h,
                      left: left,
                      child: Card(
                        elevation: 6,
                        shadowColor: colors.primaryDark.withValues(alpha: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Container(
                          width: tooltipWidth,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: context.theme.cardColor,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: colors.primaryLighter
                                  .withValues(alpha: 100),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: .start,
                            mainAxisSize: .min,
                            children: [
                              Text(
                                softWrap: true,
                                '${sel.date.day} ${_getMonthName(sel.date.month)}',
                                style: context.text.bodySmall!.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colors.lightTextSecondary,
                                ),
                              ),
                              4.h.height,
                              if (sel.sleepHours != null) ...[
                                Row(
                                  mainAxisAlignment:
                                      .spaceBetween,
                                  children: [
                                    Text(
                                      softWrap: true,
                                      _formatHours(sel.sleepHours!),
                                      style:
                                          context.text.titleSmall!.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: colors.primaryDark,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: _statusBgColor(sel.status),
                                        borderRadius:
                                            BorderRadius.circular(6.r),
                                      ),
                                      child: Text(
                                        softWrap: true,
                                        _formatStatusLabel(sel.status),
                                        style:
                                            context.text.bodySmall!.copyWith(
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.w700,
                                          color: _statusColor(sel.status),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ] else ...[
                                Text(
                                  softWrap: true,
                                  context.trContext(TK.babySleepNoData),
                                  style: context.text.bodySmall!.copyWith(
                                    color: colors.lightTextSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }()),
                ],
              ],
            );
          },
        ),
        12.h.height,

        // ── X-Axis Labels ──
        LayoutBuilder(builder: (context, constraints) {
          final items = _getItems();
          return Padding(
            padding: EdgeInsets.only(left: 28.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _isWeekly
                  ? items.map((item) {
                      final weekdayKeys = [
                        TK.commonDayMon,
                        TK.commonDayTue,
                        TK.commonDayWed,
                        TK.commonDayThu,
                        TK.commonDayFri,
                        TK.commonDaySat,
                        TK.commonDaySun,
                      ];
                      final label = context.trContext(weekdayKeys[item.date.weekday - 1]);
                      return Expanded(
                        child: Center(
                          child: Text(
                            label,
                            style: context.text.bodySmall!.copyWith(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.lightTextSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList()
                  : List.generate(5, (index) {
                      final step =
                          items.length > 1 ? ((items.length - 1) / 4).round() : 1;
                      final itemIndex =
                          (step * index).clamp(0, items.length - 1);
                      final item = items[itemIndex];
                      return Text(
                        '${item.date.day} ${_getMonthName(item.date.month)}',
                        style: context.text.bodySmall!.copyWith(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.lightTextSecondary,
                        ),
                      );
                    }),
            ),
          );
        }),
        24.h.height,

        // ── Period Overview Card ──
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: colors.primaryLighter.withValues(alpha: 20),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: colors.primaryLighter.withValues(alpha: 60),
            ),
          ),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                context.trContext(TK.babySleepPeriodOverview),
                style: context.text.titleSmall!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.lightTextPrimary,
                ),
              ),
              12.h.height,
              Row(
                children: [
                  Expanded(
                    child: SleepMetricItem(
                      icon: Icons.bedtime_rounded,
                      label: context.trContext(TK.babySleepAvgSleep),
                      value: _isWeekly
                          ? _formatHours(
                              _parseHours(widget.weeklyRecords.weeklyAverageSleep))
                          : _formatHours(_parseHours(
                              widget.monthlyRecords.monthlyAverageSleep)),
                      color: colors.primaryDark,
                    ),
                  ),
                  Expanded(
                    child: SleepMetricItem(
                      icon: Icons.equalizer_rounded,
                      label: context.trContext(TK.babySleepLoggedDays),
                      value: _isWeekly
                          ? context.trContext(TK.babySleepDaysSuffix, namedArgs: {'count': widget.weeklyRecords.totalRecords.toString()})
                          : context.trContext(TK.babySleepDaysSuffix, namedArgs: {'count': widget.monthlyRecords.totalRecords.toString()}),
                      color: colors.primaryAccent,
                    ),
                  ),
                ],
              ),
              if (!_isWeekly) ...[
                12.h.height,
                Divider(height: 1, color: colors.greyLight),
                12.h.height,
                Row(
                  children: [
                    Expanded(
                      child: SleepMetricItem(
                        icon: Icons.check_circle_outline_rounded,
                        label: context.trContext(TK.babySleepGoodDays),
                        value: context.trContext(TK.babySleepDaysSuffix, namedArgs: {'count': widget.monthlyRecords.goodDays.toString()}),
                        color: colors.severityMinimal,
                      ),
                    ),
                    Expanded(
                      child: SleepMetricItem(
                        icon: Icons.warning_amber_rounded,
                        label: context.trContext(TK.babySleepPoorDays),
                        value: context.trContext(TK.babySleepDaysSuffix, namedArgs: {'count': widget.monthlyRecords.poorDays.toString()}),
                        color: colors.severityHigh,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        16.h.height,

        // ── Pediatrician Reference Card ──
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: _statusBgColor(stats.currentSleepStatus),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: _statusColor(stats.currentSleepStatus).withValues(alpha: 40),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.health_and_safety_rounded,
                        color: _statusColor(stats.currentSleepStatus),
                        size: 20.sp,
                      ),
                      8.w.width,
                      Text(
                        context.trContext(TK.babySleepPediatricianRef),
                        style: context.text.titleSmall!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: _statusColor(stats.currentSleepStatus),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: _statusColor(stats.currentSleepStatus),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      _formatStatusLabel(stats.currentSleepStatus)
                          .toUpperCase(),
                      style: context.text.bodySmall!.copyWith(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              16.h.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SleepStatLabel(
                      label: context.trContext(TK.babySleepRecommendedRange),
                      value:
                          '${stats.comparisonWithReference.recommendedMinHours}-${stats.comparisonWithReference.recommendedMaxHours} h/d',
                    ),
                  ),
                  Expanded(
                    child: SleepStatLabel(
                      label: context.trContext(TK.babySleepOverallAvg),
                      value: stats.averageSleepHoursFormatted,
                    ),
                  ),
                  Expanded(
                    child: SleepStatLabel(
                      label: context.trContext(TK.babySleepLast7Days),
                      value: stats.last7DaysAverageFormatted,
                    ),
                  ),
                ],
              ),
              if (stats.comparisonWithReference.message.isNotEmpty) ...[
                12.h.height,
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: context.theme.cardColor.withValues(alpha: 150),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    stats.comparisonWithReference.message,
                    style: context.text.bodySmall!.copyWith(
                      color: colors.lightTextPrimary,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
