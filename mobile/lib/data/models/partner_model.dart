import 'cycle_day_model.dart';
import 'prediction_model.dart';
import 'user_model.dart';

class PartnerCalendarModel {
  final UserModel user;
  final List<CycleDayModel> cycleDays;
  final PredictionModel? prediction;

  const PartnerCalendarModel({
    required this.user,
    required this.cycleDays,
    this.prediction,
  });

  factory PartnerCalendarModel.fromJson(Map<String, dynamic> json) {
    return PartnerCalendarModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      cycleDays: (json['cycleDays'] as List<dynamic>?)
              ?.map((e) => CycleDayModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      prediction: json['prediction'] != null
          ? PredictionModel.fromJson(json['prediction'] as Map<String, dynamic>)
          : null,
    );
  }
}
