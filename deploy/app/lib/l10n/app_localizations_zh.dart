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
  String get startingInstanceDesc => '实例正在启动中。\n通常需要4-5分钟。\n您可以先做其他事情，稍后再回来。';

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
  String get botRestarting => '正在重启机器人...';

  @override
  String get botRestartingDesc => '正在使用新配置重启机器人。\n通常只需几秒钟。';

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

  @override
  String get paywallTitle => '解锁你的AI助手';

  @override
  String get paywallFeature1 => 'Telegram上的个人AI助手';

  @override
  String get paywallFeature2 => '随时聊天，即时回复';

  @override
  String get paywallFeature3 => '一键设置，几分钟即可就绪';

  @override
  String get paywallReview => '我只需在Telegram上给机器人发消息，就能立刻得到回答。就像口袋里有个私人助理一样。';

  @override
  String get paywallReviewAuthor => 'Alex K';

  @override
  String get subscribe => '订阅';

  @override
  String get cancelAnytime => '随时取消';

  @override
  String get restore => '恢复';

  @override
  String get restorePurchases => '恢复购买';

  @override
  String get weekly => '每周';

  @override
  String get monthly => '每月';

  @override
  String get annual => '每年';

  @override
  String get lifetime => '终身';

  @override
  String savePercent(int percent) {
    return '节省$percent%';
  }

  @override
  String get channels => '频道';

  @override
  String get channelsDesc => '管理您的消息频道';

  @override
  String get channelConnected => '已连接';

  @override
  String get channelDisconnected => '未连接';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get connectWhatsApp => '连接WhatsApp';

  @override
  String get generateQrCode => '重新生成二维码';

  @override
  String get scanQrCode => '使用WhatsApp扫描二维码';

  @override
  String get waitingForScan => '等待扫描...';

  @override
  String get disconnectChannel => '断开连接';

  @override
  String get disconnectConfirmTitle => '断开频道连接？';

  @override
  String get disconnectConfirmMessage => '此频道将被断开连接。您可以稍后重新连接。';

  @override
  String pendingCount(int count) {
    return '$count个待处理';
  }

  @override
  String channelsSummary(int connected) {
    return '$connected个已连接';
  }

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscord => '连接 Discord';

  @override
  String get discordBotToken => 'Discord 机器人令牌';

  @override
  String get connect => '连接';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get pasteImage => '粘贴图片';

  @override
  String get messageQueued => '没有排队消息';

  @override
  String get messagesInQueue => '排队中的消息';

  @override
  String get removeFromQueue => '从队列中移除';

  @override
  String get sessionSettings => '会话设置';

  @override
  String get reasoningLevel => '推理级别';

  @override
  String get thinkingMode => '思考模式';

  @override
  String get verboseLevel => '详细级别';

  @override
  String get deleteSession => '删除会话';

  @override
  String get deleteSessionConfirm => '此会话及其历史记录将被永久删除。此操作无法撤消。';

  @override
  String get newMessagesBelow => '新消息';

  @override
  String get focusMode => '专注模式';

  @override
  String get exitFocusMode => '退出专注模式';

  @override
  String get compactingContext => '正在压缩上下文...';

  @override
  String get contextCompacted => '上下文已压缩';

  @override
  String get showingLastMessages => '显示最近';

  @override
  String get messagesHidden => '已隐藏:';

  @override
  String get largeMessageWarning => '长消息';

  @override
  String get largeMessagePlaintext => '长消息以纯文本显示';

  @override
  String get reasoningLow => '低';

  @override
  String get reasoningMedium => '中';

  @override
  String get reasoningHigh => '高';

  @override
  String get editSessionLabel => '会话标签';

  @override
  String get discordBotSetup => 'Discord机器人设置';

  @override
  String get discordBotSetupDesc => '在Discord Developer Portal中创建机器人。';

  @override
  String get stepCreateApp => '前往Discord Developer Portal创建应用';

  @override
  String get stepAddBot => '在Bot标签页中添加机器人';

  @override
  String get stepEnableIntents =>
      '在Privileged Intents中启用Message Content Intent';

  @override
  String get stepCopyToken => '复制机器人令牌并在下方输入';

  @override
  String get connectingDiscordBot => '正在连接Discord机器人...';

  @override
  String get connectingDiscordBotDesc => '正在连接您的机器人。\n通常只需几秒钟。';

  @override
  String get discordBotRestarting => '正在重启机器人...';

  @override
  String get discordBotRestartingDesc => '正在使用新配置重启机器人。\n通常只需几秒钟。';

  @override
  String get discordNoPendingCodes => '向Discord机器人发送私信后，配对码将显示在此处。';

  @override
  String get discordPairing => 'Discord配对';

  @override
  String get discordPairingDesc => '输入向机器人发送私信后显示的验证码。';

  @override
  String get webAccess => 'Web 访问';

  @override
  String get webAccessPreparing => '正在准备 Web 访问...';

  @override
  String get webAccessPreparingHint => 'SSL 设置可能需要 15 分钟或更长时间';

  @override
  String get gatewayNetwork => '网络';

  @override
  String get gatewayCertificate => '证书';

  @override
  String get remoteView => '远程画面';

  @override
  String get remoteViewDescription => '实时查看代理屏幕';

  @override
  String get vncConnecting => '连接中...';

  @override
  String get vncConnected => '已连接';

  @override
  String get vncDisconnected => '已断开';

  @override
  String get vncError => '连接错误';

  @override
  String get aiUsage => 'AI 用量';

  @override
  String get resetsWeekly => '每周重置';

  @override
  String get resetsMonthly => '每月重置';

  @override
  String get resetsDaily => '每天重置';

  @override
  String get orDivider => '或';

  @override
  String get viewOnWeb => '在ClawHub上查看';

  @override
  String get defaultModel => '默认模型';

  @override
  String get searchModels => '搜索模型...';

  @override
  String get noModelsFound => '未找到模型';

  @override
  String get gatewayRestartNotice => '模型已更改。网关正在重新启动...';

  @override
  String get changeDefaultModelError => '更改默认模型失败';

  @override
  String get commonContinue => '继续';

  @override
  String get onboardingBadgeTopApp => '#1 OpenClaw 应用';

  @override
  String get onboardingWelcomeTitle => '你的AI智能助手。\n60秒即可就绪。';

  @override
  String get onboardingWelcomeSubtitle => '无需设置。无需API密钥。无需技术技能。';

  @override
  String get onboardingGithubStarsBadge => 'GitHub Stars 20万+';

  @override
  String get onboardingPoweredByModels => '由400多个AI模型驱动';

  @override
  String get onboardingQuoteSamAltman => '“一位对超智能代理的未来有着惊人想法的天才”';

  @override
  String get onboardingQuoteSamAltmanAttribution => '— Sam Altman，OpenAI CEO';

  @override
  String get onboardingGithubStarCount => '200,000+';

  @override
  String get onboardingGithubStarsLabel => 'GitHub Stars';

  @override
  String get onboardingGithubFastestGrowing => 'GitHub历史上增长最快的项目';

  @override
  String get onboardingGithubStarsSingleDay => '单日获得25,310颗星';

  @override
  String get onboardingTweetsSectionTitle => '受AI和科技领袖信赖';

  @override
  String get onboardingEasySetupTitle => '60秒完成设置。\n无需专业知识。';

  @override
  String get onboardingEasySetupSubtitle => '你不需要任何技术知识。其余的由我们处理。';

  @override
  String get onboardingEasySetupNoApiKeys => '无需API密钥';

  @override
  String get onboardingEasySetupNoTerminal => '无需终端或命令行';

  @override
  String get onboardingEasySetupNoServer => '无需Mac Mini或服务器';

  @override
  String get onboardingEasySetupNoTechKnowledge => '无需技术知识';

  @override
  String get onboardingSafeByDesignTitle => '从设计之初就安全。\n你的数据，你的规则。';

  @override
  String get onboardingSafeByDesignPressQuote => '“ClawBox是AI界的轰动，但安全性仍在完善中”';

  @override
  String get onboardingSafeByDesignSubtitle =>
      '你的智能助手在完全隔离的AWS环境中运行。只分享你想分享的。你的智能助手，你的空间。';

  @override
  String get onboardingSafeByDesignCheck1 => '完全独立的云环境';

  @override
  String get onboardingSafeByDesignCheck2 => '你控制智能助手的访问权限';

  @override
  String get onboardingSafeByDesignCheck3 => '独立计算，非共享';

  @override
  String get commonLogout => '退出登录';

  @override
  String get onboardingFullFeaturesTitle => '100% ClawBox。\n包含所有功能。';

  @override
  String get onboardingFullFeaturesSubtitle => '你的电脑能做的一切，Atlas都能为你完成：';

  @override
  String get onboardingFullFeaturesExample1 => '“检查我的邮件，为需要回复的邮件起草回复”';

  @override
  String get onboardingFullFeaturesExample2 => '“重新订购我上次在亚马逊买的牛奶”';

  @override
  String get onboardingFullFeaturesExample3 =>
      '“规划一次拉斯维加斯5晚旅行 — 机票、酒店 — 把行程发邮件给我”';

  @override
  String get onboardingFullFeaturesTagline => '没有限制。没有学习曲线。只有结果。';

  @override
  String get newPaywallTitle => '解锁智能助手的全部功能';

  @override
  String get newPaywallSubtitle => '一切已准备就绪。立即开始使用你的智能助手。';

  @override
  String get newPaywallBenefit1 => '专属云计算机 — 全天候运行';

  @override
  String get newPaywallBenefit2 => '400+AI模型 — 无限使用';

  @override
  String get newPaywallBenefit3 => '100+ AgentSkills — 即用即享';

  @override
  String get newPaywallFaqPriceQuestion => '为什么是这个价格？';

  @override
  String get newPaywallFaqPriceAnswer =>
      '我们为您分配一台专属云计算机，全天候运行，可无限访问400多个AI模型。这是一个真正有效的个人AI助手的实际成本。';

  @override
  String get newPaywallFaqCheaperQuestion => '有更便宜的替代方案吗？';

  @override
  String get newPaywallFaqCheaperAnswer =>
      '具有真正AI模型访问权限的专用环境需要真正的基础设施。我们不偷工减料 — 您的智能助手在自己独立的云上运行，而非共享资源。';

  @override
  String get newPaywallPeriodWeek => '/ 周';

  @override
  String get newPaywallPeriodMonth => '/ 月';

  @override
  String get newPaywallBestValueBadge => '最超值';

  @override
  String get newPaywallStartNowButton => '立即开始';

  @override
  String get newPaywallRestorePurchase => '恢复购买';

  @override
  String get newPaywallHaveReferralCode => '有推荐码？';

  @override
  String get newPaywallSocialProof => '已部署200,000+个智能助手';

  @override
  String get newPaywallReferralSheetTitle => '输入推荐码';

  @override
  String get newPaywallReferralHint => '例如 FRIEND2024';

  @override
  String get newPaywallReferralApplyButton => '应用';

  @override
  String get newPaywallReferralAppliedSuccess => '推荐码已应用！';

  @override
  String get newPaywallReferralInvalid => '无效的推荐码';

  @override
  String get userProfileTitle => '介绍一下自己';

  @override
  String get userProfileSubtitle => '让智能助手知道它在为谁工作';

  @override
  String get userProfileNameLabel => '您的姓名';

  @override
  String get userProfileNameHint => '张三';

  @override
  String get userProfileCallNameLabel => '我们该怎么称呼您？';

  @override
  String get userProfileCallNameHint => '三三';

  @override
  String get taskSelectionTitle => '您希望智能助手做什么？';

  @override
  String get taskSelectionSubtitle => '至少选择1项';

  @override
  String get taskOptionEmailManagement => '邮件管理';

  @override
  String get taskOptionWebResearch => '网络调研';

  @override
  String get taskOptionTaskAutomation => '任务自动化';

  @override
  String get taskOptionScheduling => '日程安排';

  @override
  String get taskOptionSocialMedia => '社交媒体';

  @override
  String get taskOptionWriting => '写作';

  @override
  String get taskOptionDataAnalysis => '数据分析';

  @override
  String get taskOptionSmartHome => '智能家居';

  @override
  String get vibeSelectionTitle => '设置智能助手的风格';

  @override
  String get vibeSelectionSubtitle => '智能助手应该如何沟通？';

  @override
  String get vibeNameCasual => '随意';

  @override
  String get vibeDescCasual => '轻松友好。像给聪明的朋友发短信一样。';

  @override
  String get vibeNameProfessional => '专业';

  @override
  String get vibeDescProfessional => '清晰有条理。适合商务沟通。';

  @override
  String get vibeNameFriendly => '友善';

  @override
  String get vibeDescFriendly => '温暖鼓励。始终积极且乐于助人。';

  @override
  String get vibeNameDirect => '直接';

  @override
  String get vibeDescDirect => '直奔主题。不废话，最大效率。';

  @override
  String get agentCreationTitle => '创建你的智能助手';

  @override
  String get agentCreationSubtitle => '选择智能助手的外观和个性';

  @override
  String get agentCreationNameLabel => '智能助手名称';

  @override
  String get agentCreationNameHint => 'Atlas';

  @override
  String get agentCreationCreatureLabel => '角色类型';

  @override
  String get agentCreationEmojiLabel => '智能助手表情';

  @override
  String get creatureCat => '猫';

  @override
  String get creatureDragon => '龙';

  @override
  String get creatureFox => '狐狸';

  @override
  String get creatureOwl => '猫头鹰';

  @override
  String get creatureRabbit => '兔子';

  @override
  String get creatureBear => '熊';

  @override
  String get creatureDino => '恐龙';

  @override
  String get creaturePenguin => '企鹅';

  @override
  String get creaturePerson => '人';

  @override
  String get creatureWolf => '狼';

  @override
  String get creaturePanda => '熊猫';

  @override
  String get creatureUnicorn => '独角兽';

  @override
  String get commonFallbackFriend => '朋友';

  @override
  String get commonFallbackYourAgent => '智能助手';

  @override
  String get fakeLoadingStep1 => '个人资料已配置';

  @override
  String get fakeLoadingStep2 => '个性已设定';

  @override
  String get fakeLoadingStep3 => '正在部署到云端...';

  @override
  String get fakeLoadingStep4 => '连接400+AI模型';

  @override
  String get fakeLoadingStep5 => '分配计算资源';

  @override
  String get fakeLoadingStep6 => '加载100+ AgentSkills';

  @override
  String get fakeLoadingStep7 => '配置智能助手工作空间';

  @override
  String fakeLoadingTitle(String callName) {
    return 'Hey $callName，请稍候...';
  }

  @override
  String get fakeLoadingSubtitle => '我们正在云端设置你的智能助手。\n你的个人智能助手即将准备就绪。';

  @override
  String get agentCompleteSubtitle => '你的智能助手已完全部署并针对你的任务进行了优化。';

  @override
  String get agentCompleteStatus1 => '24/7智能助手 — 始终在线';

  @override
  String get agentCompleteStatus2 => '400+ AI模型 — 已连接';

  @override
  String get agentCompleteStatus3 => '100+ AgentSkills — 已加载';

  @override
  String get agentCompleteStatus4 => '计算资源 — 已确保';

  @override
  String agentCompleteTitle(String agentName, String callName) {
    return '$agentName已就绪，$callName！';
  }

  @override
  String get agentCompleteOptimizedForLabel => '优化目标';

  @override
  String agentCompleteLiveHint(String agentName) {
    return '$agentName已上线，正等待你的使用';
  }
}
