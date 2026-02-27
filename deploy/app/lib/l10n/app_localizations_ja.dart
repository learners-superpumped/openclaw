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
  String get startingInstanceDesc =>
      'インスタンスを起動しています。\n通常4〜5分かかります。\n他の作業をしてから戻っても大丈夫です。';

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

  @override
  String get chatTitle => 'ClawBox AI';

  @override
  String get statusOnline => 'オンライン';

  @override
  String get statusConnecting => '接続中...';

  @override
  String get statusOffline => 'オフライン';

  @override
  String get statusAuthenticating => '認証中...';

  @override
  String get statusWaitingForConnection => '接続を待っています...';

  @override
  String get emptyChatTitle => '何かお手伝いできますか？';

  @override
  String get emptyChatSubtitle => 'プロジェクトについて何でも聞いてください';

  @override
  String get dateToday => '今日';

  @override
  String get dateYesterday => '昨日';

  @override
  String get connectionError => '接続エラー';

  @override
  String get reconnect => '再接続';

  @override
  String get typeMessage => 'メッセージを入力...';

  @override
  String get sessions => 'セッション';

  @override
  String get newSession => '新しいセッション';

  @override
  String get noSessionsYet => 'セッションはまだありません';

  @override
  String get timeNow => '今';

  @override
  String timeMinutes(int minutes) {
    return '$minutes分';
  }

  @override
  String timeHours(int hours) {
    return '$hours時間';
  }

  @override
  String timeDays(int days) {
    return '$days日';
  }

  @override
  String get skills => 'スキル';

  @override
  String get allSkills => 'すべて';

  @override
  String get searchSkills => 'スキルを検索...';

  @override
  String get installed => 'インストール済み';

  @override
  String get install => 'インストール';

  @override
  String get uninstall => 'アンインストール';

  @override
  String get installing => 'インストール中...';

  @override
  String get uninstalling => 'アンインストール中...';

  @override
  String get installSuccess => 'スキルがインストールされました';

  @override
  String get uninstallSuccess => 'スキルがアンインストールされました';

  @override
  String get installFailed => 'スキルのインストールに失敗しました';

  @override
  String get uninstallFailed => 'スキルのアンインストールに失敗しました';

  @override
  String get noSkillsFound => 'スキルが見つかりません';

  @override
  String get version => 'バージョン';

  @override
  String get author => '作者';

  @override
  String get uninstallConfirmTitle => 'スキルをアンインストールしますか？';

  @override
  String get uninstallConfirmMessage => 'このスキルはインスタンスから削除されます。';

  @override
  String get aiDataProcessing => 'AIデータ処理';

  @override
  String get aiDataSharing => 'AIデータ共有';

  @override
  String get aiDataProviders => 'AIデータプロバイダー';

  @override
  String get requestDataDeletion => 'データ削除リクエスト';

  @override
  String get aiConsentDataSentTitle => 'AIサービスに送信されるデータ';

  @override
  String get aiConsentDataSentMessages => 'チャットで送信するテキストメッセージ';

  @override
  String get aiConsentDataSentImages => '画像添付ファイル（JPEG、PNG、GIF、WebP）';

  @override
  String get aiConsentDataSentContext => 'AI応答のための会話コンテキスト';

  @override
  String get aiConsentRecipientsTitle => 'データ受信者';

  @override
  String get aiConsentRecipientOpenRouter => 'OpenRouter（AIリクエストルーティング）';

  @override
  String get aiConsentRecipientProviders =>
      'OpenAI、Anthropic、Google（AIモデルプロバイダー）';

  @override
  String get aiConsentUsageTitle => 'データの使用方法';

  @override
  String get aiConsentUsageResponses => 'AI応答の生成にのみ使用';

  @override
  String get aiConsentUsageNoTraining => 'AIモデルのトレーニングには使用されません';

  @override
  String get aiConsentUsageDeletion => 'アカウント削除時に削除';

  @override
  String get aiConsentViewPrivacy => 'プライバシーポリシーを見る';

  @override
  String get revokeAiConsentTitle => 'AIデータの同意を撤回しますか？';

  @override
  String get revokeAiConsentMessage => 'チャット機能を使用するには再度同意が必要です。';

  @override
  String get revoke => '撤回';

  @override
  String get aiDataProvidersTitle => 'AIサービスプロバイダー';

  @override
  String get aiDataProvidersDesc => 'お客様のデータは以下のサードパーティAIサービスによって処理される場合があります：';

  @override
  String get aiDisclosureAgree => '同意して続ける';

  @override
  String get aiConsentRequired => 'このサービスを利用するにはAIデータの同意が必要です。';

  @override
  String get connectingBot => 'Telegramボットに接続中...';

  @override
  String get connectingBotDesc => 'ボットに接続しています。\n通常数秒で完了します。';

  @override
  String get botRestarting => 'ボットを再起動中...';

  @override
  String get botRestartingDesc => '新しい設定でボットを再起動しています。\n通常数秒で完了します。';

  @override
  String get pendingPairingCodes => '保留中のペアリングコード';

  @override
  String get noPendingCodes => 'Telegramボットにメッセージを送ると、ペアリングコードがここに表示されます。';

  @override
  String get tapToApprove => 'タップして承認';

  @override
  String get pairingApproved => 'ペアリングが承認されました！';

  @override
  String get dismiss => '無視';

  @override
  String get paywallTitle => 'AIアシスタントを有効化';

  @override
  String get paywallFeature1 => 'Telegramであなた専用のAIアシスタント';

  @override
  String get paywallFeature2 => 'いつでもチャット、即座に返信';

  @override
  String get paywallFeature3 => 'ワンタップ設定、数分で準備完了';

  @override
  String get paywallReview =>
      'Telegramでボットにメッセージを送るだけで、すぐに答えが返ってきます。ポケットの中のパーソナルアシスタントみたいです。';

  @override
  String get paywallReviewAuthor => 'Alex K';

  @override
  String get subscribe => '購読する';

  @override
  String get cancelAnytime => 'いつでもキャンセル可能';

  @override
  String get restore => '復元';

  @override
  String get restorePurchases => '購入を復元';

  @override
  String get weekly => '週間';

  @override
  String get monthly => '月間';

  @override
  String get annual => '年間';

  @override
  String get lifetime => '永久';

  @override
  String savePercent(int percent) {
    return '$percent%お得';
  }

  @override
  String get channels => 'チャンネル';

  @override
  String get channelsDesc => 'メッセージングチャンネルの管理';

  @override
  String get channelConnected => '接続済み';

  @override
  String get channelDisconnected => '未接続';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get connectWhatsApp => 'WhatsAppを接続';

  @override
  String get generateQrCode => 'QRコードを再生成';

  @override
  String get scanQrCode => 'WhatsAppでQRコードをスキャン';

  @override
  String get waitingForScan => 'スキャン待機中...';

  @override
  String get disconnectChannel => '切断';

  @override
  String get disconnectConfirmTitle => 'チャンネルを切断しますか？';

  @override
  String get disconnectConfirmMessage => 'このチャンネルが切断されます。後で再接続できます。';

  @override
  String pendingCount(int count) {
    return '$count件保留中';
  }

  @override
  String channelsSummary(int connected) {
    return '$connected件接続済み';
  }

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscord => 'Discordを接続';

  @override
  String get discordBotToken => 'Discord ボットトークン';

  @override
  String get connect => '接続';

  @override
  String get copiedToClipboard => 'クリップボードにコピーしました';

  @override
  String get pasteImage => '画像を貼り付け';

  @override
  String get messageQueued => '待機中のメッセージはありません';

  @override
  String get messagesInQueue => '待機中のメッセージ';

  @override
  String get removeFromQueue => 'キューから削除';

  @override
  String get sessionSettings => 'セッション設定';

  @override
  String get reasoningLevel => '推論レベル';

  @override
  String get thinkingMode => '思考モード';

  @override
  String get verboseLevel => '詳細レベル';

  @override
  String get deleteSession => 'セッション削除';

  @override
  String get deleteSessionConfirm => 'このセッションと履歴が完全に削除されます。この操作は元に戻せません。';

  @override
  String get newMessagesBelow => '新しいメッセージ';

  @override
  String get focusMode => 'フォーカスモード';

  @override
  String get exitFocusMode => 'フォーカスモードを終了';

  @override
  String get compactingContext => 'コンテキストを圧縮中...';

  @override
  String get contextCompacted => 'コンテキストが圧縮されました';

  @override
  String get showingLastMessages => '最新';

  @override
  String get messagesHidden => '非表示:';

  @override
  String get largeMessageWarning => '長いメッセージ';

  @override
  String get largeMessagePlaintext => '長いメッセージはプレーンテキストで表示されます';

  @override
  String get reasoningLow => '低';

  @override
  String get reasoningMedium => '中';

  @override
  String get reasoningHigh => '高';

  @override
  String get editSessionLabel => 'セッションラベル';

  @override
  String get discordBotSetup => 'Discordボット設定';

  @override
  String get discordBotSetupDesc => 'Discord Developer Portalでボットを作成してください。';

  @override
  String get stepCreateApp => 'Discord Developer Portalでアプリケーションを作成';

  @override
  String get stepAddBot => 'Botタブでボットを追加';

  @override
  String get stepEnableIntents =>
      'Privileged IntentsでMessage Content Intentを有効化';

  @override
  String get stepCopyToken => 'ボットトークンをコピーして下に入力';

  @override
  String get connectingDiscordBot => 'Discordボットに接続中...';

  @override
  String get connectingDiscordBotDesc => 'ボットに接続しています。\n通常数秒で完了します。';

  @override
  String get discordBotRestarting => 'ボットを再起動中...';

  @override
  String get discordBotRestartingDesc => '新しい設定でボットを再起動しています。\n通常数秒で完了します。';

  @override
  String get discordNoPendingCodes => 'DiscordボットにDMを送ると、ペアリングコードがここに表示されます。';

  @override
  String get discordPairing => 'Discordペアリング';

  @override
  String get discordPairingDesc => 'ボットにDMを送ると表示される認証コードを入力してください。';

  @override
  String get webAccess => 'Webアクセス';

  @override
  String get webAccessPreparing => 'Webアクセスを準備中...';

  @override
  String get webAccessPreparingHint => 'SSLの設定に15分以上かかる場合があります';

  @override
  String get gatewayNetwork => 'ネットワーク';

  @override
  String get gatewayCertificate => '証明書';

  @override
  String get remoteView => 'リモート画面';

  @override
  String get remoteViewDescription => 'エージェントの画面をリアルタイムで表示';

  @override
  String get vncConnecting => '接続中...';

  @override
  String get vncConnected => '接続済み';

  @override
  String get vncDisconnected => '切断';

  @override
  String get vncError => '接続エラー';

  @override
  String get aiUsage => 'AI使用量';

  @override
  String get resetsWeekly => '毎週リセット';

  @override
  String get resetsMonthly => '毎月リセット';

  @override
  String get resetsDaily => '毎日リセット';

  @override
  String get orDivider => 'または';

  @override
  String get viewOnWeb => 'ClawHubで見る';

  @override
  String get defaultModel => 'デフォルトモデル';

  @override
  String get searchModels => 'モデルを検索...';

  @override
  String get noModelsFound => 'モデルが見つかりません';

  @override
  String get gatewayRestartNotice => 'モデルが変更されました。ゲートウェイを再起動しています...';

  @override
  String get changeDefaultModelError => 'デフォルトモデルの変更に失敗しました';

  @override
  String get commonContinue => '続ける';

  @override
  String get onboardingBadgeTopApp => '#1 OpenClawアプリ';

  @override
  String get onboardingWelcomeTitle => 'あなたのAIエージェント。\n60秒で準備完了。';

  @override
  String get onboardingWelcomeSubtitle => 'セットアップ不要。APIキー不要。技術スキル不要。';

  @override
  String get onboardingGithubStarsBadge => 'GitHub Stars 20万以上';

  @override
  String get onboardingPoweredByModels => '400以上のAIモデルを搭載';

  @override
  String get onboardingQuoteSamAltman =>
      '“非常にスマートなエージェントの未来について素晴らしいアイデアを持つ天才”';

  @override
  String get onboardingQuoteSamAltmanAttribution => '— Sam Altman、OpenAI CEO';

  @override
  String get onboardingGithubStarCount => '200,000+';

  @override
  String get onboardingGithubStarsLabel => 'GitHub Stars';

  @override
  String get onboardingGithubFastestGrowing => 'GitHub史上最速で成長したプロジェクト';

  @override
  String get onboardingGithubStarsSingleDay => '1日で25,310スターを獲得';

  @override
  String get onboardingTweetsSectionTitle => 'AI＆テック業界のリーダーが信頼';

  @override
  String get onboardingEasySetupTitle => '60秒でセットアップ完了。\n専門知識は不要。';

  @override
  String get onboardingEasySetupSubtitle => '技術的な知識は一切不要です。残りはすべてお任せください。';

  @override
  String get onboardingEasySetupNoApiKeys => 'APIキー不要';

  @override
  String get onboardingEasySetupNoTerminal => 'ターミナルやコマンドライン不要';

  @override
  String get onboardingEasySetupNoServer => 'Mac Miniやサーバー不要';

  @override
  String get onboardingEasySetupNoTechKnowledge => '技術知識不要';

  @override
  String get onboardingSafeByDesignTitle => '設計から安全。\nあなたのデータ、あなたのルール。';

  @override
  String get onboardingSafeByDesignPressQuote =>
      '“ClawBoxはAIセンセーション、しかしセキュリティはまだ改善途上”';

  @override
  String get onboardingSafeByDesignSubtitle =>
      'エージェントは完全に分離されたAWS環境で実行されます。共有する内容はあなたが選択。あなたのエージェント、あなたの空間。';

  @override
  String get onboardingSafeByDesignCheck1 => '完全に分離されたクラウド環境';

  @override
  String get onboardingSafeByDesignCheck2 => 'エージェントのアクセス権限を自分で管理';

  @override
  String get onboardingSafeByDesignCheck3 => '独立したコンピューティング、共有なし';

  @override
  String get commonLogout => 'ログアウト';

  @override
  String get onboardingFullFeaturesTitle => '100% ClawBox。\nすべての機能を搭載。';

  @override
  String get onboardingFullFeaturesSubtitle =>
      'あなたのパソコンができることすべて、Atlasがあなたの代わりにやります：';

  @override
  String get onboardingFullFeaturesExample1 =>
      '“メールをチェックして、対応が必要なものに返信の下書きを作成して”';

  @override
  String get onboardingFullFeaturesExample2 => '“前回Amazonで買った牛乳を再注文して”';

  @override
  String get onboardingFullFeaturesExample3 =>
      '“ラスベガス5泊の旅行を計画して — 航空券、ホテル — 旅程をメールで送って”';

  @override
  String get onboardingFullFeaturesTagline => '制限なし。学習曲線なし。結果だけ。';

  @override
  String get newPaywallTitle => 'エージェントのフルパワーを解放';

  @override
  String get newPaywallSubtitle => 'すべての準備が完了しました。今すぐエージェントを使い始めましょう。';

  @override
  String get newPaywallBenefit1 => '専用クラウドコンピューター — 24時間年中無休';

  @override
  String get newPaywallBenefit2 => '400以上のAIモデル — 無制限';

  @override
  String get newPaywallBenefit3 => '100以上のAgentSkills — すぐに使える';

  @override
  String get newPaywallFaqPriceQuestion => 'なぜこの価格？';

  @override
  String get newPaywallFaqPriceAnswer =>
      'あなた専用のクラウドコンピューターを24時間年中無休で稼働させ、400以上のAIモデルに無制限でアクセスできます。これが実際に機能するパーソナルAIエージェントの実際のコストです。';

  @override
  String get newPaywallFaqCheaperQuestion => 'もっと安い代替手段は？';

  @override
  String get newPaywallFaqCheaperAnswer =>
      '実際のAIモデルアクセスを備えた専用環境には、実際のインフラが必要です。妥協はしません — あなたのエージェントは共有リソースではなく、独立した専用クラウドで実行されます。';

  @override
  String get newPaywallPeriodWeek => '/ 週';

  @override
  String get newPaywallPeriodMonth => '/ 月';

  @override
  String get newPaywallBestValueBadge => '最もお得';

  @override
  String get newPaywallStartNowButton => '今すぐ開始';

  @override
  String get newPaywallRestorePurchase => '購入を復元';

  @override
  String get newPaywallHaveReferralCode => '紹介コードをお持ちですか？';

  @override
  String get newPaywallSocialProof => '200,000以上のエージェントがデプロイ済み';

  @override
  String get newPaywallReferralSheetTitle => '紹介コード入力';

  @override
  String get newPaywallReferralHint => '例: FRIEND2024';

  @override
  String get newPaywallReferralApplyButton => '適用';

  @override
  String get newPaywallReferralAppliedSuccess => '紹介コードが適用されました！';

  @override
  String get newPaywallReferralInvalid => '無効な紹介コード';

  @override
  String get userProfileTitle => 'あなたについて教えてください';

  @override
  String get userProfileSubtitle => 'エージェントが誰のために働いているか分かるように';

  @override
  String get userProfileNameLabel => 'お名前';

  @override
  String get userProfileNameHint => '山田太郎';

  @override
  String get userProfileCallNameLabel => 'なんとお呼びしますか？';

  @override
  String get userProfileCallNameHint => '太郎';

  @override
  String get taskSelectionTitle => 'エージェントに何をさせますか？';

  @override
  String get taskSelectionSubtitle => '最低1つ選択';

  @override
  String get taskOptionEmailManagement => 'メール管理';

  @override
  String get taskOptionWebResearch => 'ウェブリサーチ';

  @override
  String get taskOptionTaskAutomation => 'タスク自動化';

  @override
  String get taskOptionScheduling => 'スケジュール管理';

  @override
  String get taskOptionSocialMedia => 'ソーシャルメディア';

  @override
  String get taskOptionWriting => 'ライティング';

  @override
  String get taskOptionDataAnalysis => 'データ分析';

  @override
  String get taskOptionSmartHome => 'スマートホーム';

  @override
  String get vibeSelectionTitle => 'エージェントの雰囲気を設定';

  @override
  String get vibeSelectionSubtitle => 'エージェントにどうコミュニケーションしてほしいですか？';

  @override
  String get vibeNameCasual => 'カジュアル';

  @override
  String get vibeDescCasual => 'リラックスしてフレンドリー。賢い友達にテキストするように。';

  @override
  String get vibeNameProfessional => 'プロフェッショナル';

  @override
  String get vibeDescProfessional => '明確で体系的。ビジネスに適したコミュニケーション。';

  @override
  String get vibeNameFriendly => 'フレンドリー';

  @override
  String get vibeDescFriendly => '温かく励ましてくれる。いつもポジティブで役に立つ。';

  @override
  String get vibeNameDirect => 'ダイレクト';

  @override
  String get vibeDescDirect => '要点を端的に。無駄なし、最大効率。';

  @override
  String get agentCreationTitle => 'エージェントを作成';

  @override
  String get agentCreationSubtitle => 'エージェントの外見と性格を選択';

  @override
  String get agentCreationNameLabel => 'エージェント名';

  @override
  String get agentCreationNameHint => 'Atlas';

  @override
  String get agentCreationCreatureLabel => 'キャラクタータイプ';

  @override
  String get agentCreationEmojiLabel => 'エージェント絵文字';

  @override
  String get creatureCat => 'ネコ';

  @override
  String get creatureDragon => 'ドラゴン';

  @override
  String get creatureFox => 'キツネ';

  @override
  String get creatureOwl => 'フクロウ';

  @override
  String get creatureRabbit => 'ウサギ';

  @override
  String get creatureBear => 'クマ';

  @override
  String get creatureDino => '恐竜';

  @override
  String get creaturePenguin => 'ペンギン';

  @override
  String get creaturePerson => '人';

  @override
  String get creatureWolf => 'オオカミ';

  @override
  String get creaturePanda => 'パンダ';

  @override
  String get creatureUnicorn => 'ユニコーン';

  @override
  String get commonFallbackFriend => '友達';

  @override
  String get commonFallbackYourAgent => 'エージェント';

  @override
  String get fakeLoadingStep1 => 'プロフィール設定完了';

  @override
  String get fakeLoadingStep2 => 'パーソナリティ設定完了';

  @override
  String get fakeLoadingStep3 => 'クラウドにデプロイ中...';

  @override
  String get fakeLoadingStep4 => '400以上のAIモデルを接続';

  @override
  String get fakeLoadingStep5 => 'コンピューティングリソースを割り当て';

  @override
  String get fakeLoadingStep6 => '100以上のAgentSkillsをロード';

  @override
  String get fakeLoadingStep7 => 'エージェントワークスペースを構成';

  @override
  String fakeLoadingTitle(String callName) {
    return 'Hey $callName、しばらくお待ちください...';
  }

  @override
  String get fakeLoadingSubtitle =>
      'クラウドでエージェントを設定しています。\nパーソナルエージェントの準備がほぼ完了しました。';

  @override
  String get agentCompleteSubtitle => 'エージェントは完全にデプロイされ、タスクに最適化されています。';

  @override
  String get agentCompleteStatus1 => '24時間エージェント — 常時稼働';

  @override
  String get agentCompleteStatus2 => '400以上のAIモデル — 接続済み';

  @override
  String get agentCompleteStatus3 => '100以上のAgentSkills — ロード済み';

  @override
  String get agentCompleteStatus4 => 'コンピューティングリソース — 確保済み';

  @override
  String agentCompleteTitle(String agentName, String callName) {
    return '$agentNameの準備ができました、$callName！';
  }

  @override
  String get agentCompleteOptimizedForLabel => '最適化対象';

  @override
  String agentCompleteLiveHint(String agentName) {
    return '$agentNameは稼働中で、あなたを待っています';
  }
}
