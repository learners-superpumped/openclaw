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
}
