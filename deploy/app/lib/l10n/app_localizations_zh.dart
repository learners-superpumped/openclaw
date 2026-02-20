// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get login => '登录';

  @override
  String get loginSubtitle => '连接您的账户以开始使用ClawBox';

  @override
  String get loginFailed => '登录失败。';

  @override
  String get continueWithGoogle => '使用Google继续';

  @override
  String get continueWithApple => '使用Apple继续';

  @override
  String get instance => '实例';

  @override
  String get statusRunning => '运行中';

  @override
  String get statusWaiting => '等待中';

  @override
  String get labelId => 'ID';

  @override
  String get labelName => '名称';

  @override
  String get statusConnected => '已连接';

  @override
  String get statusDisconnected => '未连接';

  @override
  String get labelBot => '机器人';

  @override
  String get settings => '设置';

  @override
  String get manageSubscription => '管理订阅';

  @override
  String get manageSubscriptionDesc => '查看和管理订阅状态';

  @override
  String get recreateInstance => '重新创建实例';

  @override
  String get recreateInstanceDesc => '重置所有数据并重新配置';

  @override
  String get logout => '退出登录';

  @override
  String get logoutDesc => '退出当前账户';

  @override
  String get recreateConfirmMessage => '所有数据将被重置并从头开始重新配置。此操作无法撤消。';

  @override
  String get cancel => '取消';

  @override
  String get recreate => '重新创建';

  @override
  String get tagline => '在即时通讯中体验AI助手';

  @override
  String get getStarted => '开始使用';

  @override
  String get alreadySubscribed => '已经订阅了？';

  @override
  String get instanceCreationFailed => '实例创建失败';

  @override
  String get checkNetworkAndRetry => '请检查网络连接后重试。';

  @override
  String get retry => '重试';

  @override
  String get creatingInstance => '正在创建实例...';

  @override
  String get settingUp => '正在设置...';

  @override
  String get preparing => '准备中...';

  @override
  String get creatingInstanceDesc => '正在创建您的AI实例。\n请稍候。';

  @override
  String get startingInstanceDesc => '实例正在启动中。\n通常需要1-2分钟。';

  @override
  String get pleaseWait => '请稍候...';

  @override
  String get telegramBotSetup => 'Telegram机器人设置';

  @override
  String get telegramBotSetupDesc => '在Telegram中通过@BotFather创建机器人。';

  @override
  String get stepSearchBotFather => '在Telegram中搜索@BotFather';

  @override
  String get stepNewBot => '输入/newbot命令';

  @override
  String get stepSetBotName => '设置机器人名称和用户名';

  @override
  String get stepEnterToken => '在下方输入获取的令牌';

  @override
  String get enterBotToken => '请输入机器人令牌';

  @override
  String get next => '下一步';

  @override
  String get botTokenError => '机器人令牌设置失败。请检查令牌。';

  @override
  String get telegramPairing => 'Telegram配对';

  @override
  String get telegramPairingDesc => '输入向机器人发送消息后显示的验证码。';

  @override
  String get authCode => '验证码';

  @override
  String get approve => '确认';

  @override
  String get pairingError => '配对失败。请重试。';

  @override
  String get home => '首页';

  @override
  String get setup => '设置';

  @override
  String get deleteAccount => '删除账户';

  @override
  String get deleteAccountDesc => '永久删除您的账户和所有数据';

  @override
  String get deleteAccountConfirmTitle => '确定删除账户？';

  @override
  String get deleteAccountConfirmMessage =>
      '您的实例将被删除，所有数据将永久丢失。此操作无法撤消。删除后您可以创建新账户。';

  @override
  String get delete => '删除';

  @override
  String get setupCompleteTitle => '设置完成！';

  @override
  String get setupCompleteDesc => '在Telegram上给机器人发消息，OpenClaw会回复您。现在就开始对话吧！';

  @override
  String get startChatting => '开始对话';

  @override
  String openBotOnTelegram(String botUsername) {
    return '打开 @$botUsername';
  }

  @override
  String get haveReferralCode => '有推荐码？';

  @override
  String get enterReferralCode => '输入推荐码';

  @override
  String get referralCodeHint => '请输入您的码';

  @override
  String get referralCodeInvalid => '无效的推荐码。';

  @override
  String get referralCodeSuccess => '推荐码已应用！';

  @override
  String get skipTelegramTitle => '跳过Telegram设置？';

  @override
  String get skipTelegramDesc => '您可以稍后连接。连接之前，您可以在应用内聊天。';

  @override
  String get skip => '跳过';

  @override
  String get connectTelegram => '连接Telegram';

  @override
  String get connectTelegramDesc => '连接Telegram后也可以在即时通讯中聊天';

  @override
  String get logIn => '登录';

  @override
  String get signUp => '注册';

  @override
  String get signUpSubtitle => '创建账户以开始使用ClawBox';

  @override
  String get email => '电子邮箱';

  @override
  String get password => '密码';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get nameOptional => '姓名（可选）';

  @override
  String get or => '或';

  @override
  String get dontHaveAccount => '还没有账户？';

  @override
  String get alreadyHaveAccount => '已经有账户了？';

  @override
  String get invalidEmail => '请输入有效的电子邮箱';

  @override
  String get passwordTooShort => '密码至少需要8个字符';

  @override
  String get passwordsDoNotMatch => '密码不一致';

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
  String get goodMorning => '早上好';

  @override
  String get goodAfternoon => '下午好';

  @override
  String get goodEvening => '晚上好';

  @override
  String get chatWithAI => '与AI聊天';

  @override
  String get agentReady => '您的智能助手已就绪';

  @override
  String get agentStarting => '智能助手正在启动...';

  @override
  String get chatTitle => 'ClawBox AI';

  @override
  String get statusOnline => '在线';

  @override
  String get statusConnecting => '连接中...';

  @override
  String get statusOffline => '离线';

  @override
  String get statusAuthenticating => '认证中...';

  @override
  String get statusWaitingForConnection => '等待连接...';

  @override
  String get emptyChatTitle => '有什么我可以帮您的？';

  @override
  String get emptyChatSubtitle => '关于您的项目，随时提问';

  @override
  String get dateToday => '今天';

  @override
  String get dateYesterday => '昨天';

  @override
  String get connectionError => '连接错误';

  @override
  String get reconnect => '重新连接';

  @override
  String get typeMessage => '输入消息...';

  @override
  String get sessions => '会话';

  @override
  String get newSession => '新会话';

  @override
  String get noSessionsYet => '暂无会话';

  @override
  String get timeNow => '刚刚';

  @override
  String timeMinutes(int minutes) {
    return '$minutes分钟';
  }

  @override
  String timeHours(int hours) {
    return '$hours小时';
  }

  @override
  String timeDays(int days) {
    return '$days天';
  }

  @override
  String get skills => '技能';

  @override
  String get allSkills => '全部';

  @override
  String get searchSkills => '搜索技能...';

  @override
  String get installed => '已安装';

  @override
  String get install => '安装';

  @override
  String get uninstall => '卸载';

  @override
  String get installing => '安装中...';

  @override
  String get uninstalling => '卸载中...';

  @override
  String get installSuccess => '技能安装成功';

  @override
  String get uninstallSuccess => '技能已卸载';

  @override
  String get installFailed => '技能安装失败';

  @override
  String get uninstallFailed => '技能卸载失败';

  @override
  String get noSkillsFound => '未找到技能';

  @override
  String get version => '版本';

  @override
  String get author => '作者';

  @override
  String get uninstallConfirmTitle => '卸载技能？';

  @override
  String get uninstallConfirmMessage => '此技能将从您的实例中移除。';

  @override
  String get aiDataProcessing => 'AI数据处理';

  @override
  String get aiDataSharing => 'AI数据共享';

  @override
  String get aiDataProviders => 'AI数据提供商';

  @override
  String get requestDataDeletion => '请求删除数据';

  @override
  String get aiConsentDataSentTitle => '发送至AI服务的数据';

  @override
  String get aiConsentDataSentMessages => '您在聊天中发送的文字消息';

  @override
  String get aiConsentDataSentImages => '图片附件（JPEG、PNG、GIF、WebP）';

  @override
  String get aiConsentDataSentContext => '用于AI回复的对话上下文';

  @override
  String get aiConsentRecipientsTitle => '数据接收方';

  @override
  String get aiConsentRecipientOpenRouter => 'OpenRouter（AI请求路由）';

  @override
  String get aiConsentRecipientProviders => 'OpenAI、Anthropic、Google（AI模型提供商）';

  @override
  String get aiConsentUsageTitle => '数据使用方式';

  @override
  String get aiConsentUsageResponses => '仅用于生成AI回复';

  @override
  String get aiConsentUsageNoTraining => '不用于AI模型训练';

  @override
  String get aiConsentUsageDeletion => '删除账户时一并删除';

  @override
  String get aiConsentViewPrivacy => '查看隐私政策';

  @override
  String get revokeAiConsentTitle => '撤回AI数据同意？';

  @override
  String get revokeAiConsentMessage => '使用聊天功能前需要重新同意。';

  @override
  String get revoke => '撤回';

  @override
  String get aiDataProvidersTitle => 'AI服务提供商';

  @override
  String get aiDataProvidersDesc => '您的数据可能由以下第三方AI服务处理：';

  @override
  String get aiDisclosureAgree => '同意并继续';

  @override
  String get aiConsentRequired => '使用此服务需要同意AI数据处理。';

  @override
  String get connectingBot => '正在连接Telegram机器人...';

  @override
  String get connectingBotDesc => '正在连接您的机器人。\n通常只需几秒钟。';

  @override
  String get pendingPairingCodes => '待处理的配对码';

  @override
  String get noPendingCodes => '向Telegram机器人发送消息后，配对码将显示在此处。';

  @override
  String get tapToApprove => '点击以确认';

  @override
  String get pairingApproved => '配对已批准！';

  @override
  String get dismiss => '忽略';
}
