import 'app_localizations.dart';

class AppLocalizationsPl extends AppLocalizations {
  @override
  String get appTitle => 'Okresownik';

  @override
  String get signIn => 'Zaloguj się';
  @override
  String get signInSubtitle => 'Zaloguj się na swoje konto';
  @override
  String get emailLabel => 'Email';
  @override
  String get emailRequired => 'Email jest wymagany';
  @override
  String get emailInvalid => 'Wprowadź poprawny email';
  @override
  String get passwordLabel => 'Hasło';
  @override
  String get passwordRequired => 'Hasło jest wymagane';
  @override
  String get noAccount => 'Nie masz konta? Zarejestruj się';

  @override
  String get createAccount => 'Utwórz konto';
  @override
  String get registerSubtitle => 'Śledź swój cykl z pewnością';
  @override
  String get fullNameLabel => 'Imię i nazwisko';
  @override
  String get nameRequired => 'Imię jest wymagane';
  @override
  String get passwordMinLength => 'Hasło musi mieć co najmniej 8 znaków';
  @override
  String get confirmPasswordLabel => 'Potwierdź hasło';
  @override
  String get passwordsDoNotMatch => 'Hasła nie są zgodne';
  @override
  String get haveAccount => 'Masz już konto? Zaloguj się';

  @override
  String get shareWithPartner => 'Udostępnij partnerowi';
  @override
  String get viewPartnerCalendar => 'Zobacz kalendarz partnera';
  @override
  String get logout => 'Wyloguj się';
  @override
  String get logToday => 'Zapisz dziś';
  @override
  String logDate(String formattedDate) => 'Zapisz $formattedDate';
  @override
  String get editRecordToday => 'Zmień zapis z dziś';
  @override
  String editRecordDate(String formattedDate) => 'Zmień zapis $formattedDate';
  @override
  String cycleDayText(int cycleDay) => 'Dzień cyklu $cycleDay';
  @override
  String nextPeriodExpectedText(String date) => 'Następna miesiączka ~$date';
  @override
  String get periodLabel => 'Miesiączka';
  @override
  String get predictedPeriodLabel => 'Przewidywana miesiączka';
  @override
  String get fertileLabel => 'Dni płodne';
  @override
  String get intimacyLabel => 'Intymność';
  @override
  String get today => 'Dziś';
  @override
  String flowText(String flow) {
    switch (flow) {
      case 'spotting':
        return 'Plamienie';
      case 'light':
        return 'Lekki';
      case 'medium':
        return 'Średni';
      case 'heavy':
        return 'Obfity';
      default:
        return flow;
    }
  }

  @override
  String get flowSpotting => 'Plamienie';
  @override
  String get flowLight => 'Lekki';
  @override
  String get flowMedium => 'Średni';
  @override
  String get flowHeavy => 'Obfity';
  @override
  String get intercourseLogged => 'Zaznaczono intymność';
  @override
  String get clearDayData => 'Wyczyść dane dnia';

  @override
  String get partnerSharing => 'Udostępnianie partnerowi';
  @override
  String get codeCopied => 'Kod partnera skopiowany do schowka';
  @override
  String get unlinkPartner => 'Odłącz partnera';
  @override
  String get unlinkConfirm => 'Czy na pewno chcesz odłączyć partnera? Nie będzie już widział Twojego kalendarza.';
  @override
  String get cancel => 'Anuluj';
  @override
  String get unlink => 'Odłącz';
  @override
  String get shareYourCalendar => 'Udostępnij swój kalendarz';
  @override
  String get shareSubtitle => 'Twój partner może oglądać Twój kalendarz i prognozy płodności za pomocą kodu pary.';
  @override
  String get yourPartnerCode => 'Twój kod partnera';
  @override
  String get copy => 'Kopiuj';
  @override
  String get regenerate => 'Generuj nowy';
  @override
  String linkedWithText(String name) => 'Połączono z $name';
  @override
  String get theyCanView => 'Mogą oglądać Twój kalendarz';
  @override
  String get enterPartnerCode => 'Wprowadź kod partnera';
  @override
  String get partnerCodeLabel => 'Kod partnera';
  @override
  String get partnerCodeHint => 'Wprowadź kod, który podał Ci partner';
  @override
  String get link => 'Połącz';

