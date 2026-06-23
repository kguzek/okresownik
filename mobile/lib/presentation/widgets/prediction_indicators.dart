import 'package:flutter/material.dart';

import '../../data/models/prediction_model.dart';
import '../../core/theme/app_theme.dart';

class PredictionIndicator extends StatelessWidget {
  final PredictionModel prediction;
  final DateTime date;

  const PredictionIndicator({
    super.key,
    required this.prediction,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    if (prediction.isPeriodDay(date)) {
      return Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: AppTheme.predictionBlue.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
      );
    }

    if (prediction.isOvulationDay(date)) {
      return Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: AppTheme.fertileGreen,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.fertileGreen,
            width: 2,
          ),
        ),
      );
    }

    if (prediction.isFertileDay(date)) {
      return Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: AppTheme.fertileLight,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.fertileGreen,
            width: 1,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
