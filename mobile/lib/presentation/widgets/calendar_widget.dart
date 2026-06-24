import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../data/models/cycle_day_model.dart';
import '../../data/models/prediction_model.dart';
import 'cycle_day_marker.dart';
import 'prediction_indicators.dart';

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
        todayDecoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
        defaultTextStyle: TextStyle(color: theme.colorScheme.onSurface),
        weekendTextStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        outsideTextStyle: TextStyle(
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
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
        markerBuilder: (context, date, events) {
          final dayData = _dayMap[date];
          if (dayData == null && prediction == null) return null;

          final markers = <Widget>[];

          if (dayData != null) {
            markers.add(CycleDayMarker(dayData: dayData));
          }

          if (prediction != null) {
            markers.add(PredictionIndicator(
              prediction: prediction!,
              date: date,
            ));
          }

          if (markers.isEmpty) return null;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: markers,
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
