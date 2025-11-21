// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get headerTitle => 'ESCOLHA SUA AVENTURA.\nESCOLHA O SEU PILOTO.';

  @override
  String get headerSubtitle =>
      'O parque de atrações radicais mais completo! Viva a adrenalina do parapente, dos quads, do canopy e mais.';

  @override
  String get discoverParkButton => 'Descubra o parque';

  @override
  String get experiencesButton => 'Experiências';

  @override
  String get portalPilotsLink => 'Portal Pilotos';

  @override
  String get contactUsLink => 'Contacte-nos';

  @override
  String get createAccountButton => 'Criar conta';

  @override
  String get loginButton => 'Iniciar sessão';

  @override
  String get activitiesTitle => 'AS NOSSAS ATIVIDADES';

  @override
  String get testimonialsTitle => 'O QUE OS NOSSOS AVENTUREIROS DIZEM';

  @override
  String get reserveButton => 'Reservar';

  @override
  String get happyAdventurersStat => 'Aventureiros Felizes';

  @override
  String get extremeActivitiesStat => 'Atividades Radicais';

  @override
  String get securityStat => 'Segurança Certificada';

  @override
  String get attentionStat => 'Apoio e Suporte';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');
}
