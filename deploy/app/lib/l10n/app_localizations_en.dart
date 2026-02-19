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
}
