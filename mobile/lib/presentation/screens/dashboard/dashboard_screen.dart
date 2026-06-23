import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/cycle_day_model.dart';
import '../../../logic/auth/auth_cubit.dart';
import '../../../logic/cycle/cycle_cubit.dart';
import '../../../logic/cycle/cycle_state.dart';
import '../../../logic/partner/partner_cubit.dart';
import '../../../logic/partner/partner_state.dart';
import '../../widgets/calendar_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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

  void _showDayDetails(CycleDayModel? dayData) {
    if (_selectedDay == null) return;

    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDay!);

    showModalBottomSheet(
      context: context,
      builder: (context) => _DayDetailsSheet(
        date: _selectedDay!,
        dayData: dayData,
        onMarkPeriod: () {
          context.read<CycleCubit>().markPeriodDay(date: dateStr);
          Navigator.pop(context);
        },
        onMarkIntercourse: () {
          context.read<CycleCubit>().markIntercourseDay(date: dateStr);
          Navigator.pop(context);
        },
        onClearDay: () {
          context.read<CycleCubit>().clearDay(dateStr);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Okresownik'),
        actions: [
          const _PartnerStatusIcon(),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'share':
                  context.go('/partner/share');
                case 'view':
                  context.go('/partner/view');
                case 'logout':
                  context.read<AuthCubit>().logout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'share', child: Text('Share with Partner')),
              const PopupMenuItem(value: 'view', child: Text("View Partner's Calendar")),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<CycleCubit, CycleState>(
            builder: (context, state) {
              return CalendarWidget(
                focusedDay: _focusedDay,
                selectedDay: _selectedDay,
                cycleDays: state.days,
                prediction: state.prediction,
                onDaySelected: _onDaySelected,
                onPageChanged: (day) => setState(() => _focusedDay = day),
              );
            },
          ),
          const SizedBox(height: 8),
          _PredictionSummaryCard(),
          const SizedBox(height: 8),
          _LegendRow(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => _showDayDetails(
                  context.read<CycleCubit>().state.dayForDate(_selectedDay ?? DateTime.now()),
                ),
                icon: const Icon(Icons.edit),
                label: Text(
                  _selectedDay != null
                      ? 'Log ${DateFormat('MMM d').format(_selectedDay!)}'
                      : 'Log Today',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PredictionSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CycleCubit, CycleState>(
      builder: (context, state) {
        final prediction = state.prediction;
        if (prediction == null) return const SizedBox.shrink();

        final nextPeriod = DateFormat('MMM d').format(prediction.nextPeriodStart);
        final cycleDay = prediction.cycleDay;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cycle Day $cycleDay',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        'Next period expected ~$nextPeriod',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LegendDot(color: AppTheme.periodRed, label: 'Period'),
          const SizedBox(width: 16),
          _LegendDot(color: AppTheme.fertileGreen, label: 'Fertile'),
          const SizedBox(width: 16),
          _LegendDot(color: AppTheme.intercourseAmber, label: 'Intimacy'),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _PartnerStatusIcon extends StatelessWidget {
  const _PartnerStatusIcon();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartnerCubit, PartnerState>(
      builder: (context, state) {
        final isLinked = state.partnerView != null;
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(
            isLinked ? Icons.people : Icons.person,
            color: isLinked ? AppTheme.fertileGreen : Colors.grey,
          ),
        );
      },
    );
  }
}

class _DayDetailsSheet extends StatelessWidget {
  final DateTime date;
  final CycleDayModel? dayData;
  final VoidCallback onMarkPeriod;
  final VoidCallback onMarkIntercourse;
  final VoidCallback onClearDay;

  const _DayDetailsSheet({
    required this.date,
    this.dayData,
    required this.onMarkPeriod,
    required this.onMarkIntercourse,
    required this.onClearDay,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('EEEE, MMMM d, yyyy').format(date);
    final isToday = isSameDay(date, DateTime.now());

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            dateStr,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          if (isToday)
            Text(
              'Today',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          const SizedBox(height: 24),
          if (dayData != null) ...[
            if (dayData!.isPeriod)
              _InfoChip(
                icon: Icons.water_drop,
                label: 'Period',
                color: AppTheme.periodRed,
                detail: dayData!.flow.isNotEmpty ? 'Flow: ${dayData!.flow}' : null,
              ),
            if (dayData!.isIntercourse)
              const _InfoChip(
                icon: Icons.favorite,
                label: 'Intercourse logged',
                color: AppTheme.intercourseAmber,
              ),
            if (dayData!.notes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  dayData!.notes,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onClearDay,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Clear day data'),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onMarkPeriod,
                    icon: const Icon(Icons.water_drop),
                    label: const Text('Period'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightPink,
                      foregroundColor: AppTheme.periodRed,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onMarkIntercourse,
                    icon: const Icon(Icons.favorite),
                    label: const Text('Intimacy'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.fertileLight,
                      foregroundColor: AppTheme.intercourseAmber,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
        ],
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
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(label),
          if (detail != null) ...[
            const SizedBox(width: 8),
            Text(
              detail!,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
