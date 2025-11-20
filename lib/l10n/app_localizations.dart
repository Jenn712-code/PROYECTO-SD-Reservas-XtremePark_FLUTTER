import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('pt'),
    Locale('pt', 'BR'),
  ];

  /// No description provided for @headerTitle.
  ///
  /// In es, this message translates to:
  /// **'ELIGE TU AVENTURA.\nELIGE TU PILOTO.'**
  String get headerTitle;

  /// No description provided for @headerSubtitle.
  ///
  /// In es, this message translates to:
  /// **'¡El parque de atracciones extremas más completo! Vive la adrenalina del parapente, cuatrimotos, canopy, y más.'**
  String get headerSubtitle;

  /// No description provided for @discoverParkButton.
  ///
  /// In es, this message translates to:
  /// **'Descubre el parque'**
  String get discoverParkButton;

  /// No description provided for @experiencesButton.
  ///
  /// In es, this message translates to:
  /// **'Experiencias'**
  String get experiencesButton;

  /// No description provided for @portalPilotsLink.
  ///
  /// In es, this message translates to:
  /// **'Portal Pilotos'**
  String get portalPilotsLink;

  /// No description provided for @contactUsLink.
  ///
  /// In es, this message translates to:
  /// **'Contáctanos'**
  String get contactUsLink;

  /// No description provided for @createAccountButton.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get createAccountButton;

  /// No description provided for @loginButton.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get loginButton;

  /// No description provided for @activitiesTitle.
  ///
  /// In es, this message translates to:
  /// **'NUESTRAS ACTIVIDADES'**
  String get activitiesTitle;

  /// No description provided for @testimonialsTitle.
  ///
  /// In es, this message translates to:
  /// **'LO QUE DICEN NUESTROS AVENTUREROS'**
  String get testimonialsTitle;

  /// No description provided for @reserveButton.
  ///
  /// In es, this message translates to:
  /// **'Reserva'**
  String get reserveButton;

  /// No description provided for @happyAdventurersStat.
  ///
  /// In es, this message translates to:
  /// **'Aventureros Felices'**
  String get happyAdventurersStat;

  /// No description provided for @extremeActivitiesStat.
  ///
  /// In es, this message translates to:
  /// **'Actividades Extremas'**
  String get extremeActivitiesStat;

  /// No description provided for @securityStat.
  ///
  /// In es, this message translates to:
  /// **'Seguridad Garantizada'**
  String get securityStat;

  /// No description provided for @attentionStat.
  ///
  /// In es, this message translates to:
  /// **'Atención'**
  String get attentionStat;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'ja', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
