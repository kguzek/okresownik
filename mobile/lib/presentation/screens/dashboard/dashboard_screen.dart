import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/cycle_day_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../logic/auth/auth_cubit.dart';
import '../../../logic/cycle/cycle_cubit.dart';
import '../../../logic/cycle/cycle_state.dart';
import '../../../logic/partner/partner_cubit.dart';
import '../../../logic/settings/calendar_settings_cubit.dart';
import '../../widgets/calendar_widget.dart';
import '../../widgets/error_toast.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month - 2, 1);
    final lastDay = DateTime(now.year, now.month + 3, 0);

    context.read<CycleCubit>().loadDays(
          from: DateFormat('yyyy-MM-dd').format(firstDay),
          to: DateFormat('yyyy-MM-dd').format(lastDay),
        );
    context.read<CycleCubit>().loadPrediction();
    context.read<PartnerCubit>().loadPartnerCode();
    context.read<PartnerCubit>().loadPartnerView();
  }

  void _onDaySelected(DateTime day) {
    setState(() => _selectedDay = day);
    context.read<CycleCubit>().selectDay(day);
  }

  void _showDayDetails(CycleDayModel? dayData, DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _DayDetailsSheet(
        date: date,
        dayData: dayData,
        onMarkPeriod: (String flow) {
          context.read<CycleCubit>().markPeriodDay(date: dateStr, flow: flow);
          Navigator.pop(sheetContext);
        },
        onToggleIntercourse: () {
          final existing = context.read<CycleCubit>().state.dayForDate(date);
          if (existing?.isIntercourse == true) {
            context.read<CycleCubit>().markIntercourseDay(
                  date: dateStr,
                  isIntercourse: false,
                );
          } else {
            context.read<CycleCubit>().markIntercourseDay(date: dateStr);
          }
          Navigator.pop(sheetContext);
        },
        onClearDay: () {
          context.read<CycleCubit>().clearDay(dateStr);
          Navigator.pop(sheetContext);
        },
      ),
    );
  }

  void _navigateTo(String location) {
    if (location == '/settings' ||
        location == '/partner/share' ||
        location == '/partner/view') {
      context.push(location);
    } else {
      context.go(location);
    }
  }

  StartingDayOfWeek _startingDayOfWeek(int weekday) {
    switch (weekday) {
      case DateTime.tuesday:
        return StartingDayOfWeek.tuesday;
      case DateTime.wednesday:
        return StartingDayOfWeek.wednesday;
      case DateTime.thursday:
        return StartingDayOfWeek.thursday;
      case DateTime.friday:
        return StartingDayOfWeek.friday;
      case DateTime.saturday:
        return StartingDayOfWeek.saturday;
      case DateTime.sunday:
        return StartingDayOfWeek.sunday;
      default:
        return StartingDayOfWeek.monday;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isToday = isSameDay(_selectedDay, DateTime.now());
    final firstWeekday = context.watch<CalendarSettingsCubit>().state;

    return BlocListener<CycleCubit, CycleState>(
      listenWhen: (prev, curr) =>
          curr.status == CycleStatus.error && curr.error != null,
      listener: (context, state) {
        if (state.error != null) {
          showErrorToast(context, state.error!);
          context.read<CycleCubit>().clearError();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            t.appTitle,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'settings':
                    _navigateTo('/settings');
                  case 'share':
                    _navigateTo('/partner/share');
                  case 'view':
                    _navigateTo('/partner/view');
                  case 'logout':
                    context.read<AuthCubit>().logout();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'settings', child: Text(t.settings)),
                PopupMenuItem(value: 'share', child: Text(t.shareWithPartner)),
                PopupMenuItem(value: 'view', child: Text(t.viewPartnerCalendar)),
                const PopupMenuDivider(),
                PopupMenuItem(value: 'logout', child: Text(t.logout)),
              ],
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<CycleCubit, CycleState>(
                  builder: (context, state) {
                    return CalendarWidget(
                      focusedDay: _focusedDay,
                      selectedDay: _selectedDay,
                      cycleDays: state.days,
                      prediction: state.prediction,
                      startingDayOfWeek: _startingDayOfWeek(firstWeekday),
                      onDaySelected: _onDaySelected,
                      onPageChanged: (day) => setState(() => _focusedDay = day),
                      onHeaderTapped: () {
                        setState(() {
                          _focusedDay = DateTime.now();
                          _selectedDay = DateTime.now();
                        });
                        context.read<CycleCubit>().selectDay(DateTime.now());
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 4),
              _LegendRow(),
              const SizedBox(height: 8),
              _PredictionSummaryCard(),
              const SizedBox(height: 12),
              BlocBuilder<CycleCubit, CycleState>(
                builder: (context, state) {
                  final dayData = state.dayForDate(_selectedDay);
                  final hasRecord = dayData != null;
                  final formattedDate = DateFormat('MMM d').format(_selectedDay);
                  final buttonText = hasRecord
                      ? isToday
                          ? t.editRecordToday
                          : t.editRecordDate(formattedDate)
                      : isToday
                          ? t.logToday
                          : t.logDate(formattedDate);

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => _showDayDetails(dayData, _selectedDay),
                        icon: Icon(isToday ? Icons.edit_calendar : Icons.edit),
                        label: Text(
                          buttonText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PredictionSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return BlocBuilder<CycleCubit, CycleState>(
      builder: (context, state) {
        final prediction = state.prediction;
        if (prediction == null) return const SizedBox.shrink();

        final nextPeriod = DateFormat('MMM d').format(prediction.nextPeriodStart);
        final cycleDay = prediction.cycleDay;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.trending_up,
                    color: AppTheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.cycleDayText(cycleDay),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        t.nextPeriodExpectedText(nextPeriod),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.onSurfaceVariant,
                              fontSize: 13,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LegendRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 6,
        spacing: 14,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
              const SizedBox(width: 3),
              CustomPaint(
                size: const Size(10, 10),
                painter: _DashedCirclePainter(
                  color: AppTheme.primary.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                t.periodLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          _LegendDot(
            color: AppTheme.fertileCyan,
            label: t.fertileLabel,
            isDashed: true,
          ),
          _LegendDot(
            color: AppTheme.primary,
            label: t.intimacyLabel,
            icon: Icons.favorite,
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDashed;
  final IconData? icon;

  const _LegendDot({
    required this.color,
    required this.label,
    this.isDashed = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null)
          Icon(icon, size: 12, color: color)
        else if (isDashed)
          CustomPaint(
            size: const Size(10, 10),
            painter: _DashedCirclePainter(color: color),
          )
        else
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1),
            ),
          ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;

  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const dashWidth = 3.0;
    const dashSpace = 2.0;
    final radius = size.width / 2 - 1;
    final center = Offset(size.width / 2, size.height / 2);

    final totalLength = 2 * 3.14159 * radius;
    final segments = (totalLength / (dashWidth + dashSpace)).floor();

    for (var i = 0; i < segments; i++) {
      final startAngle = i * (dashWidth + dashSpace) / radius;
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
      oldDelegate.color != color;
}

class _DayDetailsSheet extends StatefulWidget {
  final DateTime date;
  final CycleDayModel? dayData;
  final ValueChanged<String> onMarkPeriod;
  final VoidCallback onToggleIntercourse;
  final VoidCallback onClearDay;

  const _DayDetailsSheet({
    required this.date,
    this.dayData,
    required this.onMarkPeriod,
    required this.onToggleIntercourse,
    required this.onClearDay,
  });

  @override
  State<_DayDetailsSheet> createState() => _DayDetailsSheetState();
}

class _DayDetailsSheetState extends State<_DayDetailsSheet> {
  late String _selectedFlow;

  @override
  void initState() {
    super.initState();
    _selectedFlow = widget.dayData?.flow.isNotEmpty == true
        ? widget.dayData!.flow
        : 'light';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final dateStr = DateFormat('EEEE, MMMM d, yyyy').format(widget.date);
    final isToday = isSameDay(widget.date, DateTime.now());
    final hasData = widget.dayData != null;
    final hasPeriod = hasData && widget.dayData!.isPeriod;
    final hasIntercourse = hasData && widget.dayData!.isIntercourse;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            dateStr,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
          ),
          if (isToday)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                t.today,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          const SizedBox(height: 24),
          if (hasPeriod)
            _InfoChip(
              icon: Icons.water_drop,
              label: t.periodLabel,
              color: AppTheme.periodRed,
              detail: widget.dayData!.flow.isNotEmpty
                  ? t.flowText(widget.dayData!.flow)
                  : null,
            ),
          if (hasIntercourse)
            _InfoChip(
              icon: Icons.favorite,
              label: t.intimacyLabel,
              color: AppTheme.fertileCyan,
            ),
          if (hasData && widget.dayData!.notes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                widget.dayData!.notes,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.onSurfaceVariant,
                    ),
              ),
            ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showFlowSelector(context);
                  },
                  icon: Icon(
                    Icons.water_drop,
                    size: 20,
                    color: hasPeriod ? AppTheme.periodRed : null,
                  ),
                  label: Text(
                    t.periodLabel,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasPeriod
                        ? AppTheme.periodRed.withValues(alpha: 0.1)
                        : AppTheme.surfaceContainerLow,
                    foregroundColor: AppTheme.periodRed,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: widget.onToggleIntercourse,
                  icon: Icon(
                    Icons.favorite,
                    size: 20,
                    color: hasIntercourse ? AppTheme.fertileCyan : null,
                  ),
                  label: Text(
                    t.intimacyLabel,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasIntercourse
                        ? AppTheme.fertileCyan.withValues(alpha: 0.1)
                        : AppTheme.surfaceContainerLow,
                    foregroundColor: AppTheme.fertileCyan,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: hasData ? widget.onClearDay : null,
            icon: const Icon(Icons.delete_outline, size: 20),
            label: Text(t.clearDayData),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return AppTheme.onSurfaceVariant.withValues(alpha: 0.4);
                }
                return AppTheme.periodRed;
              }),
              side: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return BorderSide(
                    color: AppTheme.onSurfaceVariant.withValues(alpha: 0.15),
                  );
                }
                return const BorderSide(color: AppTheme.periodRed);
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _showFlowSelector(BuildContext context) {
    final t = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              t.periodLabel,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
            ),
            const SizedBox(height: 20),
            _FlowChip(
              label: t.flowSpotting,
              isSelected: _selectedFlow == 'spotting',
              onTap: () {
                setState(() => _selectedFlow = 'spotting');
                Navigator.pop(ctx);
                widget.onMarkPeriod('spotting');
              },
            ),
            const SizedBox(height: 8),
            _FlowChip(
              label: t.flowLight,
              isSelected: _selectedFlow == 'light',
              onTap: () {
                setState(() => _selectedFlow = 'light');
                Navigator.pop(ctx);
                widget.onMarkPeriod('light');
              },
            ),
            const SizedBox(height: 8),
            _FlowChip(
              label: t.flowMedium,
              isSelected: _selectedFlow == 'medium',
              onTap: () {
                setState(() => _selectedFlow = 'medium');
                Navigator.pop(ctx);
                widget.onMarkPeriod('medium');
              },
            ),
            const SizedBox(height: 8),
            _FlowChip(
              label: t.flowHeavy,
              isSelected: _selectedFlow == 'heavy',
              onTap: () {
                setState(() => _selectedFlow = 'heavy');
                Navigator.pop(ctx);
                widget.onMarkPeriod('heavy');
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _FlowChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FlowChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? AppTheme.periodRed.withValues(alpha: 0.1)
          : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppTheme.periodRed : AppTheme.divider,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.water_drop,
                color: isSelected ? AppTheme.periodRed : AppTheme.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppTheme.periodRed : AppTheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String? detail;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
    this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.onSurface,
                ),
          ),
          if (detail != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                detail!,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
