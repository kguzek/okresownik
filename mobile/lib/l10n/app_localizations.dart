import 'package:flutter/material.dart';

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const delegate = _AppLocalizationsDelegate();

  String get appTitle;

  String get signIn;
  String get signInSubtitle;
  String get emailLabel;
  String get emailRequired;
  String get emailInvalid;
  String get passwordLabel;
  String get passwordRequired;
  String get noAccount;

  String get createAccount;
  String get registerSubtitle;
  String get fullNameLabel;
  String get nameRequired;
  String get passwordMinLength;
  String get confirmPasswordLabel;
  String get passwordsDoNotMatch;
  String get haveAccount;

  String get shareWithPartner;
  String get viewPartnerCalendar;
  String get logout;
  String get logToday;
  String logDate(String formattedDate);
  String cycleDayText(int cycleDay);
  String nextPeriodExpectedText(String date);
  String get periodLabel;
  String get fertileLabel;
  String get intimacyLabel;
  String get today;
  String flowText(String flow);
  String get flowSpotting;
  String get flowLight;
  String get flowMedium;
  String get flowHeavy;
  String get intercourseLogged;
  String get clearDayData;

  String get partnerSharing;
  String get codeCopied;
  String get unlinkPartner;
  String get unlinkConfirm;
  String get cancel;
  String get unlink;
  String get shareYourCalendar;
  String get shareSubtitle;
  String get yourPartnerCode;
  String get copy;
  String get regenerate;
  String linkedWithText(String name);
  String get theyCanView;
  String get enterPartnerCode;
  String get partnerCodeLabel;
  String get partnerCodeHint;
  String get link;

  String get partnersCalendar;
  String partnersCalendarText(String name);
  String get notLinkedYet;
  String get notLinkedSubtitle;
  String get noDataAvailable;
  String get readOnlyView;
  String partnerNextPeriodText(String date);

  String get settings;
  String get language;
  String get polish;
  String get english;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'pl'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'pl':
        return AppLocalizationsPl();
      default:
        return AppLocalizationsEn();
    }
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
