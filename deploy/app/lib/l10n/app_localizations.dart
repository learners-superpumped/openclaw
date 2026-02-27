import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

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
    Locale('ko'),
    Locale('pt'),
    Locale('zh'),
  ];

  /// Login screen title
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Login screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Connect your account to start ClawBox'**
  String get loginSubtitle;

  /// Login error message
  ///
  /// In en, this message translates to:
  /// **'Login failed.'**
  String get loginFailed;

  /// Google sign-in button
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// Apple sign-in button
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// Instance card title
  ///
  /// In en, this message translates to:
  /// **'Instance'**
  String get instance;

  /// Instance running status
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get statusRunning;

  /// Instance waiting status
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get statusWaiting;

  /// ID label
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get labelId;

  /// Name label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get labelName;

  /// Telegram connected status
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get statusConnected;

  /// Telegram disconnected status
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get statusDisconnected;

  /// Bot label
  ///
  /// In en, this message translates to:
  /// **'Bot'**
  String get labelBot;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Subscription management title
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription'**
  String get manageSubscription;

  /// Subscription management description
  ///
  /// In en, this message translates to:
  /// **'Check and manage subscription status'**
  String get manageSubscriptionDesc;

  /// Recreate instance title
  ///
  /// In en, this message translates to:
  /// **'Recreate Instance'**
  String get recreateInstance;

  /// Recreate instance description
  ///
  /// In en, this message translates to:
  /// **'Reset all data and reconfigure'**
  String get recreateInstanceDesc;

  /// Logout button
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// Logout description
  ///
  /// In en, this message translates to:
  /// **'Sign out from account'**
  String get logoutDesc;

  /// Recreate confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'All data will be reset and reconfigured from scratch. This action cannot be undone.'**
  String get recreateConfirmMessage;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Recreate button
  ///
  /// In en, this message translates to:
  /// **'Recreate'**
  String get recreate;

  /// App tagline on paywall
  ///
  /// In en, this message translates to:
  /// **'Meet your AI assistant on a messenger'**
  String get tagline;

  /// Get started button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Already subscribed link
  ///
  /// In en, this message translates to:
  /// **'Already subscribed?'**
  String get alreadySubscribed;

  /// Instance creation error title
  ///
  /// In en, this message translates to:
  /// **'Failed to create instance'**
  String get instanceCreationFailed;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Please check your network connection and try again.'**
  String get checkNetworkAndRetry;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Creating instance status
  ///
  /// In en, this message translates to:
  /// **'Creating instance...'**
  String get creatingInstance;

  /// Setting up status
  ///
  /// In en, this message translates to:
  /// **'Setting up...'**
  String get settingUp;

  /// Preparing status
  ///
  /// In en, this message translates to:
  /// **'Preparing...'**
  String get preparing;

  /// Creating instance description
  ///
  /// In en, this message translates to:
  /// **'Creating your AI instance.\nPlease wait.'**
  String get creatingInstanceDesc;

  /// Starting instance description
  ///
  /// In en, this message translates to:
  /// **'Your instance is starting up.\nThis usually takes 4-5 minutes.\nFeel free to leave and come back later.'**
  String get startingInstanceDesc;

  /// Please wait message
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// Telegram setup screen title
  ///
  /// In en, this message translates to:
  /// **'Telegram Bot Setup'**
  String get telegramBotSetup;

  /// Telegram setup description
  ///
  /// In en, this message translates to:
  /// **'Create a bot via @BotFather on Telegram.'**
  String get telegramBotSetupDesc;

  /// Setup step 1
  ///
  /// In en, this message translates to:
  /// **'Search @BotFather on Telegram'**
  String get stepSearchBotFather;

  /// Setup step 2
  ///
  /// In en, this message translates to:
  /// **'Enter the /newbot command'**
  String get stepNewBot;

  /// Setup step 3
  ///
  /// In en, this message translates to:
  /// **'Set bot name and username'**
  String get stepSetBotName;

  /// Setup step 4
  ///
  /// In en, this message translates to:
  /// **'Enter the issued token below'**
  String get stepEnterToken;

  /// Bot token input hint
  ///
  /// In en, this message translates to:
  /// **'Enter bot token'**
  String get enterBotToken;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Bot token error message
  ///
  /// In en, this message translates to:
  /// **'Failed to set bot token. Please check your token.'**
  String get botTokenError;

  /// Telegram pairing screen title
  ///
  /// In en, this message translates to:
  /// **'Telegram Pairing'**
  String get telegramPairing;

  /// Telegram pairing description
  ///
  /// In en, this message translates to:
  /// **'Enter the auth code displayed when you message the bot.'**
  String get telegramPairingDesc;

  /// Auth code input hint
  ///
  /// In en, this message translates to:
  /// **'Auth Code'**
  String get authCode;

  /// Approve button
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// Pairing error message
  ///
  /// In en, this message translates to:
  /// **'Pairing failed. Please try again.'**
  String get pairingError;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Setup tab label / onboarding title
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get setup;

  /// Delete account tile title
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Delete account tile description
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account and all data'**
  String get deleteAccountDesc;

  /// Delete account confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get deleteAccountConfirmTitle;

  /// Delete account confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Your instance will be deleted and all data will be permanently lost. This action cannot be undone. You can create a new account after deletion.'**
  String get deleteAccountConfirmMessage;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Setup complete screen title
  ///
  /// In en, this message translates to:
  /// **'Setup Complete!'**
  String get setupCompleteTitle;

  /// Setup complete screen description
  ///
  /// In en, this message translates to:
  /// **'Send a message to your bot on Telegram and OpenClaw will reply. Start chatting now!'**
  String get setupCompleteDesc;

  /// Start chatting button
  ///
  /// In en, this message translates to:
  /// **'Start Chatting'**
  String get startChatting;

  /// Button to open bot on Telegram
  ///
  /// In en, this message translates to:
  /// **'Open @{botUsername}'**
  String openBotOnTelegram(String botUsername);

  /// Referral code link on paywall
  ///
  /// In en, this message translates to:
  /// **'Have a referral code?'**
  String get haveReferralCode;

  /// Referral code dialog title
  ///
  /// In en, this message translates to:
  /// **'Enter Referral Code'**
  String get enterReferralCode;

  /// Referral code input hint
  ///
  /// In en, this message translates to:
  /// **'Enter your code'**
  String get referralCodeHint;

  /// Invalid referral code error
  ///
  /// In en, this message translates to:
  /// **'Invalid referral code.'**
  String get referralCodeInvalid;

  /// Referral code success message
  ///
  /// In en, this message translates to:
  /// **'Referral code applied!'**
  String get referralCodeSuccess;

  /// Skip Telegram setup confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Skip Telegram Setup?'**
  String get skipTelegramTitle;

  /// Skip Telegram setup confirmation dialog description
  ///
  /// In en, this message translates to:
  /// **'You can connect later. Until connected, you can chat within the app.'**
  String get skipTelegramDesc;

  /// Skip button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Connect Telegram banner title
  ///
  /// In en, this message translates to:
  /// **'Connect Telegram'**
  String get connectTelegram;

  /// Connect Telegram banner description
  ///
  /// In en, this message translates to:
  /// **'Connect Telegram to chat on messenger too'**
  String get connectTelegramDesc;

  /// Log in button
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// Sign up button / screen title
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Sign up screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Create your account to start ClawBox'**
  String get signUpSubtitle;

  /// Email input label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password input label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Confirm password input label
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// Optional name input label
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get nameOptional;

  /// Divider text between email and social login
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// Link text to sign up screen
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Link text to login screen
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Email validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// Password length validation error
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// Password confirmation mismatch error
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Terms of Service link text
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Privacy Policy link text
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Terms agreement checkbox label
  ///
  /// In en, this message translates to:
  /// **'I agree to the {terms} and {privacy}'**
  String agreeToTerms(String terms, String privacy);

  /// Error when terms not agreed
  ///
  /// In en, this message translates to:
  /// **'You must agree to the Terms of Service and Privacy Policy'**
  String get mustAgreeToTerms;

  /// AI data consent dialog title
  ///
  /// In en, this message translates to:
  /// **'AI Data Sharing'**
  String get aiDataConsentTitle;

  /// AI data consent dialog message
  ///
  /// In en, this message translates to:
  /// **'Your messages and image attachments are sent to third-party AI services (via OpenRouter) to generate responses. Your data is not used for AI training. By continuing, you consent to this data processing.'**
  String get aiDataConsentMessage;

  /// Agree button
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get agree;

  /// Decline button
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// Legal section title
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// Legal notice on login screen
  ///
  /// In en, this message translates to:
  /// **'By signing in, you agree to our {terms} and {privacy}'**
  String bySigningIn(String terms, String privacy);

  /// General settings section header
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// Account settings section header
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Morning greeting on dashboard
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// Afternoon greeting on dashboard
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// Evening greeting on dashboard
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// Hero CTA title on dashboard
  ///
  /// In en, this message translates to:
  /// **'Chat with AI'**
  String get chatWithAI;

  /// Agent ready status text
  ///
  /// In en, this message translates to:
  /// **'Your agent is ready'**
  String get agentReady;

  /// Agent starting status text
  ///
  /// In en, this message translates to:
  /// **'Agent is starting up...'**
  String get agentStarting;

  /// Chat screen app bar title
  ///
  /// In en, this message translates to:
  /// **'ClawBox AI'**
  String get chatTitle;

  /// Chat connection online status
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get statusOnline;

  /// Chat connection connecting status
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get statusConnecting;

  /// Chat connection offline status
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get statusOffline;

  /// Chat connection authenticating status
  ///
  /// In en, this message translates to:
  /// **'Authenticating...'**
  String get statusAuthenticating;

  /// Chat connection waiting status
  ///
  /// In en, this message translates to:
  /// **'Waiting for connection...'**
  String get statusWaitingForConnection;

  /// Empty chat state title
  ///
  /// In en, this message translates to:
  /// **'How can I help you today?'**
  String get emptyChatTitle;

  /// Empty chat state subtitle
  ///
  /// In en, this message translates to:
  /// **'Ask me anything about your project'**
  String get emptyChatSubtitle;

  /// Date separator for today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// Date separator for yesterday
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateYesterday;

  /// Chat connection error title
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// Reconnect button label
  ///
  /// In en, this message translates to:
  /// **'Reconnect'**
  String get reconnect;

  /// Chat input placeholder text
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// Session drawer title
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// New session button tooltip
  ///
  /// In en, this message translates to:
  /// **'New session'**
  String get newSession;

  /// Empty session list message
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get noSessionsYet;

  /// Relative time label for just now
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get timeNow;

  /// Relative time in minutes
  ///
  /// In en, this message translates to:
  /// **'{minutes}m'**
  String timeMinutes(int minutes);

  /// Relative time in hours
  ///
  /// In en, this message translates to:
  /// **'{hours}h'**
  String timeHours(int hours);

  /// Relative time in days
  ///
  /// In en, this message translates to:
  /// **'{days}d'**
  String timeDays(int days);

  /// Skills tab label
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skills;

  /// All skills filter label
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allSkills;

  /// Skills search field hint
  ///
  /// In en, this message translates to:
  /// **'Search skills...'**
  String get searchSkills;

  /// Skill installed badge
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get installed;

  /// Install skill button
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get install;

  /// Uninstall skill button
  ///
  /// In en, this message translates to:
  /// **'Uninstall'**
  String get uninstall;

  /// Skill installing status
  ///
  /// In en, this message translates to:
  /// **'Installing...'**
  String get installing;

  /// Skill uninstalling status
  ///
  /// In en, this message translates to:
  /// **'Uninstalling...'**
  String get uninstalling;

  /// Skill install success message
  ///
  /// In en, this message translates to:
  /// **'Skill installed successfully'**
  String get installSuccess;

  /// Skill uninstall success message
  ///
  /// In en, this message translates to:
  /// **'Skill uninstalled'**
  String get uninstallSuccess;

  /// Skill install failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to install skill'**
  String get installFailed;

  /// Skill uninstall failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to uninstall skill'**
  String get uninstallFailed;

  /// Empty skills list message
  ///
  /// In en, this message translates to:
  /// **'No skills found'**
  String get noSkillsFound;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Author label
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// Uninstall confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Uninstall Skill?'**
  String get uninstallConfirmTitle;

  /// Uninstall confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'This skill will be removed from your instance.'**
  String get uninstallConfirmMessage;

  /// AI data processing section header
  ///
  /// In en, this message translates to:
  /// **'AI Data Processing'**
  String get aiDataProcessing;

  /// AI data sharing toggle title
  ///
  /// In en, this message translates to:
  /// **'AI Data Sharing'**
  String get aiDataSharing;

  /// AI data providers settings item
  ///
  /// In en, this message translates to:
  /// **'AI Data Providers'**
  String get aiDataProviders;

  /// Request data deletion settings item
  ///
  /// In en, this message translates to:
  /// **'Request Data Deletion'**
  String get requestDataDeletion;

  /// Consent data sent section title
  ///
  /// In en, this message translates to:
  /// **'Data Sent to AI Services'**
  String get aiConsentDataSentTitle;

  /// Consent data sent - messages
  ///
  /// In en, this message translates to:
  /// **'Text messages you send in chat'**
  String get aiConsentDataSentMessages;

  /// Consent data sent - images
  ///
  /// In en, this message translates to:
  /// **'Image attachments (JPEG, PNG, GIF, WebP)'**
  String get aiConsentDataSentImages;

  /// Consent data sent - context
  ///
  /// In en, this message translates to:
  /// **'Conversation context for AI responses'**
  String get aiConsentDataSentContext;

  /// Consent recipients section title
  ///
  /// In en, this message translates to:
  /// **'Data Recipients'**
  String get aiConsentRecipientsTitle;

  /// Consent recipient - OpenRouter
  ///
  /// In en, this message translates to:
  /// **'OpenRouter (AI request routing)'**
  String get aiConsentRecipientOpenRouter;

  /// Consent recipient - providers
  ///
  /// In en, this message translates to:
  /// **'OpenAI, Anthropic, Google (AI model providers)'**
  String get aiConsentRecipientProviders;

  /// Consent usage section title
  ///
  /// In en, this message translates to:
  /// **'How Your Data Is Used'**
  String get aiConsentUsageTitle;

  /// Consent usage - responses
  ///
  /// In en, this message translates to:
  /// **'Used solely to generate AI responses'**
  String get aiConsentUsageResponses;

  /// Consent usage - no training
  ///
  /// In en, this message translates to:
  /// **'Not used for AI model training'**
  String get aiConsentUsageNoTraining;

  /// Consent usage - deletion
  ///
  /// In en, this message translates to:
  /// **'Deleted when you delete your account'**
  String get aiConsentUsageDeletion;

  /// View privacy policy link
  ///
  /// In en, this message translates to:
  /// **'View Privacy Policy'**
  String get aiConsentViewPrivacy;

  /// Revoke consent confirmation title
  ///
  /// In en, this message translates to:
  /// **'Revoke AI Data Consent?'**
  String get revokeAiConsentTitle;

  /// Revoke consent confirmation message
  ///
  /// In en, this message translates to:
  /// **'You will need to agree again before using the chat feature.'**
  String get revokeAiConsentMessage;

  /// Revoke button
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get revoke;

  /// AI providers bottom sheet title
  ///
  /// In en, this message translates to:
  /// **'AI Service Providers'**
  String get aiDataProvidersTitle;

  /// AI providers bottom sheet description
  ///
  /// In en, this message translates to:
  /// **'Your data may be processed by the following third-party AI services:'**
  String get aiDataProvidersDesc;

  /// AI disclosure agree button
  ///
  /// In en, this message translates to:
  /// **'Agree & Continue'**
  String get aiDisclosureAgree;

  /// Consent required snackbar message
  ///
  /// In en, this message translates to:
  /// **'AI data consent is required to use this service.'**
  String get aiConsentRequired;

  /// Bot connection loading title
  ///
  /// In en, this message translates to:
  /// **'Connecting your Telegram bot...'**
  String get connectingBot;

  /// Bot connection loading description
  ///
  /// In en, this message translates to:
  /// **'Please wait while we connect to your bot.\nThis usually takes a few seconds.'**
  String get connectingBotDesc;

  /// Bot restarting loading title
  ///
  /// In en, this message translates to:
  /// **'Restarting your bot...'**
  String get botRestarting;

  /// Bot restarting loading description
  ///
  /// In en, this message translates to:
  /// **'Your bot is restarting with the new configuration.\nThis usually takes a few seconds.'**
  String get botRestartingDesc;

  /// Pending pairing codes section header
  ///
  /// In en, this message translates to:
  /// **'Pending Pairing Codes'**
  String get pendingPairingCodes;

  /// Empty pending codes hint
  ///
  /// In en, this message translates to:
  /// **'Send a message to your Telegram bot and the pairing code will appear here.'**
  String get noPendingCodes;

  /// Tap to approve hint on pairing code card
  ///
  /// In en, this message translates to:
  /// **'Tap to approve'**
  String get tapToApprove;

  /// Pairing approved success snackbar
  ///
  /// In en, this message translates to:
  /// **'Pairing approved successfully!'**
  String get pairingApproved;

  /// Dismiss button tooltip
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// Web paywall title
  ///
  /// In en, this message translates to:
  /// **'Unlock Your AI Assistant'**
  String get paywallTitle;

  /// Web paywall feature 1
  ///
  /// In en, this message translates to:
  /// **'Your personal AI assistant on Telegram'**
  String get paywallFeature1;

  /// Web paywall feature 2
  ///
  /// In en, this message translates to:
  /// **'Chat anytime, get instant replies'**
  String get paywallFeature2;

  /// Web paywall feature 3
  ///
  /// In en, this message translates to:
  /// **'One-tap setup, ready in minutes'**
  String get paywallFeature3;

  /// Web paywall user review
  ///
  /// In en, this message translates to:
  /// **'I just message my bot on Telegram and get answers instantly. It\'s like having a personal assistant in my pocket.'**
  String get paywallReview;

  /// Web paywall review author
  ///
  /// In en, this message translates to:
  /// **'Alex K'**
  String get paywallReviewAuthor;

  /// Subscribe button
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// Cancel anytime notice
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime'**
  String get cancelAnytime;

  /// Restore purchases button
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// Restore purchases footer link
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// Weekly plan label
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// Monthly plan label
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// Annual plan label
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get annual;

  /// Lifetime plan label
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get lifetime;

  /// Savings percentage badge
  ///
  /// In en, this message translates to:
  /// **'Save {percent}%'**
  String savePercent(int percent);

  /// Channels screen title
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get channels;

  /// Channels description
  ///
  /// In en, this message translates to:
  /// **'Manage your messaging channels'**
  String get channelsDesc;

  /// Channel connected status
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get channelConnected;

  /// Channel disconnected status
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get channelDisconnected;

  /// WhatsApp channel name
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// Connect WhatsApp button
  ///
  /// In en, this message translates to:
  /// **'Connect WhatsApp'**
  String get connectWhatsApp;

  /// Regenerate QR code button
  ///
  /// In en, this message translates to:
  /// **'Regenerate QR Code'**
  String get generateQrCode;

  /// QR code scan instruction
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code with WhatsApp'**
  String get scanQrCode;

  /// Waiting for QR scan status
  ///
  /// In en, this message translates to:
  /// **'Waiting for scan...'**
  String get waitingForScan;

  /// Disconnect channel button
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnectChannel;

  /// Disconnect confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Disconnect Channel?'**
  String get disconnectConfirmTitle;

  /// Disconnect confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'This channel will be disconnected. You can reconnect it later.'**
  String get disconnectConfirmMessage;

  /// Pending pairing count badge
  ///
  /// In en, this message translates to:
  /// **'{count} pending'**
  String pendingCount(int count);

  /// Channels summary on dashboard
  ///
  /// In en, this message translates to:
  /// **'{connected} connected'**
  String channelsSummary(int connected);

  /// Discord channel name
  ///
  /// In en, this message translates to:
  /// **'Discord'**
  String get discord;

  /// Connect Discord button
  ///
  /// In en, this message translates to:
  /// **'Connect Discord'**
  String get connectDiscord;

  /// Discord bot token dialog title
  ///
  /// In en, this message translates to:
  /// **'Discord Bot Token'**
  String get discordBotToken;

  /// Connect button
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// Snackbar after copy action
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// Paste image button tooltip
  ///
  /// In en, this message translates to:
  /// **'Paste image'**
  String get pasteImage;

  /// Empty queue message
  ///
  /// In en, this message translates to:
  /// **'No queued messages'**
  String get messageQueued;

  /// Queue indicator label
  ///
  /// In en, this message translates to:
  /// **'Messages in queue'**
  String get messagesInQueue;

  /// Remove queued message action
  ///
  /// In en, this message translates to:
  /// **'Remove from queue'**
  String get removeFromQueue;

  /// Session config sheet title
  ///
  /// In en, this message translates to:
  /// **'Session Settings'**
  String get sessionSettings;

  /// Reasoning level selector label
  ///
  /// In en, this message translates to:
  /// **'Reasoning Level'**
  String get reasoningLevel;

  /// Thinking toggle label
  ///
  /// In en, this message translates to:
  /// **'Thinking Mode'**
  String get thinkingMode;

  /// Verbose level selector label
  ///
  /// In en, this message translates to:
  /// **'Verbose Level'**
  String get verboseLevel;

  /// Delete session button
  ///
  /// In en, this message translates to:
  /// **'Delete Session'**
  String get deleteSession;

  /// Delete session confirmation message
  ///
  /// In en, this message translates to:
  /// **'This session and its history will be permanently deleted. This action cannot be undone.'**
  String get deleteSessionConfirm;

  /// New messages FAB label
  ///
  /// In en, this message translates to:
  /// **'New messages'**
  String get newMessagesBelow;

  /// Focus mode toggle label
  ///
  /// In en, this message translates to:
  /// **'Focus Mode'**
  String get focusMode;

  /// Exit focus mode label
  ///
  /// In en, this message translates to:
  /// **'Exit Focus Mode'**
  String get exitFocusMode;

  /// Compaction indicator text
  ///
  /// In en, this message translates to:
  /// **'Compacting context...'**
  String get compactingContext;

  /// Compaction complete toast
  ///
  /// In en, this message translates to:
  /// **'Context compacted'**
  String get contextCompacted;

  /// History pagination showing prefix
  ///
  /// In en, this message translates to:
  /// **'Showing last'**
  String get showingLastMessages;

  /// History pagination hidden suffix
  ///
  /// In en, this message translates to:
  /// **'hidden:'**
  String get messagesHidden;

  /// Large message confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Large message'**
  String get largeMessageWarning;

  /// Large message plaintext banner
  ///
  /// In en, this message translates to:
  /// **'Large message displayed as plain text'**
  String get largeMessagePlaintext;

  /// Low reasoning level
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get reasoningLow;

  /// Medium reasoning level
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get reasoningMedium;

  /// High reasoning level
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get reasoningHigh;

  /// Edit session label field title
  ///
  /// In en, this message translates to:
  /// **'Session label'**
  String get editSessionLabel;

  /// Discord setup screen title
  ///
  /// In en, this message translates to:
  /// **'Discord Bot Setup'**
  String get discordBotSetup;

  /// Discord setup description
  ///
  /// In en, this message translates to:
  /// **'Create a bot in the Discord Developer Portal.'**
  String get discordBotSetupDesc;

  /// Discord setup step 1
  ///
  /// In en, this message translates to:
  /// **'Go to Discord Developer Portal and create an application'**
  String get stepCreateApp;

  /// Discord setup step 2
  ///
  /// In en, this message translates to:
  /// **'Go to Bot tab and add a bot'**
  String get stepAddBot;

  /// Discord setup step 3
  ///
  /// In en, this message translates to:
  /// **'Enable Message Content Intent under Privileged Intents'**
  String get stepEnableIntents;

  /// Discord setup step 4
  ///
  /// In en, this message translates to:
  /// **'Copy the bot token and enter it below'**
  String get stepCopyToken;

  /// Discord bot connection loading title
  ///
  /// In en, this message translates to:
  /// **'Connecting your Discord bot...'**
  String get connectingDiscordBot;

  /// Discord bot connection loading description
  ///
  /// In en, this message translates to:
  /// **'Please wait while we connect to your bot.\nThis usually takes a few seconds.'**
  String get connectingDiscordBotDesc;

  /// Discord bot restarting loading title
  ///
  /// In en, this message translates to:
  /// **'Restarting your bot...'**
  String get discordBotRestarting;

  /// Discord bot restarting loading description
  ///
  /// In en, this message translates to:
  /// **'Your bot is restarting with the new configuration.\nThis usually takes a few seconds.'**
  String get discordBotRestartingDesc;

  /// Discord empty pending codes hint
  ///
  /// In en, this message translates to:
  /// **'Send a DM to your Discord bot and the pairing code will appear here.'**
  String get discordNoPendingCodes;

  /// Discord pairing screen title
  ///
  /// In en, this message translates to:
  /// **'Discord Pairing'**
  String get discordPairing;

  /// Discord pairing description
  ///
  /// In en, this message translates to:
  /// **'Enter the auth code displayed when you DM the bot.'**
  String get discordPairingDesc;

  /// Web access section title on dashboard
  ///
  /// In en, this message translates to:
  /// **'Web Access'**
  String get webAccess;

  /// Web access preparing status
  ///
  /// In en, this message translates to:
  /// **'Preparing web access...'**
  String get webAccessPreparing;

  /// Hint about SSL setup time during web access preparation
  ///
  /// In en, this message translates to:
  /// **'SSL setup can take 15 minutes or more'**
  String get webAccessPreparingHint;

  /// Ingress status label
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get gatewayNetwork;

  /// Certificate status label
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get gatewayCertificate;

  /// Remote view card title
  ///
  /// In en, this message translates to:
  /// **'Remote View'**
  String get remoteView;

  /// Remote view card description
  ///
  /// In en, this message translates to:
  /// **'Watch agent screen in real-time'**
  String get remoteViewDescription;

  /// VNC connecting status
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get vncConnecting;

  /// VNC connected status
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get vncConnected;

  /// VNC disconnected status
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get vncDisconnected;

  /// VNC connection error
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get vncError;

  /// AI usage card title
  ///
  /// In en, this message translates to:
  /// **'AI Usage'**
  String get aiUsage;

  /// Weekly reset label
  ///
  /// In en, this message translates to:
  /// **'Resets weekly'**
  String get resetsWeekly;

  /// Monthly reset label
  ///
  /// In en, this message translates to:
  /// **'Resets monthly'**
  String get resetsMonthly;

  /// Daily reset label
  ///
  /// In en, this message translates to:
  /// **'Resets daily'**
  String get resetsDaily;

  /// Divider text between primary and secondary actions
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orDivider;

  /// View on ClawHub button on skill detail
  ///
  /// In en, this message translates to:
  /// **'View on ClawHub'**
  String get viewOnWeb;

  /// Label for default AI model setting
  ///
  /// In en, this message translates to:
  /// **'Default Model'**
  String get defaultModel;

  /// Placeholder for model search field
  ///
  /// In en, this message translates to:
  /// **'Search models...'**
  String get searchModels;

  /// Empty state when no models match search
  ///
  /// In en, this message translates to:
  /// **'No models found'**
  String get noModelsFound;

  /// Snackbar after changing default model
  ///
  /// In en, this message translates to:
  /// **'Model changed. Gateway is restarting...'**
  String get gatewayRestartNotice;

  /// Error snackbar when model change fails
  ///
  /// In en, this message translates to:
  /// **'Failed to change default model'**
  String get changeDefaultModelError;

  /// Common continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// Onboarding badge text
  ///
  /// In en, this message translates to:
  /// **'#1 OpenClaw App'**
  String get onboardingBadgeTopApp;

  /// Welcome landing hero title
  ///
  /// In en, this message translates to:
  /// **'Your AI agent.\nReady in 60 seconds.'**
  String get onboardingWelcomeTitle;

  /// Welcome landing subtitle
  ///
  /// In en, this message translates to:
  /// **'No setup. No API keys. No tech skills.'**
  String get onboardingWelcomeSubtitle;

  /// Welcome landing GitHub stars badge
  ///
  /// In en, this message translates to:
  /// **'200K+ GitHub Stars'**
  String get onboardingGithubStarsBadge;

  /// Welcome landing powered by text
  ///
  /// In en, this message translates to:
  /// **'Powered by 400+ AI models'**
  String get onboardingPoweredByModels;

  /// Sam Altman quote on welcome landing
  ///
  /// In en, this message translates to:
  /// **'“A genius with amazing ideas about the future of very smart agents”'**
  String get onboardingQuoteSamAltman;

  /// Sam Altman quote attribution
  ///
  /// In en, this message translates to:
  /// **'— Sam Altman, CEO of OpenAI'**
  String get onboardingQuoteSamAltmanAttribution;

  /// GitHub star count number
  ///
  /// In en, this message translates to:
  /// **'200,000+'**
  String get onboardingGithubStarCount;

  /// GitHub Stars label
  ///
  /// In en, this message translates to:
  /// **'GitHub Stars'**
  String get onboardingGithubStarsLabel;

  /// GitHub fastest growing text
  ///
  /// In en, this message translates to:
  /// **'The fastest-growing project in GitHub history'**
  String get onboardingGithubFastestGrowing;

  /// GitHub stars single day record
  ///
  /// In en, this message translates to:
  /// **'25,310 stars in a single day'**
  String get onboardingGithubStarsSingleDay;

  /// Tweets screen section title
  ///
  /// In en, this message translates to:
  /// **'Trusted by leaders in AI & tech'**
  String get onboardingTweetsSectionTitle;

  /// Easy setup screen title
  ///
  /// In en, this message translates to:
  /// **'Setup in 60 seconds.\nNo expertise needed.'**
  String get onboardingEasySetupTitle;

  /// Easy setup screen subtitle
  ///
  /// In en, this message translates to:
  /// **'You don\'t need to know anything technical. We handle all the rest.'**
  String get onboardingEasySetupSubtitle;

  /// Easy setup no API keys item
  ///
  /// In en, this message translates to:
  /// **'No API keys required'**
  String get onboardingEasySetupNoApiKeys;

  /// Easy setup no terminal item
  ///
  /// In en, this message translates to:
  /// **'No terminal or command line'**
  String get onboardingEasySetupNoTerminal;

  /// Easy setup no server item
  ///
  /// In en, this message translates to:
  /// **'No Mac Mini or server'**
  String get onboardingEasySetupNoServer;

  /// Easy setup no tech knowledge item
  ///
  /// In en, this message translates to:
  /// **'No technical knowledge'**
  String get onboardingEasySetupNoTechKnowledge;

  /// Safe by design screen title
  ///
  /// In en, this message translates to:
  /// **'Safe by design.\nYour data, your rules.'**
  String get onboardingSafeByDesignTitle;

  /// Safe by design Bloomberg press quote
  ///
  /// In en, this message translates to:
  /// **'“ClawBox’s an AI Sensation, But Its Security a Work in Progress”'**
  String get onboardingSafeByDesignPressQuote;

  /// Safe by design subtitle
  ///
  /// In en, this message translates to:
  /// **'Your agent runs in a fully isolated AWS environment. Share only what you want. Your agent, your space.'**
  String get onboardingSafeByDesignSubtitle;

  /// Safe by design check item 1
  ///
  /// In en, this message translates to:
  /// **'Fully separated cloud environment'**
  String get onboardingSafeByDesignCheck1;

  /// Safe by design check item 2
  ///
  /// In en, this message translates to:
  /// **'You control what your agent accesses'**
  String get onboardingSafeByDesignCheck2;

  /// Safe by design check item 3
  ///
  /// In en, this message translates to:
  /// **'Independent computing, not shared'**
  String get onboardingSafeByDesignCheck3;

  /// Common logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get commonLogout;

  /// Full features screen title
  ///
  /// In en, this message translates to:
  /// **'100% ClawBox.\nEvery feature included.'**
  String get onboardingFullFeaturesTitle;

  /// Full features screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Everything your computer can do, Atlas can do for you:'**
  String get onboardingFullFeaturesSubtitle;

  /// Full features example 1
  ///
  /// In en, this message translates to:
  /// **'“Check my emails and draft replies for the ones that need attention”'**
  String get onboardingFullFeaturesExample1;

  /// Full features example 2
  ///
  /// In en, this message translates to:
  /// **'“Reorder the milk I bought last time on Amazon”'**
  String get onboardingFullFeaturesExample2;

  /// Full features example 3
  ///
  /// In en, this message translates to:
  /// **'“Plan a 5-night Vegas trip — flights, hotels — and email me the itinerary”'**
  String get onboardingFullFeaturesExample3;

  /// Full features tagline
  ///
  /// In en, this message translates to:
  /// **'No limits. No learning curve. Just results.'**
  String get onboardingFullFeaturesTagline;

  /// New paywall screen title
  ///
  /// In en, this message translates to:
  /// **'Unlock your agent\'s full power'**
  String get newPaywallTitle;

  /// New paywall screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Everything is set up. Start using your agent now.'**
  String get newPaywallSubtitle;

  /// New paywall benefit 1
  ///
  /// In en, this message translates to:
  /// **'Dedicated cloud computer — 24/7'**
  String get newPaywallBenefit1;

  /// New paywall benefit 2
  ///
  /// In en, this message translates to:
  /// **'400+ AI models — unlimited'**
  String get newPaywallBenefit2;

  /// New paywall benefit 3
  ///
  /// In en, this message translates to:
  /// **'100+ AgentSkills — ready to use'**
  String get newPaywallBenefit3;

  /// New paywall FAQ price question
  ///
  /// In en, this message translates to:
  /// **'Why this price?'**
  String get newPaywallFaqPriceQuestion;

  /// New paywall FAQ price answer
  ///
  /// In en, this message translates to:
  /// **'We allocate a dedicated cloud computer just for you — running 24/7, with unlimited access to 400+ AI models. This is the real cost of a personal AI agent that actually works.'**
  String get newPaywallFaqPriceAnswer;

  /// New paywall FAQ cheaper question
  ///
  /// In en, this message translates to:
  /// **'What about cheaper alternatives?'**
  String get newPaywallFaqCheaperQuestion;

  /// New paywall FAQ cheaper answer
  ///
  /// In en, this message translates to:
  /// **'A real dedicated environment with real AI model access requires real infrastructure. We don\'t cut corners — your agent runs on its own isolated cloud, not shared resources.'**
  String get newPaywallFaqCheaperAnswer;

  /// New paywall weekly period label
  ///
  /// In en, this message translates to:
  /// **'/ week'**
  String get newPaywallPeriodWeek;

  /// New paywall monthly period label
  ///
  /// In en, this message translates to:
  /// **'/ month'**
  String get newPaywallPeriodMonth;

  /// New paywall best value badge
  ///
  /// In en, this message translates to:
  /// **'BEST VALUE'**
  String get newPaywallBestValueBadge;

  /// New paywall start now button
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get newPaywallStartNowButton;

  /// New paywall restore purchase link
  ///
  /// In en, this message translates to:
  /// **'Restore Purchase'**
  String get newPaywallRestorePurchase;

  /// New paywall referral code link
  ///
  /// In en, this message translates to:
  /// **'Have a referral code?'**
  String get newPaywallHaveReferralCode;

  /// New paywall social proof text
  ///
  /// In en, this message translates to:
  /// **'200,000+ agents deployed'**
  String get newPaywallSocialProof;

  /// Referral code bottom sheet title
  ///
  /// In en, this message translates to:
  /// **'Enter Referral Code'**
  String get newPaywallReferralSheetTitle;

  /// Referral code input hint
  ///
  /// In en, this message translates to:
  /// **'e.g. FRIEND2024'**
  String get newPaywallReferralHint;

  /// Referral code apply button
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get newPaywallReferralApplyButton;

  /// Referral code applied success message
  ///
  /// In en, this message translates to:
  /// **'Referral code applied!'**
  String get newPaywallReferralAppliedSuccess;

  /// Invalid referral code error message
  ///
  /// In en, this message translates to:
  /// **'Invalid referral code'**
  String get newPaywallReferralInvalid;

  /// User profile screen title
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get userProfileTitle;

  /// User profile screen subtitle
  ///
  /// In en, this message translates to:
  /// **'So your agent knows who it\'s working for'**
  String get userProfileSubtitle;

  /// User profile name field label
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get userProfileNameLabel;

  /// User profile name field hint
  ///
  /// In en, this message translates to:
  /// **'Peter Steinberger'**
  String get userProfileNameHint;

  /// User profile call name field label
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get userProfileCallNameLabel;

  /// User profile call name field hint
  ///
  /// In en, this message translates to:
  /// **'Peter'**
  String get userProfileCallNameHint;

  /// Task selection screen title
  ///
  /// In en, this message translates to:
  /// **'What should your agent do?'**
  String get taskSelectionTitle;

  /// Task selection screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Select at least 1'**
  String get taskSelectionSubtitle;

  /// Task option: Email Management
  ///
  /// In en, this message translates to:
  /// **'Email Management'**
  String get taskOptionEmailManagement;

  /// Task option: Web Research
  ///
  /// In en, this message translates to:
  /// **'Web Research'**
  String get taskOptionWebResearch;

  /// Task option: Task Automation
  ///
  /// In en, this message translates to:
  /// **'Task Automation'**
  String get taskOptionTaskAutomation;

  /// Task option: Scheduling
  ///
  /// In en, this message translates to:
  /// **'Scheduling'**
  String get taskOptionScheduling;

  /// Task option: Social Media
  ///
  /// In en, this message translates to:
  /// **'Social Media'**
  String get taskOptionSocialMedia;

  /// Task option: Writing
  ///
  /// In en, this message translates to:
  /// **'Writing'**
  String get taskOptionWriting;

  /// Task option: Data Analysis
  ///
  /// In en, this message translates to:
  /// **'Data Analysis'**
  String get taskOptionDataAnalysis;

  /// Task option: Smart Home
  ///
  /// In en, this message translates to:
  /// **'Smart Home'**
  String get taskOptionSmartHome;

  /// Vibe selection screen title
  ///
  /// In en, this message translates to:
  /// **'Set your agent\'s vibe'**
  String get vibeSelectionTitle;

  /// Vibe selection screen subtitle
  ///
  /// In en, this message translates to:
  /// **'How should your agent communicate?'**
  String get vibeSelectionSubtitle;

  /// Vibe option: Casual name
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get vibeNameCasual;

  /// Vibe option: Casual description
  ///
  /// In en, this message translates to:
  /// **'Relaxed and friendly. Like texting a smart friend.'**
  String get vibeDescCasual;

  /// Vibe option: Professional name
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get vibeNameProfessional;

  /// Vibe option: Professional description
  ///
  /// In en, this message translates to:
  /// **'Clear and structured. Business-ready communication.'**
  String get vibeDescProfessional;

  /// Vibe option: Friendly name
  ///
  /// In en, this message translates to:
  /// **'Friendly'**
  String get vibeNameFriendly;

  /// Vibe option: Friendly description
  ///
  /// In en, this message translates to:
  /// **'Warm and encouraging. Always positive and helpful.'**
  String get vibeDescFriendly;

  /// Vibe option: Direct name
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get vibeNameDirect;

  /// Vibe option: Direct description
  ///
  /// In en, this message translates to:
  /// **'Straight to the point. No fluff, maximum efficiency.'**
  String get vibeDescDirect;

  /// Agent creation screen title
  ///
  /// In en, this message translates to:
  /// **'Create your agent'**
  String get agentCreationTitle;

  /// Agent creation screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Choose a look and personality for your agent'**
  String get agentCreationSubtitle;

  /// Agent creation name label
  ///
  /// In en, this message translates to:
  /// **'Agent Name'**
  String get agentCreationNameLabel;

  /// Agent creation name hint
  ///
  /// In en, this message translates to:
  /// **'Atlas'**
  String get agentCreationNameHint;

  /// Agent creation creature type label
  ///
  /// In en, this message translates to:
  /// **'Creature Type'**
  String get agentCreationCreatureLabel;

  /// Agent creation emoji label
  ///
  /// In en, this message translates to:
  /// **'Agent Emoji'**
  String get agentCreationEmojiLabel;

  /// Creature name: cat
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get creatureCat;

  /// Creature name: dragon
  ///
  /// In en, this message translates to:
  /// **'Dragon'**
  String get creatureDragon;

  /// Creature name: fox
  ///
  /// In en, this message translates to:
  /// **'Fox'**
  String get creatureFox;

  /// Creature name: owl
  ///
  /// In en, this message translates to:
  /// **'Owl'**
  String get creatureOwl;

  /// Creature name: rabbit
  ///
  /// In en, this message translates to:
  /// **'Rabbit'**
  String get creatureRabbit;

  /// Creature name: bear
  ///
  /// In en, this message translates to:
  /// **'Bear'**
  String get creatureBear;

  /// Creature name: dino
  ///
  /// In en, this message translates to:
  /// **'Dino'**
  String get creatureDino;

  /// Creature name: penguin
  ///
  /// In en, this message translates to:
  /// **'Penguin'**
  String get creaturePenguin;

  /// Creature name: person
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get creaturePerson;

  /// Creature name: wolf
  ///
  /// In en, this message translates to:
  /// **'Wolf'**
  String get creatureWolf;

  /// Creature name: panda
  ///
  /// In en, this message translates to:
  /// **'Panda'**
  String get creaturePanda;

  /// Creature name: unicorn
  ///
  /// In en, this message translates to:
  /// **'Unicorn'**
  String get creatureUnicorn;

  /// Fallback call name
  ///
  /// In en, this message translates to:
  /// **'friend'**
  String get commonFallbackFriend;

  /// Fallback agent name
  ///
  /// In en, this message translates to:
  /// **'your agent'**
  String get commonFallbackYourAgent;

  /// Fake loading step 1
  ///
  /// In en, this message translates to:
  /// **'Profile configured'**
  String get fakeLoadingStep1;

  /// Fake loading step 2
  ///
  /// In en, this message translates to:
  /// **'personality set'**
  String get fakeLoadingStep2;

  /// Fake loading step 3
  ///
  /// In en, this message translates to:
  /// **'Deploying to cloud...'**
  String get fakeLoadingStep3;

  /// Fake loading step 4
  ///
  /// In en, this message translates to:
  /// **'Connecting 400+ AI models'**
  String get fakeLoadingStep4;

  /// Fake loading step 5
  ///
  /// In en, this message translates to:
  /// **'Allocating computing resources'**
  String get fakeLoadingStep5;

  /// Fake loading step 6
  ///
  /// In en, this message translates to:
  /// **'Loading 100+ AgentSkills'**
  String get fakeLoadingStep6;

  /// Fake loading step 7
  ///
  /// In en, this message translates to:
  /// **'Configuring agent workspace'**
  String get fakeLoadingStep7;

  /// Fake loading screen title with user name
  ///
  /// In en, this message translates to:
  /// **'Hey {callName}, hang tight...'**
  String fakeLoadingTitle(String callName);

  /// Fake loading screen subtitle
  ///
  /// In en, this message translates to:
  /// **'We\'re setting up your agent in the cloud.\nYour personal agent is almost ready.'**
  String get fakeLoadingSubtitle;

  /// Agent complete screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Your agent is fully deployed and optimized for your tasks.'**
  String get agentCompleteSubtitle;

  /// Agent complete status 1
  ///
  /// In en, this message translates to:
  /// **'24/7 Agent — always on'**
  String get agentCompleteStatus1;

  /// Agent complete status 2
  ///
  /// In en, this message translates to:
  /// **'400+ AI Models — connected'**
  String get agentCompleteStatus2;

  /// Agent complete status 3
  ///
  /// In en, this message translates to:
  /// **'100+ AgentSkills — loaded'**
  String get agentCompleteStatus3;

  /// Agent complete status 4
  ///
  /// In en, this message translates to:
  /// **'Computing Resources — secured'**
  String get agentCompleteStatus4;

  /// Agent complete screen title
  ///
  /// In en, this message translates to:
  /// **'{agentName} is ready, {callName}!'**
  String agentCompleteTitle(String agentName, String callName);

  /// Agent complete optimized for label
  ///
  /// In en, this message translates to:
  /// **'OPTIMIZED FOR'**
  String get agentCompleteOptimizedForLabel;

  /// Agent complete live hint with agent name
  ///
  /// In en, this message translates to:
  /// **'{agentName} is live and waiting for you'**
  String agentCompleteLiveHint(String agentName);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'es',
    'fr',
    'ja',
    'ko',
    'pt',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
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
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
