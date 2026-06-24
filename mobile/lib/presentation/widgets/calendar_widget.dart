import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/cycle_day_model.dart';
import '../../data/models/prediction_model.dart';
import '../../l10n/app_localizations.dart';
import 'cycle_day_marker.dart';

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _DashedCirclePainter({required this.color, this.strokeWidth = 1.5});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    const dashWidth = 3.0;
    const dashSpace = 2.5;
    final radius = size.width / 2 - strokeWidth / 2;
    final center = Offset(size.width / 2, size.height / 2);

    final circumference = 2 * math.pi * radius;
    final segments = (circumference / (dashWidth + dashSpace)).floor();

    for (var i = 0; i < segments; i++) {
      final startAngle = i * (dashWidth + dashSpace) / radius - math.pi / 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashWidth / radius,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class CalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final List<CycleDayModel> cycleDays;
  final PredictionModel? prediction;
  final StartingDayOfWeek startingDayOfWeek;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onPageChanged;
  final VoidCallback? onHeaderTapped;

  const CalendarWidget({
    super.key,
    required this.focusedDay,
    this.selectedDay,
    required this.cycleDays,
    this.prediction,
    this.startingDayOfWeek = StartingDayOfWeek.monday,
    required this.onDaySelected,
    required this.onPageChanged,
    this.onHeaderTapped,
  });

  Map<DateTime, CycleDayModel> get _dayMap {
    final map = <DateTime, CycleDayModel>{};
    for (final day in cycleDays) {
      final dt = DateTime.parse(day.date);
      map[DateTime(dt.year, dt.month, dt.day)] = day;
    }
    return map;
  }

  Color _dashedColor(DateTime date) {
    if (prediction == null) return AppTheme.onSurface;
    if (prediction!.isPeriodDay(date)) return AppTheme.primary.withValues(alpha: 0.5);
    if (prediction!.isOvulationDay(date)) return AppTheme.fertileCyan;
    if (prediction!.isFertileDay(date)) return AppTheme.fertileCyan.withValues(alpha: 0.4);
    return AppTheme.onSurface;
  }

  bool get _showPrediction => prediction != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TableCalendar(
      firstDay: DateTime.utc(2025, 1, 1),
      lastDay: DateTime.utc(2028, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onDaySelected: (selected, focused) {
        onDaySelected(selected);
      },
      onPageChanged: onPageChanged,
      onHeaderTapped: (_) => onHeaderTapped?.call(),
      availableGestures: AvailableGestures.horizontalSwipe,
      rowHeight: 58,
      daysOfWeekHeight: 22,
      startingDayOfWeek: startingDayOfWeek,
      simpleSwipeConfig: const SimpleSwipeConfig(
        horizontalThreshold: 12,
        verticalThreshold: 25,
        swipeDetectionBehavior: SwipeDetectionBehavior.continuousDistinct,
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,
        todayDecoration: const BoxDecoration(shape: BoxShape.circle),
        selectedDecoration: const BoxDecoration(shape: BoxShape.circle),
        defaultTextStyle: const TextStyle(color: AppTheme.onSurface),
        weekendTextStyle: const TextStyle(color: AppTheme.onSurfaceVariant),
        outsideTextStyle: TextStyle(
          color: AppTheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: theme.colorScheme.onSurface,
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: theme.colorScheme.primary,
          size: 28,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.primary,
          size: 28,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        prioritizedBuilder: (context, date, _) {
          final t = AppLocalizations.of(context);
          final isToday = isSameDay(date, DateTime.now());
          final isSelected = isSameDay(date, selectedDay);
          final isOutside = date.month != focusedDay.month;
          final dayKey = DateTime(date.year, date.month, date.day);
          final dayData = _dayMap[dayKey];
          final hasPeriodRecord = dayData?.isPeriod == true;
          final hasPrediction = _showPrediction &&
              (prediction!.isPeriodDay(date) || prediction!.isFertileDay(date));

          Color textColor;
          if (isSelected) {
            textColor = hasPeriodRecord ? Colors.white : AppTheme.onSurface;
          } else if (isOutside) {
            textColor = AppTheme.onSurfaceVariant.withValues(alpha: 0.5);
          } else if (hasPeriodRecord) {
            textColor = Colors.white;
          } else if (prediction?.isPeriodDay(date) == true) {
            textColor = AppTheme.primary;
          } else if (prediction?.isFertileDay(date) == true) {
            textColor = AppTheme.fertileCyan;
          } else {
            textColor = AppTheme.onSurface;
          }

          final fontWeight = isToday ? FontWeight.bold : FontWeight.normal;

          return Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 2),
            child: SizedBox(
              width: 44,
              height: 52,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (isToday && !hasPeriodRecord)
                    Positioned(
                      top: 12,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight.withValues(alpha: 0.75),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  if (hasPeriodRecord)
                    Positioned(
                      top: 12,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  if (hasPrediction && !isSelected)
                    Positioned(
                      top: 12,
                      child: CustomPaint(
                        size: const Size(36, 36),
                        painter: _DashedCirclePainter(
                          color: _dashedColor(date),
                          strokeWidth: prediction!.isOvulationDay(date) ? 2.0 : 1.5,
                        ),
                      ),
                    ),
                  if (isSelected && dayData != null)
                    Positioned(
                      top: 10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: hasPeriodRecord
                                ? AppTheme.primaryDark
                                : AppTheme.primary.withValues(alpha: 0.35),
                            width: hasPeriodRecord ? 3 : 2,
                          ),
                        ),
                      ),
                    ),
                  if (isSelected)
                    Positioned(
                      top: hasPeriodRecord ? 10 : 12,
                      child: Container(
                        width: hasPeriodRecord ? 40 : 36,
                        height: hasPeriodRecord ? 40 : 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: hasPeriodRecord ? Colors.white : AppTheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 12,
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: fontWeight,
                              fontSize: 13,
                            ),
                          ),
                          if (dayData != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: CycleDayMarker(
                                dayData: dayData,
                                inverted: hasPeriodRecord,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (isToday)
                    Text(
                      t.today,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
