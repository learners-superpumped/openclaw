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
      'Your instance is starting up.\nThis usually takes 1-2 minutes.';

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
}