  @override
  String get partnersCalendar => 'Kalendarz partnera';
  @override
  String partnersCalendarText(String name) => 'Kalendarz $name';
  @override
  String get notLinkedYet => 'Jeszcze nie połączono z partnerem';
  @override
  String get notLinkedSubtitle => 'Przejdź do Udostępniania partnerowi i wprowadź jego kod';
  @override
  String get noDataAvailable => 'Brak danych partnera';
  @override
  String get readOnlyView => 'Widok tylko do odczytu cyklu partnera';
  @override
  String partnerNextPeriodText(String date) => 'Następna miesiączka ~$date';

  @override
  String get settings => 'Ustawienia';
  @override
  String get language => 'Język';
  @override
  String get firstDayOfWeek => 'Pierwszy dzień tygodnia';
  @override
  String get polish => 'Polski';
  @override
  String get english => 'Angielski';

  @override
  String get acceptTerms =>
      'Akceptuję Regulamin aplikacji Okresownik (otwórz w przeglądarce)';
  @override
  String get acceptPrivacy =>
      'Akceptuję Politykę prywatności aplikacji Okresownik (otwórz w przeglądarce)';
  @override
  String get consentDataProcessing =>
      'Wyrażam zgodę na przetwarzanie danych wrażliwych (danych o zdrowiu seksualnym i reprodukcyjnym) przez Administratora w celu świadczenia usług śledzenia cyklu i prognozowania płodności. Oświadczenie o przetwarzaniu danych zawarte jest w Polityce prywatności (otwórz w przeglądarce).';
  @override
  String get acceptAllRequired =>
      'Aby utworzyć konto, musisz zaakceptować Regulamin, Politykę prywatności i wyrazić zgodę na przetwarzanie danych wrażliwych.';
  @override
  String get acceptAndContinue => 'Akceptuję i kontynuuję';

  @override
  String get legalUpdateTitle => 'Aktualizacja prawna';
  @override
  String get legalUpdateSubtitle =>
      'W związku z wymogami RODO prosimy o zapoznanie się i zaakceptowanie zaktualizowanych dokumentów.';
  @override
  String get consentSummaryTitle => 'Przetwarzanie danych wrażliwych';
  @override
  String get consentSummaryBody =>
      'Okresownik przetwarza Twoje dane dotyczące zdrowia seksualnego i reprodukcyjnego (m.in. daty menstruacji, informacje o współżyciu, prognozy płodności) w celu świadczenia usług śledzenia cyklu. Zgodnie z art. 9 RODO, przetwarzanie tych danych wymaga Twojej wyraźnej zgody. Możesz w dowolnym momencie wycofać zgodę, usunąć dane lub usunąć konto w ustawieniach aplikacji.';

  @override
  String get deleteDataTitle => 'Usuń wszystkie dane';
  @override
  String get deleteDataSubtitle =>
      'Usuwa wszystkie dane cyklu, notatki i powiązania, ale zachowuje konto';
  @override
  String get deleteDataConfirm =>
      'Czy na pewno chcesz usunąć wszystkie swoje dane? Konto pozostanie aktywne, ale wszystkie dane cyklu, notatki i powiązania partnerskie zostaną trwale usunięte. Tej operacji nie można cofnąć.';
  @override
  String get deleteDataSuccess =>
      'Wszystkie dane zostały usunięte. Możesz nadal korzystać z aplikacji.';

  @override
  String get deleteAccountTitle => 'Usuń konto';
  @override
  String get deleteAccountSubtitle =>
      'Trwale usuwa konto i wszystkie powiązane dane';
  @override
  String get deleteAccountConfirm =>
      'Czy na pewno chcesz usunąć swoje konto? Spowoduje to trwałe usunięcie wszystkich danych, w tym danych cyklu, notatek i powiązań partnerskich. Tej operacji nie można cofnąć.';

  @override
  String get appVersion => 'Wersja aplikacji';
  @override
  String get apiVersion => 'Wersja API';

  @override
  String get updateAvailable => 'Dostępna aktualizacja';
  @override
  String get updateMessage =>
      'Nowa wersja Okresownika jest dostępna. Zaktualizuj aplikację, aby uzyskać najlepsze doświadczenia.';
  @override
  String get update => 'Aktualizuj';
  @override
  String get ignore => 'Ignoruj';
}
