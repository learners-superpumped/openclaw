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
  String get webAccessPreparingHint =>
      'La configuration SSL peut prendre 15 minutes ou plus';

  @override
  String get gatewayNetwork => 'Réseau';

  @override
  String get gatewayCertificate => 'Certificat';

  @override
  String get remoteView => 'Vue à distance';

  @override
  String get remoteViewDescription => 'Voir l\'écran de l\'agent en temps réel';

  @override
  String get vncConnecting => 'Connexion...';

  @override
  String get vncConnected => 'Connecté';

  @override
  String get vncDisconnected => 'Déconnecté';

  @override
  String get vncError => 'Erreur de connexion';

  @override
  String get aiUsage => 'Utilisation IA';

  @override
  String get resetsWeekly => 'Réinitialisation hebdomadaire';

  @override
  String get resetsMonthly => 'Réinitialisation mensuelle';

  @override
  String get resetsDaily => 'Réinitialisation quotidienne';

  @override
  String get orDivider => 'OU';

  @override
  String get viewOnWeb => 'Voir sur ClawHub';

  @override
  String get defaultModel => 'Modèle par défaut';

  @override
  String get searchModels => 'Rechercher des modèles...';

  @override
  String get noModelsFound => 'Aucun modèle trouvé';

  @override
  String get gatewayRestartNotice => 'Modèle modifié. Le gateway redémarre...';

  @override
  String get changeDefaultModelError =>
      'Échec du changement de modèle par défaut';

  @override
  String get commonContinue => 'Continuer';

  @override
  String get onboardingBadgeTopApp => '#1 Application OpenClaw';

  @override
  String get onboardingWelcomeTitle => 'Votre agent IA.\nPrêt en 60 secondes.';

  @override
  String get onboardingWelcomeSubtitle =>
      'Aucune configuration. Aucune clé API. Aucune compétence technique.';

  @override
  String get onboardingGithubStarsBadge => '200K+ étoiles GitHub';

  @override
  String get onboardingPoweredByModels =>
      'Propulsé par plus de 400 modèles d\'IA';

  @override
  String get onboardingQuoteSamAltman =>
      '“Un génie avec des idées incroyables sur l\'avenir des agents très intelligents”';

  @override
  String get onboardingQuoteSamAltmanAttribution =>
      '— Sam Altman, PDG d\'OpenAI';

  @override
  String get onboardingGithubStarCount => '200 000+';

  @override
  String get onboardingGithubStarsLabel => 'Étoiles GitHub';

  @override
  String get onboardingGithubFastestGrowing =>
      'Le projet à la croissance la plus rapide de l\'histoire de GitHub';

  @override
  String get onboardingGithubStarsSingleDay =>
      '25 310 étoiles en une seule journée';

  @override
  String get onboardingTweetsSectionTitle =>
      'Approuvé par les leaders de l\'IA et de la tech';

  @override
  String get onboardingEasySetupTitle =>
      'Configuration en 60 secondes.\nAucune expertise requise.';

  @override
  String get onboardingEasySetupSubtitle =>
      'Vous n\'avez besoin d\'aucune connaissance technique. Nous nous occupons du reste.';

  @override
  String get onboardingEasySetupNoApiKeys => 'Aucune clé API requise';

  @override
  String get onboardingEasySetupNoTerminal =>
      'Aucun terminal ni ligne de commande';

  @override
  String get onboardingEasySetupNoServer => 'Aucun Mac Mini ni serveur';

  @override
  String get onboardingEasySetupNoTechKnowledge =>
      'Aucune connaissance technique';

  @override
  String get onboardingSafeByDesignTitle =>
      'Sécurisé par conception.\nVos données, vos règles.';

  @override
  String get onboardingSafeByDesignPressQuote =>
      '“ClawBox est une sensation IA, mais sa sécurité est encore en cours d\'amélioration”';

  @override
  String get onboardingSafeByDesignSubtitle =>
      'Votre agent s\'exécute dans un environnement AWS entièrement isolé. Partagez uniquement ce que vous voulez. Votre agent, votre espace.';

  @override
  String get onboardingSafeByDesignCheck1 =>
      'Environnement cloud entièrement séparé';

  @override
  String get onboardingSafeByDesignCheck2 =>
      'Vous contrôlez ce à quoi votre agent accède';

  @override
  String get onboardingSafeByDesignCheck3 => 'Calcul indépendant, non partagé';

  @override
  String get commonLogout => 'Déconnexion';

  @override
  String get onboardingFullFeaturesTitle =>
      '100% ClawBox.\nToutes les fonctionnalités incluses.';

  @override
  String get onboardingFullFeaturesSubtitle =>
      'Tout ce que votre ordinateur peut faire, Atlas le fait pour vous :';

  @override
  String get onboardingFullFeaturesExample1 =>
      '“Vérifie mes e-mails et rédige des réponses pour ceux qui nécessitent attention”';

  @override
  String get onboardingFullFeaturesExample2 =>
      '“Rachète le lait que j\'ai acheté la dernière fois sur Amazon”';

  @override
  String get onboardingFullFeaturesExample3 =>
      '“Planifie un voyage de 5 nuits à Las Vegas — vols, hôtels — et envoie-moi l\'itinéraire par e-mail”';

  @override
  String get onboardingFullFeaturesTagline =>
      'Sans limites. Sans courbe d\'apprentissage. Que des résultats.';

  @override
  String get newPaywallTitle => 'Débloquez toute la puissance de votre agent';

  @override
  String get newPaywallSubtitle =>
      'Tout est configuré. Commencez à utiliser votre agent maintenant.';

  @override
  String get newPaywallBenefit1 => 'Ordinateur cloud dédié — 24h/24 7j/7';

  @override
  String get newPaywallBenefit2 => 'Plus de 400 modèles d\'IA — illimité';

  @override
  String get newPaywallBenefit3 =>
      'Plus de 100 AgentSkills — prêts à l\'emploi';

  @override
  String get newPaywallFaqPriceQuestion => 'Pourquoi ce prix ?';

  @override
  String get newPaywallFaqPriceAnswer =>
      'Nous vous allouons un ordinateur cloud dédié, fonctionnant 24h/24, avec un accès illimité à plus de 400 modèles d\'IA. C\'est le coût réel d\'un agent IA personnel qui fonctionne vraiment.';

  @override
  String get newPaywallFaqCheaperQuestion =>
      'Et les alternatives moins chères ?';

  @override
  String get newPaywallFaqCheaperAnswer =>
      'Un véritable environnement dédié avec un accès réel aux modèles d\'IA nécessite une véritable infrastructure. Nous ne faisons pas de compromis — votre agent fonctionne sur son propre cloud isolé, pas sur des ressources partagées.';

  @override
  String get newPaywallPeriodWeek => '/ semaine';

  @override
  String get newPaywallPeriodMonth => '/ mois';

  @override
  String get newPaywallBestValueBadge => 'MEILLEUR RAPPORT';

  @override
  String get newPaywallStartNowButton => 'Commencer maintenant';

  @override
  String get newPaywallRestorePurchase => 'Restaurer l\'achat';

  @override
  String get newPaywallHaveReferralCode => 'Vous avez un code de parrainage ?';

  @override
  String get newPaywallSocialProof => 'Plus de 200 000 agents déployés';

  @override
  String get newPaywallReferralSheetTitle => 'Entrer le code de parrainage';

  @override
  String get newPaywallReferralHint => 'ex. FRIEND2024';

  @override
  String get newPaywallReferralApplyButton => 'Appliquer';

  @override
  String get newPaywallReferralAppliedSuccess =>
      'Code de parrainage appliqué !';

  @override
  String get newPaywallReferralInvalid => 'Code de parrainage invalide';

  @override
  String get userProfileTitle => 'Parlez-nous de vous';

  @override
  String get userProfileSubtitle =>
      'Pour que votre agent sache pour qui il travaille';

  @override
  String get userProfileNameLabel => 'Votre nom';

  @override
  String get userProfileNameHint => 'Jean Dupont';

  @override
  String get userProfileCallNameLabel => 'Comment devrions-nous vous appeler ?';

  @override
  String get userProfileCallNameHint => 'Jean';

  @override
  String get taskSelectionTitle => 'Que devrait faire votre agent ?';

  @override
  String get taskSelectionSubtitle => 'Sélectionnez au moins 1';

  @override
  String get taskOptionEmailManagement => 'Gestion des e-mails';

  @override
  String get taskOptionWebResearch => 'Recherche web';

  @override
  String get taskOptionTaskAutomation => 'Automatisation des tâches';

  @override
  String get taskOptionScheduling => 'Planification';

  @override
  String get taskOptionSocialMedia => 'Réseaux sociaux';

  @override
  String get taskOptionWriting => 'Rédaction';

  @override
  String get taskOptionDataAnalysis => 'Analyse de données';

  @override
  String get taskOptionSmartHome => 'Maison intelligente';

  @override
  String get vibeSelectionTitle => 'Définissez le style de votre agent';

  @override
  String get vibeSelectionSubtitle =>
      'Comment votre agent devrait-il communiquer ?';

  @override
  String get vibeNameCasual => 'Décontracté';

  @override
  String get vibeDescCasual =>
      'Détendu et amical. Comme envoyer un message à un ami intelligent.';

  @override
  String get vibeNameProfessional => 'Professionnel';

  @override
  String get vibeDescProfessional =>
      'Clair et structuré. Communication prête pour le business.';

  @override
  String get vibeNameFriendly => 'Amical';

  @override
  String get vibeDescFriendly =>
      'Chaleureux et encourageant. Toujours positif et utile.';

  @override
  String get vibeNameDirect => 'Direct';

  @override
  String get vibeDescDirect =>
      'Droit au but. Pas de superflu, efficacité maximale.';

  @override
  String get agentCreationTitle => 'Créez votre agent';

  @override
  String get agentCreationSubtitle =>
      'Choisissez un look et une personnalité pour votre agent';

  @override
  String get agentCreationNameLabel => 'Nom de l\'agent';

  @override
  String get agentCreationNameHint => 'Atlas';

  @override
  String get agentCreationCreatureLabel => 'Type de créature';

  @override
  String get agentCreationEmojiLabel => 'Emoji de l\'agent';

  @override
  String get creatureCat => 'Chat';

  @override
  String get creatureDragon => 'Dragon';

  @override
  String get creatureFox => 'Renard';

  @override
  String get creatureOwl => 'Hibou';

  @override
  String get creatureRabbit => 'Lapin';

  @override
  String get creatureBear => 'Ours';

  @override
  String get creatureDino => 'Dinosaure';

  @override
  String get creaturePenguin => 'Pingouin';

  @override
  String get creaturePerson => 'Personne';

  @override
  String get creatureWolf => 'Loup';

  @override
  String get creaturePanda => 'Panda';

  @override
  String get creatureUnicorn => 'Licorne';

  @override
  String get commonFallbackFriend => 'ami';

  @override
  String get commonFallbackYourAgent => 'votre agent';

  @override
  String get fakeLoadingStep1 => 'Profil configuré';

  @override
  String get fakeLoadingStep2 => 'Personnalité définie';

  @override
  String get fakeLoadingStep3 => 'Déploiement dans le cloud...';

  @override
  String get fakeLoadingStep4 => 'Connexion de plus de 400 modèles d\'IA';

  @override
  String get fakeLoadingStep5 => 'Allocation des ressources de calcul';

  @override
  String get fakeLoadingStep6 => 'Chargement de plus de 100 AgentSkills';

  @override
  String get fakeLoadingStep7 =>
      'Configuration de l\'espace de travail de l\'agent';

  @override
  String fakeLoadingTitle(String callName) {
    return 'Hey $callName, patientez un instant...';
  }

  @override
  String get fakeLoadingSubtitle =>
      'Nous configurons votre agent dans le cloud.\nVotre agent personnel est presque prêt.';

  @override
  String get agentCompleteSubtitle =>
      'Votre agent est entièrement déployé et optimisé pour vos tâches.';

  @override
  String get agentCompleteStatus1 => 'Agent 24/7 — toujours actif';

  @override
  String get agentCompleteStatus2 => 'Plus de 400 modèles d\'IA — connectés';

  @override
  String get agentCompleteStatus3 => 'Plus de 100 AgentSkills — chargés';

  @override
  String get agentCompleteStatus4 => 'Ressources de calcul — sécurisées';

  @override
  String agentCompleteTitle(String agentName, String callName) {
    return '$agentName est prêt, $callName !';
  }

  @override
  String get agentCompleteOptimizedForLabel => 'OPTIMISÉ POUR';

  @override
  String agentCompleteLiveHint(String agentName) {
    return '$agentName est en ligne et vous attend';
  }
}
