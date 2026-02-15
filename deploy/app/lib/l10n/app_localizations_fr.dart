// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get login => 'Connexion';

  @override
  String get loginSubtitle => 'Connectez votre compte pour démarrer ClawBox';

  @override
  String get loginFailed => 'Échec de la connexion.';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get continueWithApple => 'Continuer avec Apple';

  @override
  String get instance => 'Instance';

  @override
  String get statusRunning => 'En cours';

  @override
  String get statusWaiting => 'En attente';

  @override
  String get labelId => 'ID';

  @override
  String get labelName => 'Nom';

  @override
  String get statusConnected => 'Connecté';

  @override
  String get statusDisconnected => 'Déconnecté';

  @override
  String get labelBot => 'Bot';

  @override
  String get settings => 'Paramètres';

  @override
  String get manageSubscription => 'Gérer l\'abonnement';

  @override
  String get manageSubscriptionDesc =>
      'Vérifier et gérer l\'état de l\'abonnement';

  @override
  String get recreateInstance => 'Recréer l\'instance';

  @override
  String get recreateInstanceDesc =>
      'Réinitialiser toutes les données et reconfigurer';

  @override
  String get logout => 'Déconnexion';

  @override
  String get logoutDesc => 'Se déconnecter du compte';

  @override
  String get recreateConfirmMessage =>
      'Toutes les données seront réinitialisées et reconfigurées à zéro. Cette action est irréversible.';

  @override
  String get cancel => 'Annuler';

  @override
  String get recreate => 'Recréer';

  @override
  String get tagline => 'Découvrez votre assistant IA sur une messagerie';

  @override
  String get getStarted => 'Commencer';

  @override
  String get alreadySubscribed => 'Déjà abonné ?';

  @override
  String get instanceCreationFailed => 'Échec de la création de l\'instance';

  @override
  String get checkNetworkAndRetry =>
      'Veuillez vérifier votre connexion réseau et réessayer.';

  @override
  String get retry => 'Réessayer';

  @override
  String get creatingInstance => 'Création de l\'instance...';

  @override
  String get settingUp => 'Configuration en cours...';

  @override
  String get preparing => 'Préparation...';

  @override
  String get creatingInstanceDesc =>
      'Création de votre instance IA.\nVeuillez patienter.';

  @override
  String get startingInstanceDesc =>
      'Votre instance démarre.\nCela prend généralement 1 à 2 minutes.';

  @override
  String get pleaseWait => 'Veuillez patienter...';

  @override
  String get telegramBotSetup => 'Configuration du bot Telegram';

  @override
  String get telegramBotSetupDesc =>
      'Créez un bot via @BotFather sur Telegram.';

  @override
  String get stepSearchBotFather => 'Recherchez @BotFather sur Telegram';

  @override
  String get stepNewBot => 'Entrez la commande /newbot';

  @override
  String get stepSetBotName => 'Définissez le nom et le username du bot';

  @override
  String get stepEnterToken => 'Entrez le token reçu ci-dessous';

  @override
  String get enterBotToken => 'Entrez le token du bot';

  @override
  String get next => 'Suivant';

  @override
  String get botTokenError =>
      'Échec de la configuration du token. Veuillez vérifier votre token.';

  @override
  String get telegramPairing => 'Appairage Telegram';

  @override
  String get telegramPairingDesc =>
      'Entrez le code d\'authentification affiché lorsque vous envoyez un message au bot.';

  @override
  String get authCode => 'Code d\'authentification';

  @override
  String get approve => 'Approuver';

  @override
  String get pairingError => 'Échec de l\'appairage. Veuillez réessayer.';

  @override
  String get home => 'Accueil';

  @override
  String get setup => 'Configuration';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountDesc =>
      'Supprimer définitivement votre compte et toutes les données';

  @override
  String get deleteAccountConfirmTitle => 'Supprimer le compte ?';

  @override
  String get deleteAccountConfirmMessage =>
      'Votre instance sera supprimée et toutes les données seront définitivement perdues. Cette action est irréversible. Vous pouvez créer un nouveau compte après la suppression.';

  @override
  String get delete => 'Supprimer';

  @override
  String get setupCompleteTitle => 'Configuration terminée !';

  @override
  String get setupCompleteDesc =>
      'Envoyez un message à votre bot sur Telegram et OpenClaw répondra. Commencez à discuter maintenant !';

  @override
  String get startChatting => 'Commencer à discuter';
}
