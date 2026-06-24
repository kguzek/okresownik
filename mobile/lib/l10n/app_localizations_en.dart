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
  String cycleDayText(int cycleDay) => 'Cycle Day $cycleDay';
  @override
  String nextPeriodExpectedText(String date) => 'Next period expected ~$date';
  @override
  String get periodLabel => 'Period';
  @override
  String get fertileLabel => 'Fertile';
  @override
  String get intimacyLabel => 'Intimacy';
  @override
  String get today => 'Today';
  @override
  String flowText(String flow) => 'Flow: $flow';
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
  String get polish => 'Polish';
  @override
  String get english => 'English';
}
