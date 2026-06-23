import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/partner_model.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Partner's Calendar")),
      body: BlocBuilder<PartnerCubit, PartnerState>(
        builder: (context, state) {
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
                    const Icon(Icons.link_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Not linked to a partner yet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Go to Share with Partner and enter their code',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            );
          }

          final view = state.partnerView;
          if (view == null) {
            return const Center(child: Text('No partner data available'));
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Read-only view of your partner\'s cycle',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PartnerHeader extends StatelessWidget {
  final PartnerCalendarModel partner;

  const _PartnerHeader({required this.partner});

  @override
  Widget build(BuildContext context) {
    final prediction = partner.prediction;

    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.lightPink,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
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
                      ),
                ),
                if (prediction != null)
                  Text(
                    'Next period ~${DateFormat('MMM d').format(prediction.nextPeriodStart)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
              ],
            ),
          ),
          if (prediction != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _confidenceColor(prediction.confidence),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                prediction.cycleDay.toString(),
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
        return Colors.grey;
    }
  }
}
