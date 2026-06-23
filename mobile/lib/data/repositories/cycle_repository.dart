import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../models/cycle_day_model.dart';
import '../models/prediction_model.dart';

class CycleRepository {
  final ApiClient _api;

  CycleRepository(this._api);

  Future<List<CycleDayModel>> getDays({
    String? from,
    String? to,
  }) async {
    final params = <String, String>{};
    if (from != null) params['from'] = from;
    if (to != null) params['to'] = to;

    final data = await _api.getList(
      ApiEndpoints.cycleDays,
      queryParams: params.isNotEmpty ? params : null,
    );

    return data
        .map((e) => CycleDayModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CycleDayModel> upsertDay({
    required String date,
    bool isPeriod = false,
    bool isIntercourse = false,
    String flow = '',
    String notes = '',
  }) async {
    final response = await _api.post(
      ApiEndpoints.cycleDays,
      body: {
        'date': date,
        'isPeriod': isPeriod,
        'isIntercourse': isIntercourse,
        'flow': flow,
        'notes': notes,
      },
    );

    return CycleDayModel.fromJson(response);
  }

  Future<void> deleteDay(int id) async {
    await _api.delete(ApiEndpoints.cycleDayById(id));
  }

  Future<PredictionModel> getPrediction() async {
    final response = await _api.get(ApiEndpoints.predictions);
    return PredictionModel.fromJson(response);
  }
}
