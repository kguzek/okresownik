import 'package:flutter/material.dart';

import '../../data/models/prediction_model.dart';

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
    return const SizedBox.shrink();
  }
}
