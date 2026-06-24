import 'package:flutter/material.dart';

import '../../data/models/cycle_day_model.dart';
import '../../core/theme/app_theme.dart';

class CycleDayMarker extends StatelessWidget {
  final CycleDayModel dayData;

  const CycleDayMarker({super.key, required this.dayData});

  @override
  Widget build(BuildContext context) {
    final isPeriod = dayData.isPeriod;
    final isIntercourse = dayData.isIntercourse;

    if (isPeriod && isIntercourse) {
      return _halfHalfDot();
    }

    if (isPeriod) {
      return _dot(AppTheme.primary);
    }

    if (isIntercourse) {
      return _dot(AppTheme.fertileCyan);
    }

    return const SizedBox.shrink();
  }

  Widget _dot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
    );
  }

  Widget _halfHalfDot() {
    return ClipOval(
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Column(
          children: [
            Expanded(child: Container(color: AppTheme.primary)),
            Expanded(child: Container(color: AppTheme.fertileCyan)),
          ],
        ),
      ),
    );
  }
}
