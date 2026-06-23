class ApiEndpoints {
  ApiEndpoints._();

  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';

  static const String cycleDays = '/api/cycle/days';
  static String cycleDayById(int id) => '/api/cycle/days/$id';
  static const String predictions = '/api/cycle/predictions';

  static const String partnerCode = '/api/partner/code';
  static const String partnerCodeRegenerate = '/api/partner/code/regenerate';
  static const String partnerLink = '/api/partner/link';
  static const String partnerUnlink = '/api/partner/unlink';
  static const String partnerView = '/api/partner/view';
}
