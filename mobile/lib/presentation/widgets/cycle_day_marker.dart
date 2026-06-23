import 'package:flutter/material.dart';

import '../../data/models/cycle_day_model.dart';
import '../../core/theme/app_theme.dart';

class CycleDayMarker extends StatelessWidget {
  final CycleDayModel dayData;

  const CycleDayMarker({super.key, required this.dayData});

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];

    if (dayData.isPeriod) {
      final size = dayData.isIntercourse ? 6.0 : 8.0;
      widgets.add(
        Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: AppTheme.periodRed,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    if (dayData.isIntercourse) {
      widgets.add(
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: AppTheme.intercourseAmber,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    if (widgets.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widgets.length > 1) const SizedBox(width: 2),
        ...widgets,
      ],
    );
  }
}
