import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/cycle_day_model.dart';
import '../../data/models/prediction_model.dart';
import '../../l10n/app_localizations.dart';
import 'cycle_day_marker.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final List<CycleDayModel> cycleDays;
  final PredictionModel? prediction;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onPageChanged;
  final VoidCallback? onHeaderTapped;

  const CalendarWidget({
    super.key,
    required this.focusedDay,
    this.selectedDay,
    required this.cycleDays,
    this.prediction,
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

  Color _textColor(DateTime date, bool isOutside, bool isSelected) {
    if (isSelected) return Colors.white;
    if (isOutside) return AppTheme.onSurfaceVariant.withValues(alpha: 0.5);
    if (prediction == null) return AppTheme.onSurface;
    if (prediction!.isPeriodDay(date)) return AppTheme.primary;
    if (prediction!.isFertileDay(date)) return AppTheme.fertileCyan;
    return AppTheme.onSurface;
  }

  BoxDecoration? _predictionBorder(DateTime date) {
    if (prediction == null) return null;

    if (prediction!.isPeriodDay(date)) {
      return BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.5),
          width: 1.5,
        ),
      );
    }

    if (prediction!.isOvulationDay(date)) {
      return BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.fertileCyan,
          width: 2,
        ),
      );
    }

    if (prediction!.isFertileDay(date)) {
      return BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.fertileCyan.withValues(alpha: 0.4),
          width: 1.5,
        ),
      );
    }

    return null;
  }

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
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.primary,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        prioritizedBuilder: (context, date, _) {
          final t = AppLocalizations.of(context);
          final isToday = isSameDay(date, DateTime.now());
          final isSelected = isSameDay(date, selectedDay);
          final isOutside = date.month != focusedDay.month;
          final dayData = _dayMap[date];
          final predictionBorder = _predictionBorder(date);

          BoxDecoration bgDecoration;
          if (isSelected) {
            bgDecoration = const BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            );
          } else {
            bgDecoration = predictionBorder ??
                const BoxDecoration(shape: BoxShape.circle);
          }

          final textColor = _textColor(date, isOutside, isSelected);
          final fontWeight = isToday ? FontWeight.bold : FontWeight.normal;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              decoration: bgDecoration,
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
                  if (isToday)
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Text(
                        t.today,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white70
                              : AppTheme.primary,
                        ),
                      ),
                    ),
                  if (dayData != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: CycleDayMarker(dayData: dayData),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      eventLoader: (day) {
        final dayData = _dayMap[day];
        return dayData != null ? [dayData] : [];
      },
    );
  }
}
