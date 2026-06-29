import 'app_localizations.dart';

class AppLocalizationsEn extends AppLocalizations {
  @override
  String get appTitle => 'Okresownik';

  @override
  String get signIn => 'Sign In';
  @override
  String get signInSubtitle => 'Sign in to your account';
  @override
  String get emailLabel => 'Email';
  @override
  String get emailRequired => 'Email is required';
  @override
  String get emailInvalid => 'Enter a valid email';
  @override
  String get passwordLabel => 'Password';
  @override
  String get passwordRequired => 'Password is required';
  @override
  String get noAccount => "Don't have an account? Register";

  @override
  String get createAccount => 'Create Account';
  @override
  String get registerSubtitle => 'Track your cycle with confidence';
  @override
  String get fullNameLabel => 'Full Name';
  @override
  String get nameRequired => 'Name is required';
  @override
  String get passwordMinLength => 'Password must be at least 8 characters';
  @override
  String get confirmPasswordLabel => 'Confirm Password';
  @override
  String get passwordsDoNotMatch => 'Passwords do not match';
  @override
  String get haveAccount => 'Already have an account? Sign in';

  @override
  String get shareWithPartner => 'Share with Partner';
  @override
  String get viewPartnerCalendar => "View Partner's Calendar";
  @override
  String get logout => 'Logout';
  @override
  String get logToday => 'Log Today';
  @override
  String logDate(String formattedDate) => 'Log $formattedDate';
  @override
  String get editRecordToday => 'Edit record today';
  @override
  String editRecordDate(String formattedDate) => 'Edit record $formattedDate';
  @override
  String cycleDayText(int cycleDay) => 'Cycle Day $cycleDay';
  @override
  String nextPeriodExpectedText(String date) => 'Next period expected ~$date';
  @override
  String get periodLabel => 'Period';
  @override
  String get predictedPeriodLabel => 'Predicted period';
  @override
  String get fertileLabel => 'Fertile';
  @override
  String get intimacyLabel => 'Intimacy';
  @override
  String get today => 'Today';
  @override
  String flowText(String flow) {
    switch (flow) {
      case 'spotting':
        return 'Spotting';
      case 'light':
        return 'Light';
      case 'medium':
        return 'Medium';
      case 'heavy':
        return 'Heavy';
      default:
        return flow;
    }
  }

  @override
  String get flowSpotting => 'Spotting';
  @override
  String get flowLight => 'Light';
  @override
  String get flowMedium => 'Medium';
  @override
  String get flowHeavy => 'Heavy';
  @override
  String get intercourseLogged => 'Intercourse logged';
  @override
  String get clearDayData => 'Clear day data';

  @override
  String get partnerSharing => 'Partner Sharing';
  @override
  String get codeCopied => 'Partner code copied to clipboard';
  @override
  String get unlinkPartner => 'Unlink Partner';
  @override
  String get unlinkConfirm => 'Are you sure you want to unlink your partner? They will no longer see your calendar.';
  @override
  String get cancel => 'Cancel';
  @override
  String get unlink => 'Unlink';
  @override
  String get shareYourCalendar => 'Share Your Calendar';
  @override
  String get shareSubtitle => 'Your partner can view your period and fertility predictions with a pairing code.';
  @override
  String get yourPartnerCode => 'Your Partner Code';
  @override
  String get copy => 'Copy';
  @override
  String get regenerate => 'Regenerate';
  @override
  String linkedWithText(String name) => 'Linked with $name';
  @override
  String get theyCanView => 'They can view your calendar';
  @override
  String get enterPartnerCode => "Enter Partner's Code";
  @override
  String get partnerCodeLabel => "Partner's Code";
  @override
  String get partnerCodeHint => 'Enter the code your partner shared';
  @override
  String get link => 'Link';

  @override
  String get partnersCalendar => "Partner's Calendar";
  @override
  String partnersCalendarText(String name) => "$name's Calendar";
  @override
  String get notLinkedYet => 'Not linked to a partner yet';
  @override
  String get notLinkedSubtitle => 'Go to Share with Partner and enter their code';
  @override
  String get noDataAvailable => 'No partner data available';
  @override
  String get readOnlyView => "Read-only view of your partner's cycle";
  @override
  String partnerNextPeriodText(String date) => 'Next period ~$date';

  @override
  String get settings => 'Settings';
  @override
  String get language => 'Language';
  @override
  String get firstDayOfWeek => 'First day of week';
  @override
  String get polish => 'Polish';
  @override
  String get english => 'English';

  @override
  String get acceptTerms =>
      'I accept the Terms of Service of the Okresownik app (opens in browser)';
  @override
  String get acceptPrivacy =>
      'I accept the Privacy Policy of the Okresownik app (opens in browser)';
  @override
  String get consentDataProcessing =>
      'I consent to the processing of my sensitive data (sexual and reproductive health data) by the Administrator for the purpose of providing cycle tracking and fertility prediction services. The data processing statement is included in the Privacy Policy (opens in browser).';
  @override
  String get acceptAllRequired =>
      'To create an account, you must accept the Terms of Service, Privacy Policy, and consent to the processing of sensitive data.';
  @override
  String get acceptAndContinue => 'Accept and continue';

  @override
  String get legalUpdateTitle => 'Legal Update';
  @override
  String get legalUpdateSubtitle =>
      'Due to GDPR requirements, please review and accept the updated documents.';
  @override
  String get consentSummaryTitle => 'Sensitive Data Processing';
  @override
  String get consentSummaryBody =>
      'Okresownik processes your sexual and reproductive health data (including menstruation dates, intercourse information, fertility predictions) to provide cycle tracking services. Per Article 9 of GDPR, processing this data requires your explicit consent. You may withdraw consent, delete your data, or delete your account at any time in the app settings.';

  @override
  String get deleteDataTitle => 'Delete all data';
  @override
  String get deleteDataSubtitle =>
      'Deletes all cycle data, notes, and connections, but keeps your account';
  @override
  String get deleteDataConfirm =>
      'Are you sure you want to delete all your data? Your account will remain active, but all cycle data, notes, and partner connections will be permanently deleted. This action cannot be undone.';
  @override
  String get deleteDataSuccess =>
      'All data has been deleted. You can continue using the app.';

  @override
  String get deleteAccountTitle => 'Delete account';
  @override
  String get deleteAccountSubtitle =>
      'Permanently deletes your account and all associated data';
  @override
  String get deleteAccountConfirm =>
      'Are you sure you want to delete your account? This will permanently delete all data, including cycle data, notes, and partner connections. This action cannot be undone.';

  @override
  String get appVersion => 'App version';
  @override
  String get apiVersion => 'API version';
}
