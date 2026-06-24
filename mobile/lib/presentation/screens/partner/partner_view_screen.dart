import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/polish_name_declension.dart';
import '../../../data/models/partner_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../logic/partner/partner_cubit.dart';
import '../../../logic/partner/partner_state.dart';
import '../../widgets/calendar_widget.dart';

class PartnerViewScreen extends StatefulWidget {
  const PartnerViewScreen({super.key});

  @override
  State<PartnerViewScreen> createState() => _PartnerViewScreenState();
}

class _PartnerViewScreenState extends State<PartnerViewScreen> {
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<PartnerCubit>().loadPartnerView();
  }

  String _titleForView(PartnerCalendarModel? view) {
    final t = AppLocalizations.of(context);
    if (view == null) return t.partnersCalendar;
    final name = PolishNameDeclension.possessive(view.user.name);
    return t.partnersCalendarText(name);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return BlocBuilder<PartnerCubit, PartnerState>(
      builder: (context, state) {
        final view = state.partnerView;

        return Scaffold(
          appBar: AppBar(
            title: Text(_titleForView(view)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: _buildBody(context, state, view, t),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PartnerState state, PartnerCalendarModel? view, AppLocalizations t) {
    if (state.status == PartnerStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.link_off, size: 32, color: AppTheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              Text(
                t.notLinkedYet,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                t.notLinkedSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    if (view == null) {
      return Center(child: Text(t.noDataAvailable));
    }

    return Column(
      children: [
        _PartnerHeader(partner: view),
        Expanded(
          child: CalendarWidget(
            focusedDay: _focusedDay,
            cycleDays: view.cycleDays,
            prediction: view.prediction,
            onDaySelected: (_) {},
            onPageChanged: (day) => setState(() => _focusedDay = day),
            onHeaderTapped: () {
              setState(() => _focusedDay = DateTime.now());
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            t.readOnlyView,
            style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _PartnerHeader extends StatelessWidget {
  final PartnerCalendarModel partner;

  const _PartnerHeader({required this.partner});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final prediction = partner.prediction;

    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.primaryLight,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.primary,
            child: Text(
              partner.user.name.isNotEmpty
                  ? partner.user.name[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partner.user.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                ),
                if (prediction != null)
                  Text(
                    t.partnerNextPeriodText(
                      DateFormat('MMM d').format(prediction.nextPeriodStart),
                    ),
                    style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 13),
                  ),
              ],
            ),
          ),
          if (prediction != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _confidenceColor(prediction.confidence),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                t.cycleDayText(prediction.cycleDay).split(' ').last,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _confidenceColor(String confidence) {
    switch (confidence) {
      case 'high':
        return AppTheme.fertileGreen;
      case 'medium':
        return AppTheme.intercourseAmber;
      default:
        return AppTheme.onSurfaceVariant;
    }
  }
}
