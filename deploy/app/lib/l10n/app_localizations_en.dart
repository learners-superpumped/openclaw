// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'Login';

  @override
  String get loginSubtitle => 'Connect your account to start ClawBox';

  @override
  String get loginFailed => 'Login failed.';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get instance => 'Instance';

  @override
  String get statusRunning => 'Running';

  @override
  String get statusWaiting => 'Waiting';

  @override
  String get labelId => 'ID';

  @override
  String get labelName => 'Name';

  @override
  String get statusConnected => 'Connected';

  @override
  String get statusDisconnected => 'Disconnected';

  @override
  String get labelBot => 'Bot';

  @override
  String get settings => 'Settings';

  @override
  String get manageSubscription => 'Manage Subscription';

  @override
  String get manageSubscriptionDesc => 'Check and manage subscription status';

  @override
  String get recreateInstance => 'Recreate Instance';

  @override
  String get recreateInstanceDesc => 'Reset all data and reconfigure';

  @override
  String get logout => 'Log Out';

  @override
  String get logoutDesc => 'Sign out from account';

  @override
  String get recreateConfirmMessage =>
      'All data will be reset and reconfigured from scratch. This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get recreate => 'Recreate';

  @override
  String get tagline => 'Meet your AI assistant on a messenger';

  @override
  String get getStarted => 'Get Started';

  @override
  String get alreadySubscribed => 'Already subscribed?';

  @override
  String get instanceCreationFailed => 'Failed to create instance';

  @override
  String get checkNetworkAndRetry =>
      'Please check your network connection and try again.';

  @override
  String get retry => 'Retry';

  @override
  String get creatingInstance => 'Creating instance...';

  @override
  String get settingUp => 'Setting up...';

  @override
  String get preparing => 'Preparing...';

  @override
  String get creatingInstanceDesc => 'Creating your AI instance.\nPlease wait.';

  @override
  String get startingInstanceDesc =>
      'Your instance is starting up.\nThis usually takes 4-5 minutes.\nFeel free to leave and come back later.';

  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get telegramBotSetup => 'Telegram Bot Setup';

  @override
  String get telegramBotSetupDesc => 'Create a bot via @BotFather on Telegram.';

  @override
  String get stepSearchBotFather => 'Search @BotFather on Telegram';

  @override
  String get stepNewBot => 'Enter the /newbot command';

  @override
  String get stepSetBotName => 'Set bot name and username';

  @override
  String get stepEnterToken => 'Enter the issued token below';

  @override
  String get enterBotToken => 'Enter bot token';

  @override
  String get next => 'Next';

  @override
  String get botTokenError =>
      'Failed to set bot token. Please check your token.';

  @override
  String get telegramPairing => 'Telegram Pairing';

  @override
  String get telegramPairingDesc =>
      'Enter the auth code displayed when you message the bot.';

  @override
  String get authCode => 'Auth Code';

  @override
  String get approve => 'Approve';

  @override
  String get pairingError => 'Pairing failed. Please try again.';

  @override
  String get home => 'Home';

  @override
  String get setup => 'Setup';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountDesc =>
      'Permanently delete your account and all data';

  @override
  String get deleteAccountConfirmTitle => 'Delete Account?';

  @override
  String get deleteAccountConfirmMessage =>
      'Your instance will be deleted and all data will be permanently lost. This action cannot be undone. You can create a new account after deletion.';

  @override
  String get delete => 'Delete';

  @override
  String get setupCompleteTitle => 'Setup Complete!';

  @override
  String get setupCompleteDesc =>
      'Send a message to your bot on Telegram and OpenClaw will reply. Start chatting now!';

  @override
  String get startChatting => 'Start Chatting';

  @override
  String openBotOnTelegram(String botUsername) {
    return 'Open @$botUsername';
  }

  @override
  String get haveReferralCode => 'Have a referral code?';

  @override
  String get enterReferralCode => 'Enter Referral Code';

  @override
  String get referralCodeHint => 'Enter your code';

  @override
  String get referralCodeInvalid => 'Invalid referral code.';

  @override
  String get referralCodeSuccess => 'Referral code applied!';

  @override
  String get skipTelegramTitle => 'Skip Telegram Setup?';

  @override
  String get skipTelegramDesc =>
      'You can connect later. Until connected, you can chat within the app.';

  @override
  String get skip => 'Skip';

  @override
  String get connectTelegram => 'Connect Telegram';

  @override
  String get connectTelegramDesc => 'Connect Telegram to chat on messenger too';

  @override
  String get logIn => 'Log In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signUpSubtitle => 'Create your account to start ClawBox';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get nameOptional => 'Name (optional)';

  @override
  String get or => 'or';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get invalidEmail => 'Please enter a valid email';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

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
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get chatWithAI => 'Chat with AI';

  @override
  String get agentReady => 'Your agent is ready';

  @override
  String get agentStarting => 'Agent is starting up...';

  @override
  String get chatTitle => 'ClawBox AI';

  @override
  String get statusOnline => 'Online';

  @override
  String get statusConnecting => 'Connecting...';

  @override
  String get statusOffline => 'Offline';

  @override
  String get statusAuthenticating => 'Authenticating...';

  @override
  String get statusWaitingForConnection => 'Waiting for connection...';

  @override
  String get emptyChatTitle => 'How can I help you today?';

  @override
  String get emptyChatSubtitle => 'Ask me anything about your project';

  @override
  String get dateToday => 'Today';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String get connectionError => 'Connection Error';

  @override
  String get reconnect => 'Reconnect';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get sessions => 'Sessions';

  @override
  String get newSession => 'New session';

  @override
  String get noSessionsYet => 'No sessions yet';

  @override
  String get timeNow => 'now';

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
    return '${days}d';
  }

  @override
  String get skills => 'Skills';

  @override
  String get allSkills => 'All';

  @override
  String get searchSkills => 'Search skills...';

  @override
  String get installed => 'Installed';

  @override
  String get install => 'Install';

  @override
  String get uninstall => 'Uninstall';

  @override
  String get installing => 'Installing...';

  @override
  String get uninstalling => 'Uninstalling...';

  @override
  String get installSuccess => 'Skill installed successfully';

  @override
  String get uninstallSuccess => 'Skill uninstalled';

  @override
  String get installFailed => 'Failed to install skill';

  @override
  String get uninstallFailed => 'Failed to uninstall skill';

  @override
  String get noSkillsFound => 'No skills found';

  @override
  String get version => 'Version';

  @override
  String get author => 'Author';

  @override
  String get uninstallConfirmTitle => 'Uninstall Skill?';

  @override
  String get uninstallConfirmMessage =>
      'This skill will be removed from your instance.';

  @override
  String get aiDataProcessing => 'AI Data Processing';

  @override
  String get aiDataSharing => 'AI Data Sharing';

  @override
  String get aiDataProviders => 'AI Data Providers';

  @override
  String get requestDataDeletion => 'Request Data Deletion';

  @override
  String get aiConsentDataSentTitle => 'Data Sent to AI Services';

  @override
  String get aiConsentDataSentMessages => 'Text messages you send in chat';

  @override
  String get aiConsentDataSentImages =>
      'Image attachments (JPEG, PNG, GIF, WebP)';

  @override
  String get aiConsentDataSentContext =>
      'Conversation context for AI responses';

  @override
  String get aiConsentRecipientsTitle => 'Data Recipients';

  @override
  String get aiConsentRecipientOpenRouter => 'OpenRouter (AI request routing)';

  @override
  String get aiConsentRecipientProviders =>
      'OpenAI, Anthropic, Google (AI model providers)';

  @override
  String get aiConsentUsageTitle => 'How Your Data Is Used';

  @override
  String get aiConsentUsageResponses => 'Used solely to generate AI responses';

  @override
  String get aiConsentUsageNoTraining => 'Not used for AI model training';

  @override
  String get aiConsentUsageDeletion => 'Deleted when you delete your account';

  @override
  String get aiConsentViewPrivacy => 'View Privacy Policy';

  @override
  String get revokeAiConsentTitle => 'Revoke AI Data Consent?';

  @override
  String get revokeAiConsentMessage =>
      'You will need to agree again before using the chat feature.';

  @override
  String get revoke => 'Revoke';

  @override
  String get aiDataProvidersTitle => 'AI Service Providers';

  @override
  String get aiDataProvidersDesc =>
      'Your data may be processed by the following third-party AI services:';

  @override
  String get aiDisclosureAgree => 'Agree & Continue';

  @override
  String get aiConsentRequired =>
      'AI data consent is required to use this service.';

  @override
  String get connectingBot => 'Connecting your Telegram bot...';

  @override
  String get connectingBotDesc =>
      'Please wait while we connect to your bot.\nThis usually takes a few seconds.';

  @override
  String get botRestarting => 'Restarting your bot...';

  @override
  String get botRestartingDesc =>
      'Your bot is restarting with the new configuration.\nThis usually takes a few seconds.';

  @override
  String get pendingPairingCodes => 'Pending Pairing Codes';

  @override
  String get noPendingCodes =>
      'Send a message to your Telegram bot and the pairing code will appear here.';

  @override
  String get tapToApprove => 'Tap to approve';

  @override
  String get pairingApproved => 'Pairing approved successfully!';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get paywallTitle => 'Unlock Your AI Assistant';

  @override
  String get paywallFeature1 => 'Your personal AI assistant on Telegram';

  @override
  String get paywallFeature2 => 'Chat anytime, get instant replies';

  @override
  String get paywallFeature3 => 'One-tap setup, ready in minutes';

  @override
  String get paywallReview =>
      'I just message my bot on Telegram and get answers instantly. It\'s like having a personal assistant in my pocket.';

  @override
  String get paywallReviewAuthor => 'Alex K';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get cancelAnytime => 'Cancel anytime';

  @override
  String get restore => 'Restore';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get annual => 'Annual';

  @override
  String get lifetime => 'Lifetime';

  @override
  String savePercent(int percent) {
    return 'Save $percent%';
  }

  @override
  String get channels => 'Channels';

  @override
  String get channelsDesc => 'Manage your messaging channels';

  @override
  String get channelConnected => 'Connected';

  @override
  String get channelDisconnected => 'Disconnected';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get connectWhatsApp => 'Connect WhatsApp';

  @override
  String get generateQrCode => 'Regenerate QR Code';

  @override
  String get scanQrCode => 'Scan QR Code with WhatsApp';

  @override
  String get waitingForScan => 'Waiting for scan...';

  @override
  String get disconnectChannel => 'Disconnect';

  @override
  String get disconnectConfirmTitle => 'Disconnect Channel?';

  @override
  String get disconnectConfirmMessage =>
      'This channel will be disconnected. You can reconnect it later.';

  @override
  String pendingCount(int count) {
    return '$count pending';
  }

  @override
  String channelsSummary(int connected) {
    return '$connected connected';
  }

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscord => 'Connect Discord';

  @override
  String get discordBotToken => 'Discord Bot Token';

  @override
  String get connect => 'Connect';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get pasteImage => 'Paste image';

  @override
  String get messageQueued => 'No queued messages';

  @override
  String get messagesInQueue => 'Messages in queue';

  @override
  String get removeFromQueue => 'Remove from queue';

  @override
  String get sessionSettings => 'Session Settings';

  @override
  String get reasoningLevel => 'Reasoning Level';

  @override
  String get thinkingMode => 'Thinking Mode';

  @override
  String get verboseLevel => 'Verbose Level';

  @override
  String get deleteSession => 'Delete Session';

  @override
  String get deleteSessionConfirm =>
      'This session and its history will be permanently deleted. This action cannot be undone.';

  @override
  String get newMessagesBelow => 'New messages';

  @override
  String get focusMode => 'Focus Mode';

  @override
  String get exitFocusMode => 'Exit Focus Mode';

  @override
  String get compactingContext => 'Compacting context...';

  @override
  String get contextCompacted => 'Context compacted';

  @override
  String get showingLastMessages => 'Showing last';

  @override
  String get messagesHidden => 'hidden:';

  @override
  String get largeMessageWarning => 'Large message';

  @override
  String get largeMessagePlaintext => 'Large message displayed as plain text';

  @override
  String get reasoningLow => 'Low';

  @override
  String get reasoningMedium => 'Medium';

  @override
  String get reasoningHigh => 'High';

  @override
  String get editSessionLabel => 'Session label';

  @override
  String get discordBotSetup => 'Discord Bot Setup';

  @override
  String get discordBotSetupDesc =>
      'Create a bot in the Discord Developer Portal.';

  @override
  String get stepCreateApp =>
      'Go to Discord Developer Portal and create an application';

  @override
  String get stepAddBot => 'Go to Bot tab and add a bot';

  @override
  String get stepEnableIntents =>
      'Enable Message Content Intent under Privileged Intents';

  @override
  String get stepCopyToken => 'Copy the bot token and enter it below';

  @override
  String get connectingDiscordBot => 'Connecting your Discord bot...';

  @override
  String get connectingDiscordBotDesc =>
      'Please wait while we connect to your bot.\nThis usually takes a few seconds.';

  @override
  String get discordBotRestarting => 'Restarting your bot...';

  @override
  String get discordBotRestartingDesc =>
      'Your bot is restarting with the new configuration.\nThis usually takes a few seconds.';

  @override
  String get discordNoPendingCodes =>
      'Send a DM to your Discord bot and the pairing code will appear here.';

  @override
  String get discordPairing => 'Discord Pairing';

  @override
  String get discordPairingDesc =>
      'Enter the auth code displayed when you DM the bot.';

  @override
  String get webAccess => 'Web Access';

  @override
  String get webAccessPreparing => 'Preparing web access...';

  @override
  String get webAccessPreparingHint => 'SSL setup can take 15 minutes or more';

  @override
  String get gatewayNetwork => 'Network';

  @override
  String get gatewayCertificate => 'Certificate';

  @override
  String get remoteView => 'Remote View';

  @override
  String get remoteViewDescription => 'Watch agent screen in real-time';

  @override
  String get vncConnecting => 'Connecting...';

  @override
  String get vncConnected => 'Connected';

  @override
  String get vncDisconnected => 'Disconnected';

  @override
  String get vncError => 'Connection Error';

  @override
  String get aiUsage => 'AI Usage';

  @override
  String get resetsWeekly => 'Resets weekly';

  @override
  String get resetsMonthly => 'Resets monthly';

  @override
  String get resetsDaily => 'Resets daily';

  @override
  String get orDivider => 'OR';

  @override
  String get viewOnWeb => 'View on ClawHub';

  @override
  String get defaultModel => 'Default Model';

  @override
  String get searchModels => 'Search models...';

  @override
  String get noModelsFound => 'No models found';

  @override
  String get gatewayRestartNotice => 'Model changed. Gateway is restarting...';

  @override
  String get changeDefaultModelError => 'Failed to change default model';

  @override
  String get commonContinue => 'Continue';

  @override
  String get onboardingBadgeTopApp => '#1 OpenClaw App';

  @override
  String get onboardingWelcomeTitle => 'Your AI agent.\nReady in 60 seconds.';

  @override
  String get onboardingWelcomeSubtitle =>
      'No setup. No API keys. No tech skills.';

  @override
  String get onboardingGithubStarsBadge => '200K+ GitHub Stars';

  @override
  String get onboardingPoweredByModels => 'Powered by 400+ AI models';

  @override
  String get onboardingQuoteSamAltman =>
      '“A genius with amazing ideas about the future of very smart agents”';

  @override
  String get onboardingQuoteSamAltmanAttribution =>
      '— Sam Altman, CEO of OpenAI';

  @override
  String get onboardingGithubStarCount => '200,000+';

  @override
  String get onboardingGithubStarsLabel => 'GitHub Stars';

  @override
  String get onboardingGithubFastestGrowing =>
      'The fastest-growing project in GitHub history';

  @override
  String get onboardingGithubStarsSingleDay => '25,310 stars in a single day';

  @override
  String get onboardingTweetsSectionTitle => 'Trusted by leaders in AI & tech';

  @override
  String get onboardingEasySetupTitle =>
      'Setup in 60 seconds.\nNo expertise needed.';

  @override
  String get onboardingEasySetupSubtitle =>
      'You don\'t need to know anything technical. We handle all the rest.';

  @override
  String get onboardingEasySetupNoApiKeys => 'No API keys required';

  @override
  String get onboardingEasySetupNoTerminal => 'No terminal or command line';

  @override
  String get onboardingEasySetupNoServer => 'No Mac Mini or server';

  @override
  String get onboardingEasySetupNoTechKnowledge => 'No technical knowledge';

  @override
  String get onboardingSafeByDesignTitle =>
      'Safe by design.\nYour data, your rules.';

  @override
  String get onboardingSafeByDesignPressQuote =>
      '“ClawBox’s an AI Sensation, But Its Security a Work in Progress”';

  @override
  String get onboardingSafeByDesignSubtitle =>
      'Your agent runs in a fully isolated AWS environment. Share only what you want. Your agent, your space.';

  @override
  String get onboardingSafeByDesignCheck1 =>
      'Fully separated cloud environment';

  @override
  String get onboardingSafeByDesignCheck2 =>
      'You control what your agent accesses';

  @override
  String get onboardingSafeByDesignCheck3 =>
      'Independent computing, not shared';

  @override
  String get commonLogout => 'Logout';

  @override
  String get onboardingFullFeaturesTitle =>
      '100% ClawBox.\nEvery feature included.';

  @override
  String get onboardingFullFeaturesSubtitle =>
      'Everything your computer can do, Atlas can do for you:';

  @override
  String get onboardingFullFeaturesExample1 =>
      '“Check my emails and draft replies for the ones that need attention”';

  @override
  String get onboardingFullFeaturesExample2 =>
      '“Reorder the milk I bought last time on Amazon”';

  @override
  String get onboardingFullFeaturesExample3 =>
      '“Plan a 5-night Vegas trip — flights, hotels — and email me the itinerary”';

  @override
  String get onboardingFullFeaturesTagline =>
      'No limits. No learning curve. Just results.';

  @override
  String get newPaywallTitle => 'Unlock your agent\'s full power';

  @override
  String get newPaywallSubtitle =>
      'Everything is set up. Start using your agent now.';

  @override
  String get newPaywallBenefit1 => 'Dedicated cloud computer — 24/7';

  @override
  String get newPaywallBenefit2 => '400+ AI models — unlimited';

  @override
  String get newPaywallBenefit3 => '100+ AgentSkills — ready to use';

  @override
  String get newPaywallFaqPriceQuestion => 'Why this price?';

  @override
  String get newPaywallFaqPriceAnswer =>
      'We allocate a dedicated cloud computer just for you — running 24/7, with unlimited access to 400+ AI models. This is the real cost of a personal AI agent that actually works.';

  @override
  String get newPaywallFaqCheaperQuestion => 'What about cheaper alternatives?';

  @override
  String get newPaywallFaqCheaperAnswer =>
      'A real dedicated environment with real AI model access requires real infrastructure. We don\'t cut corners — your agent runs on its own isolated cloud, not shared resources.';

  @override
  String get newPaywallPeriodWeek => '/ week';

  @override
  String get newPaywallPeriodMonth => '/ month';

  @override
  String get newPaywallBestValueBadge => 'BEST VALUE';

  @override
  String get newPaywallStartNowButton => 'Start Now';

  @override
  String get newPaywallRestorePurchase => 'Restore Purchase';

  @override
  String get newPaywallHaveReferralCode => 'Have a referral code?';

  @override
  String get newPaywallSocialProof => '200,000+ agents deployed';

  @override
  String get newPaywallReferralSheetTitle => 'Enter Referral Code';

  @override
  String get newPaywallReferralHint => 'e.g. FRIEND2024';

  @override
  String get newPaywallReferralApplyButton => 'Apply';

  @override
  String get newPaywallReferralAppliedSuccess => 'Referral code applied!';

  @override
  String get newPaywallReferralInvalid => 'Invalid referral code';

  @override
  String get userProfileTitle => 'Tell us about yourself';

  @override
  String get userProfileSubtitle => 'So your agent knows who it\'s working for';

  @override
  String get userProfileNameLabel => 'Your Name';

  @override
  String get userProfileNameHint => 'Peter Steinberger';

  @override
  String get userProfileCallNameLabel => 'What should we call you?';

  @override
  String get userProfileCallNameHint => 'Peter';

  @override
  String get taskSelectionTitle => 'What should your agent do?';

  @override
  String get taskSelectionSubtitle => 'Select at least 1';

  @override
  String get taskOptionEmailManagement => 'Email Management';

  @override
  String get taskOptionWebResearch => 'Web Research';

  @override
  String get taskOptionTaskAutomation => 'Task Automation';

  @override
  String get taskOptionScheduling => 'Scheduling';

  @override
  String get taskOptionSocialMedia => 'Social Media';

  @override
  String get taskOptionWriting => 'Writing';

  @override
  String get taskOptionDataAnalysis => 'Data Analysis';

  @override
  String get taskOptionSmartHome => 'Smart Home';

  @override
  String get vibeSelectionTitle => 'Set your agent\'s vibe';

  @override
  String get vibeSelectionSubtitle => 'How should your agent communicate?';

  @override
  String get vibeNameCasual => 'Casual';

  @override
  String get vibeDescCasual =>
      'Relaxed and friendly. Like texting a smart friend.';

  @override
  String get vibeNameProfessional => 'Professional';

  @override
  String get vibeDescProfessional =>
      'Clear and structured. Business-ready communication.';

  @override
  String get vibeNameFriendly => 'Friendly';

  @override
  String get vibeDescFriendly =>
      'Warm and encouraging. Always positive and helpful.';

  @override
  String get vibeNameDirect => 'Direct';

  @override
  String get vibeDescDirect =>
      'Straight to the point. No fluff, maximum efficiency.';

  @override
  String get agentCreationTitle => 'Create your agent';

  @override
  String get agentCreationSubtitle =>
      'Choose a look and personality for your agent';

  @override
  String get agentCreationNameLabel => 'Agent Name';

  @override
  String get agentCreationNameHint => 'Atlas';

  @override
  String get agentCreationCreatureLabel => 'Creature Type';

  @override
  String get agentCreationEmojiLabel => 'Agent Emoji';

  @override
  String get creatureCat => 'Cat';

  @override
  String get creatureDragon => 'Dragon';

  @override
  String get creatureFox => 'Fox';

  @override
  String get creatureOwl => 'Owl';

  @override
  String get creatureRabbit => 'Rabbit';

  @override
  String get creatureBear => 'Bear';

  @override
  String get creatureDino => 'Dino';

  @override
  String get creaturePenguin => 'Penguin';

  @override
  String get creaturePerson => 'Person';

  @override
  String get creatureWolf => 'Wolf';

  @override
  String get creaturePanda => 'Panda';

  @override
  String get creatureUnicorn => 'Unicorn';

  @override
  String get commonFallbackFriend => 'friend';

  @override
  String get commonFallbackYourAgent => 'your agent';

  @override
  String get fakeLoadingStep1 => 'Profile configured';

  @override
  String get fakeLoadingStep2 => 'personality set';

  @override
  String get fakeLoadingStep3 => 'Deploying to cloud...';

  @override
  String get fakeLoadingStep4 => 'Connecting 400+ AI models';

  @override
  String get fakeLoadingStep5 => 'Allocating computing resources';

  @override
  String get fakeLoadingStep6 => 'Loading 100+ AgentSkills';

  @override
  String get fakeLoadingStep7 => 'Configuring agent workspace';

  @override
  String fakeLoadingTitle(String callName) {
    return 'Hey $callName, hang tight...';
  }

  @override
  String get fakeLoadingSubtitle =>
      'We\'re setting up your agent in the cloud.\nYour personal agent is almost ready.';

  @override
  String get agentCompleteSubtitle =>
      'Your agent is fully deployed and optimized for your tasks.';

  @override
  String get agentCompleteStatus1 => '24/7 Agent — always on';

  @override
  String get agentCompleteStatus2 => '400+ AI Models — connected';

  @override
  String get agentCompleteStatus3 => '100+ AgentSkills — loaded';

  @override
  String get agentCompleteStatus4 => 'Computing Resources — secured';

  @override
  String agentCompleteTitle(String agentName, String callName) {
    return '$agentName is ready, $callName!';
  }

  @override
  String get agentCompleteOptimizedForLabel => 'OPTIMIZED FOR';

  @override
  String agentCompleteLiveHint(String agentName) {
    return '$agentName is live and waiting for you';
  }
}
