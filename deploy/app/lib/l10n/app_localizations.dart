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
  /// **'Your instance is starting up.\nThis usually takes 1-2 minutes.'**
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
