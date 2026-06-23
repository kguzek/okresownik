import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../models/partner_model.dart';

class PartnerRepository {
  final ApiClient _api;

  PartnerRepository(this._api);

  Future<String> getPartnerCode() async {
    final response = await _api.get(ApiEndpoints.partnerCode);
    return response['partnerCode'] as String;
  }

  Future<String> regeneratePartnerCode() async {
    final response = await _api.post(ApiEndpoints.partnerCodeRegenerate);
    return response['partnerCode'] as String;
  }

  Future<void> linkToPartner(String partnerCode) async {
    await _api.post(
      ApiEndpoints.partnerLink,
      body: {'partnerCode': partnerCode},
    );
  }

  Future<void> unlinkPartner() async {
    await _api.post(ApiEndpoints.partnerUnlink);
  }

  Future<PartnerCalendarModel> getPartnerView() async {
    final response = await _api.get(ApiEndpoints.partnerView);
    return PartnerCalendarModel.fromJson(response);
  }
}
