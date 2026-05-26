import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_feeding_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_feeding_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/feeding_statistics_entity.dart';

class ChartItem {
  final DateTime date;
  final int timesPerDay;
  final String primaryFeedingType;
  final String status;

  ChartItem({
    required this.date,
    required this.timesPerDay,
    required this.primaryFeedingType,
    required this.status,
  });
}

class FeedingFrequencyChart extends StatefulWidget {
  final WeeklyFeedingRecordsEntity weeklyRecords;
  final MonthlyFeedingRecordsEntity monthlyRecords;
  final FeedingStatisticsEntity statistics;

  const FeedingFrequencyChart({
    super.key,
    required this.weeklyRecords,
    required this.monthlyRecords,
    required this.statistics,
  });

  @override
  State<FeedingFrequencyChart> createState() => _FeedingFrequencyChartState();
}

class _FeedingFrequencyChartState extends State<FeedingFrequencyChart>
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
      duration: const Duration(milliseconds: 300),
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

  List<ChartItem> _getChartItems() {
    final dailyRecords =
        _isWeekly ? widget.weeklyRecords.dailyRecords : widget.monthlyRecords.dailyRecords;

    return dailyRecords.map((record) {
      int times = 0;
      String type = 'None';
      String status = 'Normal';
      if (record.records.isNotEmpty) {
        times = record.records.fold(0, (sum, r) => sum + r.timesPerDay);
        type = record.records.first.feedingType;
        status = record.records.first.status;
      }
      return ChartItem(
        date: record.date,
        timesPerDay: times,
        primaryFeedingType: type,
        status: status,
      );
    }).toList();
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'severeunder':
        return context.ext.colors.severitySevere;
      case 'under':
        return context.ext.colors.severityModerate;
      case 'normal':
        return context.ext.colors.severityMinimal;
      case 'over':
      default:
        return context.ext.colors.severityHigh;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'severeunder':
        return context.ext.colors.severitySevereBg;
      case 'under':
        return context.ext.colors.severityModerateBg;
      case 'normal':
        return context.ext.colors.severityMinimalBg;
      case 'over':
      default:
        return context.ext.colors.severityHighBg;
    }
  }

  String _formatStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'severeunder':
        return 'Severe Under';
      case 'under':
        return 'Underfeeding';
      case 'normal':
        return 'Normal';
      case 'over':
        return 'Overfeeding';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _getChartItems();
    final colors = context.ext.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header & Segment Selector ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.trContext(TK.babyFeedingFrequency),
                  style: context.text.titleMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.lightTextPrimary,
                  ),
                ),
                4.h.height,
                Text(
                  _isWeekly
                      ? '${widget.weeklyRecords.dailyRecords.isEmpty ? "" : "${widget.weeklyRecords.dailyRecords.first.date.day} ${_getMonthName(widget.weeklyRecords.dailyRecords.first.date.month)}"} - ${widget.weeklyRecords.dailyRecords.isEmpty ? "" : "${widget.weeklyRecords.dailyRecords.last.date.day} ${_getMonthName(widget.weeklyRecords.dailyRecords.last.date.month)}"}'
                      : widget.monthlyRecords.monthName,
                  style: context.text.bodySmall!.copyWith(
                    color: colors.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            // Custom Segmented Switch (Senior Style)
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: colors.primaryLighter.withValues(alpha: 40),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  _buildToggleTab(label: 'Weekly', isActive: _isWeekly, onTap: () {
                    if (!_isWeekly) {
                      setState(() {
                        _isWeekly = true;
                        _selectedIndex = -1;
                        _animationController.reset();
                        _animationController.forward();
                      });
                    }
                  }),
                  _buildToggleTab(label: 'Monthly', isActive: !_isWeekly, onTap: () {
                    if (_isWeekly) {
                      setState(() {
                        _isWeekly = false;
                        _selectedIndex = -1;
                        _animationController.reset();
                        _animationController.forward();
                      });
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
        24.h.height,

        // ── Chart Area with Tooltip Overlay ──
        LayoutBuilder(
          builder: (context, constraints) {
            final double chartWidth = constraints.maxWidth - 25;
            final double barSpacing = chartWidth / items.length;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Chart Painter
                GestureDetector(
                  onTapUp: (details) {
                    final double localX = details.localPosition.dx - 25;
                    if (localX >= 0 && localX <= chartWidth) {
                      final int index = (localX / barSpacing).floor();
                      if (index >= 0 && index < items.length) {
                        setState(() {
                          _selectedIndex = (_selectedIndex == index) ? -1 : index;
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
                        painter: _BarChartPainter(
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

                // Tooltip Positioning
                if (_selectedIndex != -1 && _selectedIndex < items.length) ...[
                  (() {
                    final selectedItem = items[_selectedIndex];
                    final double barCenterX = 25 + (_selectedIndex * barSpacing) + (barSpacing / 2);
                    final double tooltipWidth = 145.w;
                    double left = barCenterX - (tooltipWidth / 2);
                    if (left < 0) left = 4;
                    if (left + tooltipWidth > constraints.maxWidth) {
                      left = constraints.maxWidth - tooltipWidth - 4;
                    }

                    return Positioned(
                      top: -65.h,
                      left: left,
                      child: Card(
                        elevation: 6,
                        shadowColor: Colors.black.withValues(alpha: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Container(
                          width: tooltipWidth,
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: context.theme.cardColor,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: colors.primaryLighter.withValues(alpha: 100),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${selectedItem.date.day} ${_getMonthName(selectedItem.date.month)}',
                                style: context.text.bodySmall!.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colors.lightTextSecondary,
                                ),
                              ),
                              4.h.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${selectedItem.timesPerDay} times',
                                    style: context.text.titleSmall!.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: colors.primaryDark,
                                    ),
                                  ),
                                  if (selectedItem.timesPerDay > 0)
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: _getStatusBgColor(selectedItem.status),
                                        borderRadius: BorderRadius.circular(6.r),
                                      ),
                                      child: Text(
                                        _formatStatusLabel(selectedItem.status),
                                        style: context.text.bodySmall!.copyWith(
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.w700,
                                          color: _getStatusColor(selectedItem.status),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (selectedItem.timesPerDay > 0) ...[
                                4.h.height,
                                Text(
                                  'Type: ${selectedItem.primaryFeedingType}',
                                  style: context.text.bodySmall!.copyWith(
                                    fontSize: 10.sp,
                                    color: colors.lightTextPrimary,
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
        Padding(
          padding: EdgeInsets.only(left: 25.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _isWeekly
                ? items.map((item) {
                    final List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                    final label = weekdays[item.date.weekday - 1];
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
                    final step = ((items.length - 1) / 4).round();
                    final itemIndex = (step * index).clamp(0, items.length - 1);
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
        ),
        24.h.height,

        // ── Period summary stats (Slick UI Cards) ──
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: colors.primaryLighter.withValues(alpha: 20),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: colors.primaryLighter.withValues(alpha: 60),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Period Overview',
                style: context.text.titleSmall!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.lightTextPrimary,
                ),
              ),
              12.h.height,
              Row(
                children: [
                  Expanded(
                    child: _buildMetricItem(
                      icon: Icons.date_range_rounded,
                      label: 'Average Frequency',
                      value: _isWeekly
                          ? '${widget.weeklyRecords.weeklyAverage.toStringAsFixed(1)} /day'
                          : '${widget.monthlyRecords.monthlyAverageTimesPerDay.toStringAsFixed(1)} /day',
                      color: colors.primaryDark,
                    ),
                  ),
                  Expanded(
                    child: _buildMetricItem(
                      icon: Icons.equalizer_rounded,
                      label: _isWeekly ? 'Logged Feedings' : 'Logged Days',
                      value: _isWeekly
                          ? '${items.where((i) => i.timesPerDay > 0).length} days'
                          : '${widget.monthlyRecords.totalRecords} days',
                      color: colors.primaryAccent,
                    ),
                  ),
                ],
              ),
              if (!_isWeekly) ...[
                12.h.height,
                const Divider(height: 1, color: Colors.grey),
                12.h.height,
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricItem(
                        icon: Icons.check_circle_outline_rounded,
                        label: 'Normal Days',
                        value: '${widget.monthlyRecords.normalDays} days',
                        color: colors.greenText,
                      ),
                    ),
                    Expanded(
                      child: _buildMetricItem(
                        icon: Icons.warning_amber_rounded,
                        label: 'Abnormal Days',
                        value: '${widget.monthlyRecords.abnormalDays} days',
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

        // ── Pediatrician / Reference Insights Card ──
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: _getStatusBgColor(widget.statistics.currentFeedingStatus),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: _getStatusColor(widget.statistics.currentFeedingStatus).withValues(alpha: 40),
              width: 1,
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
                        color: _getStatusColor(widget.statistics.currentFeedingStatus),
                        size: 20.sp,
                      ),
                      8.width,
                      Text(
                        'Pediatrician Reference',
                        style: context.text.titleSmall!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: _getStatusColor(widget.statistics.currentFeedingStatus),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: _getStatusColor(widget.statistics.currentFeedingStatus),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      _formatStatusLabel(widget.statistics.currentFeedingStatus).toUpperCase(),
                      style: context.text.bodySmall!.copyWith(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              12.h.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatLabel(
                    label: 'Recommended Range',
                    value:
                        '${widget.statistics.comparisonWithReference.recommendedMin} - ${widget.statistics.comparisonWithReference.recommendedMax} times/day',
                  ),
                  _buildStatLabel(
                    label: 'Overall Average',
                    value: '${widget.statistics.averageTimesPerDay.toStringAsFixed(1)} times/day',
                  ),
                ],
              ),
              12.h.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatLabel(
                    label: 'Most Common Feeding',
                    value: widget.statistics.mostCommonFeedingType,
                  ),
                  _buildStatLabel(
                    label: 'Last 7 Days Avg',
                    value: '${widget.statistics.last7DaysAverage.toStringAsFixed(1)} times/day',
                  ),
                ],
              ),
              if (widget.statistics.comparisonWithReference.message.isNotEmpty) ...[
                12.h.height,
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: context.theme.cardColor.withValues(alpha: 150),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.statistics.comparisonWithReference.message,
                          style: context.text.bodySmall!.copyWith(
                            color: colors.lightTextPrimary,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleTab({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final colors = context.ext.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isActive ? context.theme.cardColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 8),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: context.text.bodySmall!.copyWith(
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? colors.primaryDark : colors.lightTextSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16.r,
          backgroundColor: color.withValues(alpha: 20),
          child: Icon(icon, size: 16.sp, color: color),
        ),
        10.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.text.bodySmall!.copyWith(
                  fontSize: 10.sp,
                  color: context.ext.colors.lightTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              2.h.height,
              Text(
                value,
                style: context.text.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.ext.colors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatLabel({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.text.bodySmall!.copyWith(
            fontSize: 9.sp,
            color: context.ext.colors.lightTextSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        4.h.height,
        Text(
          value,
          style: context.text.bodyMedium!.copyWith(
            fontWeight: FontWeight.w700,
            color: context.ext.colors.lightTextPrimary,
          ),
        ),
      ],
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<ChartItem> items;
  final int selectedIndex;
  final Color primaryDark;
  final Color primaryAccent;
  final Color gridColor;

  _BarChartPainter({
    required this.items,
    required this.selectedIndex,
    required this.primaryDark,
    required this.primaryAccent,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;

    final maxVal = items.fold<int>(0, (max, item) => item.timesPerDay > max ? item.timesPerDay : max);
    final double scaleMax = maxVal < 8 ? 8.0 : maxVal.toDouble();

    // Draw background horizontal lines
    final paintGrid = Paint()
      ..color = gridColor.withValues(alpha: 100)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final double chartHeight = size.height - 20; // reserve space for bottom labels
    final double step = scaleMax / 4;
    for (int i = 0; i <= 4; i++) {
      final double val = step * i;
      final double y = chartHeight - (val / scaleMax) * chartHeight;
      // Draw grid line
      canvas.drawLine(Offset(25, y), Offset(size.width, y), paintGrid);

      // Draw grid label
      textPainter.text = TextSpan(
        text: val.toInt().toString(),
        style: TextStyle(
          color: gridColor.withValues(alpha: 180),
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - 6));
    }

    final double chartWidth = size.width - 25;
    final int count = items.length;
    final double barSpacing = chartWidth / count;
    final double barWidth = count > 10 ? (barSpacing * 0.6) : (barSpacing * 0.4);

    for (int i = 0; i < count; i++) {
      final item = items[i];
      final double barHeight = (item.timesPerDay / scaleMax) * chartHeight;
      final double x = 25 + (i * barSpacing) + (barSpacing - barWidth) / 2;
      final double y = chartHeight - barHeight;

      if (barHeight > 0) {
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barHeight),
          const Radius.circular(4),
        );

        final isSelected = i == selectedIndex;
        final paint = Paint()
          ..shader = LinearGradient(
            colors: isSelected
                ? [primaryDark, primaryDark.withValues(alpha: 150)]
                : [primaryAccent.withValues(alpha: 160), primaryAccent.withValues(alpha: 80)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ).createShader(Rect.fromLTWH(x, y, barWidth, barHeight))
          ..style = PaintingStyle.fill;

        canvas.drawRRect(rect, paint);

        // Highlight selected bar outline
        if (isSelected) {
          final strokePaint = Paint()
            ..color = primaryDark
            ..strokeWidth = 1.5
            ..style = PaintingStyle.stroke;
          canvas.drawRRect(rect, strokePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter old) =>
      old.items != items || old.selectedIndex != selectedIndex;
}
