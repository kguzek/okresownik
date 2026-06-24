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
import '../../../logic/partner/partner_state.dart';
import '../../widgets/calendar_widget.dart';

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
        onMarkIntercourse: () {
          context.read<CycleCubit>().markIntercourseDay(date: dateStr);
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

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isToday = isSameDay(_selectedDay, DateTime.now());

    return BlocListener<CycleCubit, CycleState>(
      listenWhen: (prev, curr) =>
          curr.status == CycleStatus.error && curr.error != null,
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: AppTheme.periodRed,
            ),
          );
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
            const _PartnerStatusIcon(),
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
            const SizedBox(height: 8),
            _PredictionSummaryCard(),
            const SizedBox(height: 8),
            _LegendRow(),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _showDayDetails(
                    context
                        .read<CycleCubit>()
                        .state
                        .dayForDate(_selectedDay),
                    _selectedDay,
                  ),
                  icon: Icon(isToday ? Icons.edit_calendar : Icons.edit),
                  label: Text(
                    isToday ? t.logToday : t.logDate(DateFormat('MMM d').format(_selectedDay)),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LegendDot(color: AppTheme.periodRed, label: t.periodLabel),
          const SizedBox(width: 20),
          _LegendDot(color: AppTheme.fertileGreen, label: t.fertileLabel),
          const SizedBox(width: 20),
          _LegendDot(color: AppTheme.intercourseAmber, label: t.intimacyLabel),
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
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
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
            isLinked ? Icons.people : Icons.person_outline,
            color: isLinked ? AppTheme.primary : AppTheme.onSurfaceVariant,
            size: 22,
          ),
        );
      },
    );
  }
}

class _DayDetailsSheet extends StatefulWidget {
  final DateTime date;
  final CycleDayModel? dayData;
  final ValueChanged<String> onMarkPeriod;
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
  State<_DayDetailsSheet> createState() => _DayDetailsSheetState();
}

class _DayDetailsSheetState extends State<_DayDetailsSheet> {
  String _selectedFlow = 'light';

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final dateStr = DateFormat('EEEE, MMMM d, yyyy').format(widget.date);
    final isToday = isSameDay(widget.date, DateTime.now());

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
          if (widget.dayData != null) ...[
            if (widget.dayData!.isPeriod)
              _InfoChip(
                icon: Icons.water_drop,
                label: t.periodLabel,
                color: AppTheme.periodRed,
                detail: widget.dayData!.flow.isNotEmpty
                    ? t.flowText(widget.dayData!.flow)
                    : null,
              ),
            if (widget.dayData!.isIntercourse)
              _InfoChip(
                icon: Icons.favorite,
                label: t.intimacyLabel,
                color: AppTheme.intercourseAmber,
              ),
            if (widget.dayData!.notes.isNotEmpty)
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
            OutlinedButton.icon(
              onPressed: widget.onClearDay,
              icon: const Icon(Icons.delete_outline, size: 20),
              label: Text(t.clearDayData),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.periodRed,
                side: const BorderSide(color: AppTheme.periodRed),
              ),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showFlowSelector(context);
                    },
                    icon: const Icon(Icons.water_drop, size: 20),
                    label: Text(
                      t.periodLabel,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.periodRed.withValues(alpha: 0.1),
                      foregroundColor: AppTheme.periodRed,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: widget.onMarkIntercourse,
                    icon: const Icon(Icons.favorite, size: 20),
                    label: Text(
                      t.intimacyLabel,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.intercourseAmber.withValues(alpha: 0.1),
                      foregroundColor: AppTheme.intercourseAmber,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showFlowSelector(BuildContext context) {
    final t = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
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
