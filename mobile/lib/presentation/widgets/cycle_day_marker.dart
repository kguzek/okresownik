import 'package:flutter/material.dart';

import '../../data/models/cycle_day_model.dart';
import '../../core/theme/app_theme.dart';

class CycleDayMarker extends StatelessWidget {
  final CycleDayModel dayData;
  final bool inverted;

  const CycleDayMarker({super.key, required this.dayData, this.inverted = false});

  @override
  Widget build(BuildContext context) {
    final isIntercourse = dayData.isIntercourse;

    if (isIntercourse) {
      return Icon(
        Icons.favorite,
        size: 8,
        color: inverted ? Colors.white : AppTheme.primary,
      );
    }

    return const SizedBox.shrink();
  }
}
