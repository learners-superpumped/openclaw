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
      'Votre instance démarre.\nCela prend généralement 4 à 5 minutes.\nVous pouvez faire autre chose et revenir plus tard.';

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

  @override
  String get skills => 'Skills';

  @override
  String get allSkills => 'Tout';

  @override
  String get searchSkills => 'Rechercher des skills...';

  @override
  String get installed => 'Installé';

  @override
  String get install => 'Installer';

  @override
  String get uninstall => 'Désinstaller';

  @override
  String get installing => 'Installation...';

  @override
  String get uninstalling => 'Désinstallation...';

  @override
  String get installSuccess => 'Skill installé avec succès';

  @override
  String get uninstallSuccess => 'Skill désinstallé';

  @override
  String get installFailed => 'Échec de l\'installation du skill';

  @override
  String get uninstallFailed => 'Échec de la désinstallation du skill';

  @override
  String get noSkillsFound => 'Aucun skill trouvé';

  @override
  String get version => 'Version';

  @override
  String get author => 'Auteur';

  @override
  String get uninstallConfirmTitle => 'Désinstaller le skill ?';

  @override
  String get uninstallConfirmMessage =>
      'Ce skill sera supprimé de votre instance.';

  @override
  String get aiDataProcessing => 'Traitement des données IA';

  @override
  String get aiDataSharing => 'Partage des données IA';

  @override
  String get aiDataProviders => 'Fournisseurs de données IA';

  @override
  String get requestDataDeletion => 'Demander la suppression des données';

  @override
  String get aiConsentDataSentTitle => 'Données envoyées aux services IA';

  @override
  String get aiConsentDataSentMessages => 'Messages texte envoyés dans le chat';

  @override
  String get aiConsentDataSentImages =>
      'Pièces jointes images (JPEG, PNG, GIF, WebP)';

  @override
  String get aiConsentDataSentContext =>
      'Contexte de conversation pour les réponses IA';

  @override
  String get aiConsentRecipientsTitle => 'Destinataires des données';

  @override
  String get aiConsentRecipientOpenRouter =>
      'OpenRouter (routage des requêtes IA)';

  @override
  String get aiConsentRecipientProviders =>
      'OpenAI, Anthropic, Google (fournisseurs de modèles IA)';

  @override
  String get aiConsentUsageTitle => 'Utilisation de vos données';

  @override
  String get aiConsentUsageResponses =>
      'Utilisées uniquement pour générer des réponses IA';

  @override
  String get aiConsentUsageNoTraining =>
      'Non utilisées pour l\'entraînement des modèles IA';

  @override
  String get aiConsentUsageDeletion =>
      'Supprimées lors de la suppression de votre compte';

  @override
  String get aiConsentViewPrivacy => 'Voir la politique de confidentialité';

  @override
  String get revokeAiConsentTitle => 'Révoquer le consentement IA ?';

  @override
  String get revokeAiConsentMessage =>
      'Vous devrez accepter à nouveau avant d\'utiliser la fonction de chat.';

  @override
  String get revoke => 'Révoquer';

  @override
  String get aiDataProvidersTitle => 'Fournisseurs de services IA';

  @override
  String get aiDataProvidersDesc =>
      'Vos données peuvent être traitées par les services IA tiers suivants :';

  @override
  String get aiDisclosureAgree => 'Accepter et continuer';

  @override
  String get aiConsentRequired =>
      'Le consentement au traitement des données IA est requis pour utiliser ce service.';

  @override
  String get connectingBot => 'Connexion à votre bot Telegram...';

  @override
  String get connectingBotDesc =>
      'Veuillez patienter pendant la connexion à votre bot.\nCela ne prend généralement que quelques secondes.';

  @override
  String get botRestarting => 'Redémarrage de votre bot...';

  @override
  String get botRestartingDesc =>
      'Votre bot redémarre avec la nouvelle configuration.\nCela ne prend généralement que quelques secondes.';

  @override
  String get pendingPairingCodes => 'Codes d\'appairage en attente';

  @override
  String get noPendingCodes =>
      'Envoyez un message à votre bot Telegram et le code d\'appairage apparaîtra ici.';

  @override
  String get tapToApprove => 'Appuyer pour approuver';

  @override
  String get pairingApproved => 'Appairage approuvé !';

  @override
  String get dismiss => 'Ignorer';

  @override
  String get paywallTitle => 'Débloquez votre assistant IA';

  @override
  String get paywallFeature1 => 'Votre assistant IA personnel sur Telegram';

  @override
  String get paywallFeature2 => 'Discutez à tout moment, réponses instantanées';

  @override
  String get paywallFeature3 => 'Configuration en un clic, prêt en minutes';

  @override
  String get paywallReview =>
      'J\'envoie juste un message à mon bot sur Telegram et j\'obtiens des réponses instantanément. C\'est comme avoir un assistant personnel dans ma poche.';

  @override
  String get paywallReviewAuthor => 'Alex K';

  @override
  String get subscribe => 'S\'abonner';

  @override
  String get cancelAnytime => 'Annulez à tout moment';

  @override
  String get restore => 'Restaurer';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get weekly => 'Hebdomadaire';

  @override
  String get monthly => 'Mensuel';

  @override
  String get annual => 'Annuel';

  @override
  String get lifetime => 'À vie';

  @override
  String savePercent(int percent) {
    return 'Économisez $percent%';
  }

  @override
  String get channels => 'Canaux';

  @override
  String get channelsDesc => 'Gérez vos canaux de messagerie';

  @override
  String get channelConnected => 'Connecté';

  @override
  String get channelDisconnected => 'Déconnecté';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get connectWhatsApp => 'Connecter WhatsApp';

  @override
  String get generateQrCode => 'Régénérer le code QR';

  @override
  String get scanQrCode => 'Scannez le code QR avec WhatsApp';

  @override
  String get waitingForScan => 'En attente du scan...';

  @override
  String get disconnectChannel => 'Déconnecter';

  @override
  String get disconnectConfirmTitle => 'Déconnecter le canal ?';

  @override
  String get disconnectConfirmMessage =>
      'Ce canal sera déconnecté. Vous pourrez le reconnecter plus tard.';

  @override
  String pendingCount(int count) {
    return '$count en attente';
  }

  @override
  String channelsSummary(int connected) {
    return '$connected connectés';
  }

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscord => 'Connecter Discord';

  @override
  String get discordBotToken => 'Jeton du bot Discord';

  @override
  String get connect => 'Connecter';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get pasteImage => 'Coller l\'image';

  @override
  String get messageQueued => 'Aucun message en attente';

  @override
  String get messagesInQueue => 'Messages en attente';

  @override
  String get removeFromQueue => 'Retirer de la file';

  @override
  String get sessionSettings => 'Paramètres de session';

  @override
  String get reasoningLevel => 'Niveau de raisonnement';

  @override
  String get thinkingMode => 'Mode de réflexion';

  @override
  String get verboseLevel => 'Niveau de détail';

  @override
  String get deleteSession => 'Supprimer la session';

  @override
  String get deleteSessionConfirm =>
      'Cette session et son historique seront définitivement supprimés. Cette action est irréversible.';

  @override
  String get newMessagesBelow => 'Nouveaux messages';

  @override
  String get focusMode => 'Mode focus';

  @override
  String get exitFocusMode => 'Quitter le mode focus';

  @override
  String get compactingContext => 'Compactage du contexte...';

  @override
  String get contextCompacted => 'Contexte compacté';

  @override
  String get showingLastMessages => 'Affichage des derniers';

  @override
  String get messagesHidden => 'masqués :';

  @override
  String get largeMessageWarning => 'Long message';

  @override
  String get largeMessagePlaintext => 'Long message affiché en texte brut';

  @override
  String get reasoningLow => 'Bas';

  @override
  String get reasoningMedium => 'Moyen';

  @override
  String get reasoningHigh => 'Élevé';

  @override
  String get editSessionLabel => 'Étiquette de session';

  @override
  String get discordBotSetup => 'Configuration du bot Discord';

  @override
  String get discordBotSetupDesc =>
      'Créez un bot dans le portail développeur Discord.';

  @override
  String get stepCreateApp =>
      'Allez sur le portail développeur Discord et créez une application';

  @override
  String get stepAddBot => 'Allez dans l\'onglet Bot et ajoutez un bot';

  @override
  String get stepEnableIntents =>
      'Activez Message Content Intent dans les Privileged Intents';

  @override
  String get stepCopyToken => 'Copiez le token du bot et entrez-le ci-dessous';

  @override
  String get connectingDiscordBot => 'Connexion à votre bot Discord...';

  @override
  String get connectingDiscordBotDesc =>
      'Veuillez patienter pendant la connexion à votre bot.\nCela ne prend généralement que quelques secondes.';

  @override
  String get discordBotRestarting => 'Redémarrage de votre bot...';

  @override
  String get discordBotRestartingDesc =>
      'Votre bot redémarre avec la nouvelle configuration.\nCela ne prend généralement que quelques secondes.';

  @override
  String get discordNoPendingCodes =>
      'Envoyez un DM à votre bot Discord et le code d\'appairage apparaîtra ici.';

  @override
  String get discordPairing => 'Appairage Discord';

  @override
  String get discordPairingDesc =>
      'Entrez le code d\'authentification affiché lorsque vous envoyez un DM au bot.';

  @override
  String get webAccess => 'Accès Web';

  @override
  String get webAccessPreparing => 'Préparation de l\'accès web...';

  @override
  String get gatewayNetwork => 'Réseau';

  @override
  String get gatewayCertificate => 'Certificat';
}
