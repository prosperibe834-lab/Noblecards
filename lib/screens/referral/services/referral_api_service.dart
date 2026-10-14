import '../../authentication/services/authentication_service.dart';
import '../models/referral_summary.dart';

class ReferralApiService {
  final AuthenticationService _authentication;

  ReferralApiService(this._authentication);

  Future<ReferralSummary> getMyReferralSummary() async {
    final response = await _authentication.authenticatedGet('/referrals/me');
    return ReferralSummary.fromJson(response);
  }
}
