// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get login => 'ログイン';

  @override
  String get loginSubtitle => 'アカウントを連携してClawBoxを始めましょう';

  @override
  String get loginFailed => 'ログインに失敗しました。';

  @override
  String get continueWithGoogle => 'Googleで続ける';

  @override
  String get continueWithApple => 'Appleで続ける';

  @override
  String get instance => 'インスタンス';

  @override
  String get statusRunning => '実行中';

  @override
  String get statusWaiting => '待機中';

  @override
  String get labelId => 'ID';

  @override
  String get labelName => '名前';

  @override
  String get statusConnected => '接続済み';

  @override
  String get statusDisconnected => '未接続';

  @override
  String get labelBot => 'ボット';

  @override
  String get settings => '設定';

  @override
  String get manageSubscription => 'サブスクリプション管理';

  @override
  String get manageSubscriptionDesc => 'サブスクリプション状況の確認と管理';

  @override
  String get recreateInstance => 'インスタンス再作成';

  @override
  String get recreateInstanceDesc => 'すべてのデータを初期化して再設定';

  @override
  String get logout => 'ログアウト';

  @override
  String get logoutDesc => 'アカウントからログアウト';

  @override
  String get recreateConfirmMessage =>
      'すべてのデータが初期化され、最初から再設定されます。この操作は元に戻せません。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get recreate => '再作成';

  @override
  String get tagline => 'AIアシスタントをメッセンジャーで体験しよう';

  @override
  String get getStarted => '始める';

  @override
  String get alreadySubscribed => 'すでにサブスクリプション中ですか？';

  @override
  String get instanceCreationFailed => 'インスタンスの作成に失敗しました';

  @override
  String get checkNetworkAndRetry => 'ネットワーク接続を確認して再試行してください。';

  @override
  String get retry => '再試行';

  @override
  String get creatingInstance => 'インスタンス作成中...';

  @override
  String get settingUp => '設定中...';

  @override
  String get preparing => '準備中...';

  @override
  String get creatingInstanceDesc => 'AIインスタンスを作成しています。\nしばらくお待ちください。';

  @override
  String get startingInstanceDesc => 'インスタンスを起動しています。\n通常1〜2分かかります。';

  @override
  String get pleaseWait => 'しばらくお待ちください...';

  @override
  String get telegramBotSetup => 'Telegramボット設定';

  @override
  String get telegramBotSetupDesc => 'Telegramで@BotFatherからボットを作成してください。';

  @override
  String get stepSearchBotFather => 'Telegramで@BotFatherを検索';

  @override
  String get stepNewBot => '/newbotコマンドを入力';

  @override
  String get stepSetBotName => 'ボット名とusernameを設定';

  @override
  String get stepEnterToken => '発行されたトークンを下に入力';

  @override
  String get enterBotToken => 'ボットトークンを入力してください';

  @override
  String get next => '次へ';

  @override
  String get botTokenError => 'ボットトークンの設定に失敗しました。トークンを確認してください。';

  @override
  String get telegramPairing => 'Telegramペアリング';

  @override
  String get telegramPairingDesc => 'ボットにメッセージを送ると表示される認証コードを入力してください。';

  @override
  String get authCode => '認証コード';

  @override
  String get approve => '承認';

  @override
  String get pairingError => 'ペアリングに失敗しました。もう一度お試しください。';

  @override
  String get home => 'ホーム';

  @override
  String get setup => '設定';

  @override
  String get deleteAccount => 'アカウント削除';

  @override
  String get deleteAccountDesc => 'アカウントとすべてのデータを完全に削除';

  @override
  String get deleteAccountConfirmTitle => 'アカウントを削除しますか？';

  @override
  String get deleteAccountConfirmMessage =>
      'インスタンスが削除され、すべてのデータが完全に失われます。この操作は元に戻せません。削除後に新しいアカウントを作成できます。';

  @override
  String get delete => '削除';

  @override
  String get setupCompleteTitle => 'セットアップ完了！';

  @override
  String get setupCompleteDesc =>
      'Telegramでボットにメッセージを送ると、OpenClawが返答します。今すぐ会話を始めましょう！';

  @override
  String get startChatting => 'チャットを始める';

  @override
  String openBotOnTelegram(String botUsername) {
    return '@$botUsername を開く';
  }

  @override
  String get haveReferralCode => '紹介コードをお持ちですか？';

  @override
  String get enterReferralCode => '紹介コード入力';

  @override
  String get referralCodeHint => 'コードを入力してください';

  @override
  String get referralCodeInvalid => '無効な紹介コードです。';

  @override
  String get referralCodeSuccess => '紹介コードが適用されました！';

  @override
  String get skipTelegramTitle => 'Telegram設定をスキップしますか？';

  @override
  String get skipTelegramDesc => '後から接続できます。接続するまではアプリ内でチャットできます。';

  @override
  String get skip => 'スキップ';

  @override
  String get connectTelegram => 'Telegramを接続';

  @override
  String get connectTelegramDesc => 'Telegramを接続するとメッセンジャーでもチャットできます';

  @override
  String get logIn => 'ログイン';

  @override
  String get signUp => '新規登録';

  @override
  String get signUpSubtitle => 'アカウントを作成してClawBoxを始めましょう';

  @override
  String get email => 'メールアドレス';

  @override
  String get password => 'パスワード';

  @override
  String get confirmPassword => 'パスワード確認';

  @override
  String get nameOptional => '名前（任意）';

  @override
  String get or => 'または';

  @override
  String get dontHaveAccount => 'アカウントをお持ちでないですか？';

  @override
  String get alreadyHaveAccount => 'すでにアカウントをお持ちですか？';

  @override
  String get invalidEmail => '有効なメールアドレスを入力してください';

  @override
  String get passwordTooShort => 'パスワードは8文字以上にしてください';

  @override
  String get passwordsDoNotMatch => 'パスワードが一致しません';

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
  String get goodMorning => 'おはようございます';

  @override
  String get goodAfternoon => 'こんにちは';

  @override
  String get goodEvening => 'こんばんは';

  @override
  String get chatWithAI => 'AIとチャット';

  @override
  String get agentReady => 'エージェントの準備ができました';

  @override
  String get agentStarting => 'エージェントを起動中...';
}
