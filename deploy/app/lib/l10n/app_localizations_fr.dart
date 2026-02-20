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

  @override
  String openBotOnTelegram(String botUsername) {
    return 'Ouvrir @$botUsername';
  }

  @override
  String get haveReferralCode => 'Vous avez un code de parrainage ?';

  @override
  String get enterReferralCode => 'Entrer le code de parrainage';

  @override
  String get referralCodeHint => 'Entrez votre code';

  @override
  String get referralCodeInvalid => 'Code de parrainage invalide.';

  @override
  String get referralCodeSuccess => 'Code de parrainage appliqué !';

  @override
  String get skipTelegramTitle => 'Passer la configuration Telegram ?';

  @override
  String get skipTelegramDesc =>
      'Vous pouvez vous connecter plus tard. En attendant, vous pouvez discuter dans l\'application.';

  @override
  String get skip => 'Passer';

  @override
  String get connectTelegram => 'Connecter Telegram';

  @override
  String get connectTelegramDesc =>
      'Connectez Telegram pour discuter aussi sur la messagerie';

  @override
  String get logIn => 'Se connecter';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get signUpSubtitle => 'Créez votre compte pour démarrer ClawBox';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get nameOptional => 'Nom (facultatif)';

  @override
  String get or => 'ou';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte ?';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ?';

  @override
  String get invalidEmail => 'Veuillez entrer un e-mail valide';

  @override
  String get passwordTooShort =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String agreeToTerms(String terms, String privacy) {
    return 'I agree to the $terms and $privacy';
  }

  @override
  String get mustAgreeToTerms =>
      'You must agree to the Terms of Service and Privacy Policy';

  @override
  String get aiDataConsentTitle => 'AI Data Sharing';

  @override
  String get aiDataConsentMessage =>
      'Your messages and image attachments are sent to third-party AI services (via OpenRouter) to generate responses. Your data is not used for AI training. By continuing, you consent to this data processing.';

  @override
  String get agree => 'Agree';

  @override
  String get decline => 'Decline';

  @override
  String get legal => 'Legal';

  @override
  String bySigningIn(String terms, String privacy) {
    return 'By signing in, you agree to our $terms and $privacy';
  }

  @override
  String get general => 'General';

  @override
  String get account => 'Account';

  @override
  String get goodMorning => 'Bonjour';

  @override
  String get goodAfternoon => 'Bon après-midi';

  @override
  String get goodEvening => 'Bonsoir';

  @override
  String get chatWithAI => 'Discuter avec l\'IA';

  @override
  String get agentReady => 'Votre agent est prêt';

  @override
  String get agentStarting => 'L\'agent démarre...';

  @override
  String get chatTitle => 'ClawBox AI';

  @override
  String get statusOnline => 'En ligne';

  @override
  String get statusConnecting => 'Connexion...';

  @override
  String get statusOffline => 'Hors ligne';

  @override
  String get statusAuthenticating => 'Authentification...';

  @override
  String get statusWaitingForConnection => 'En attente de connexion...';

  @override
  String get emptyChatTitle => 'Comment puis-je vous aider ?';

  @override
  String get emptyChatSubtitle =>
      'Posez-moi n\'importe quelle question sur votre projet';

  @override
  String get dateToday => 'Aujourd\'hui';

  @override
  String get dateYesterday => 'Hier';

  @override
  String get connectionError => 'Erreur de connexion';

  @override
  String get reconnect => 'Reconnecter';

  @override
  String get typeMessage => 'Saisissez un message...';

  @override
  String get sessions => 'Sessions';

  @override
  String get newSession => 'Nouvelle session';

  @override
  String get noSessionsYet => 'Aucune session pour le moment';

  @override
  String get timeNow => 'maintenant';

  @override
  String timeMinutes(int minutes) {
    return '${minutes}m';
  }

  @override
  String timeHours(int hours) {
    return '${hours}h';
  }

  @override
  String timeDays(int days) {
    return '${days}j';
  }
}
