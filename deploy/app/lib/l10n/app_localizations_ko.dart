// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get login => '로그인';

  @override
  String get loginSubtitle => '계정을 연결하여 ClawBox를 시작하세요';

  @override
  String get loginFailed => '로그인에 실패했습니다.';

  @override
  String get continueWithGoogle => 'Google로 계속하기';

  @override
  String get continueWithApple => 'Apple로 계속하기';

  @override
  String get instance => '인스턴스';

  @override
  String get statusRunning => '실행 중';

  @override
  String get statusWaiting => '대기';

  @override
  String get labelId => 'ID';

  @override
  String get labelName => '이름';

  @override
  String get statusConnected => '연결됨';

  @override
  String get statusDisconnected => '미연결';

  @override
  String get labelBot => '봇';

  @override
  String get settings => '설정';

  @override
  String get manageSubscription => '구독 관리';

  @override
  String get manageSubscriptionDesc => '구독 상태 확인 및 관리';

  @override
  String get recreateInstance => '인스턴스 재생성';

  @override
  String get recreateInstanceDesc => '모든 데이터를 초기화하고 다시 설정';

  @override
  String get logout => '로그아웃';

  @override
  String get logoutDesc => '계정에서 로그아웃';

  @override
  String get recreateConfirmMessage =>
      '모든 데이터가 초기화되고 처음부터 다시 설정됩니다. 이 작업은 되돌릴 수 없습니다.';

  @override
  String get cancel => '취소';

  @override
  String get recreate => '재생성';

  @override
  String get tagline => 'AI 어시스턴트를 메신저로 만나보세요';

  @override
  String get getStarted => '시작하기';

  @override
  String get alreadySubscribed => '이미 구독 중이신가요?';

  @override
  String get instanceCreationFailed => '인스턴스 생성에 실패했습니다';

  @override
  String get checkNetworkAndRetry => '네트워크 연결을 확인하고 다시 시도해주세요.';

  @override
  String get retry => '다시 시도';

  @override
  String get creatingInstance => '인스턴스 생성 중...';

  @override
  String get settingUp => '설정 진행 중...';

  @override
  String get preparing => '준비 중...';

  @override
  String get creatingInstanceDesc => 'AI 인스턴스를 생성하고 있습니다.\n잠시만 기다려주세요.';

  @override
  String get startingInstanceDesc => '인스턴스가 시작되고 있습니다.\n보통 1-2분 정도 소요됩니다.';

  @override
  String get pleaseWait => '잠시만 기다려주세요...';

  @override
  String get telegramBotSetup => 'Telegram 봇 설정';

  @override
  String get telegramBotSetupDesc => 'Telegram에서 @BotFather를 통해 봇을 생성하세요.';

  @override
  String get stepSearchBotFather => 'Telegram에서 @BotFather 검색';

  @override
  String get stepNewBot => '/newbot 명령어 입력';

  @override
  String get stepSetBotName => '봇 이름과 username 설정';

  @override
  String get stepEnterToken => '발급받은 토큰을 아래에 입력';

  @override
  String get enterBotToken => '봇 토큰을 입력하세요';

  @override
  String get next => '다음';

  @override
  String get botTokenError => '봇 토큰 설정에 실패했습니다. 토큰을 확인해주세요.';

  @override
  String get telegramPairing => 'Telegram 페어링';

  @override
  String get telegramPairingDesc => '봇에게 메시지를 보내면 표시되는 인증 코드를 입력하세요.';

  @override
  String get authCode => '인증 코드';

  @override
  String get approve => '승인';

  @override
  String get pairingError => '페어링에 실패했습니다. 다시 시도해주세요.';

  @override
  String get home => '홈';

  @override
  String get setup => '설정';

  @override
  String get deleteAccount => '회원 탈퇴';

  @override
  String get deleteAccountDesc => '계정과 모든 데이터를 영구적으로 삭제';

  @override
  String get deleteAccountConfirmTitle => '정말 탈퇴하시겠습니까?';

  @override
  String get deleteAccountConfirmMessage =>
      '인스턴스가 삭제되고 모든 데이터가 영구적으로 삭제됩니다. 이 작업은 되돌릴 수 없습니다. 탈퇴 후에도 새 계정을 생성할 수 있습니다.';

  @override
  String get delete => '삭제';

  @override
  String get setupCompleteTitle => '설정 완료!';

  @override
  String get setupCompleteDesc =>
      'Telegram에서 봇에게 메시지를 보내면 OpenClaw가 대답합니다. 지금 바로 대화를 시작해보세요!';

  @override
  String get startChatting => '대화 시작하기';

  @override
  String openBotOnTelegram(String botUsername) {
    return '@$botUsername 열기';
  }

  @override
  String get haveReferralCode => '레퍼럴 코드가 있으신가요?';

  @override
  String get enterReferralCode => '레퍼럴 코드 입력';

  @override
  String get referralCodeHint => '코드를 입력하세요';

  @override
  String get referralCodeInvalid => '유효하지 않은 레퍼럴 코드입니다.';

  @override
  String get referralCodeSuccess => '레퍼럴 코드가 적용되었습니다!';

  @override
  String get skipTelegramTitle => 'Telegram 설정 건너뛰기';

  @override
  String get skipTelegramDesc =>
      '연결하지 않고 나중에 연결할 수 있습니다. 연결 전까지는 앱 내에서 채팅 가능합니다.';

  @override
  String get skip => '건너뛰기';

  @override
  String get connectTelegram => 'Telegram 연결하기';

  @override
  String get connectTelegramDesc => 'Telegram을 연결하면 메신저에서도 대화할 수 있습니다';

  @override
  String get logIn => '로그인';

  @override
  String get signUp => '회원가입';

  @override
  String get signUpSubtitle => '계정을 만들어 ClawBox를 시작하세요';

  @override
  String get email => '이메일';

  @override
  String get password => '비밀번호';

  @override
  String get confirmPassword => '비밀번호 확인';

  @override
  String get nameOptional => '이름 (선택)';

  @override
  String get or => '또는';

  @override
  String get dontHaveAccount => '계정이 없으신가요?';

  @override
  String get alreadyHaveAccount => '이미 계정이 있으신가요?';

  @override
  String get invalidEmail => '올바른 이메일을 입력하세요';

  @override
  String get passwordTooShort => '비밀번호는 최소 8자 이상이어야 합니다';

  @override
  String get passwordsDoNotMatch => '비밀번호가 일치하지 않습니다';

  @override
  String get termsOfService => '이용약관';

  @override
  String get privacyPolicy => '개인정보처리방침';

  @override
  String agreeToTerms(String terms, String privacy) {
    return '$terms 및 $privacy에 동의합니다';
  }

  @override
  String get mustAgreeToTerms => '이용약관 및 개인정보처리방침에 동의해주세요';

  @override
  String get aiDataConsentTitle => 'AI 데이터 공유';

  @override
  String get aiDataConsentMessage =>
      '메시지와 이미지 첨부 파일은 응답 생성을 위해 제3자 AI 서비스(OpenRouter 경유)로 전송됩니다. 데이터는 AI 학습에 사용되지 않습니다. 계속하면 이 데이터 처리에 동의하는 것입니다.';

  @override
  String get agree => '동의';

  @override
  String get decline => '거절';

  @override
  String get legal => '법적 고지';

  @override
  String bySigningIn(String terms, String privacy) {
    return '로그인하면 $terms 및 $privacy에 동의하게 됩니다';
  }

  @override
  String get general => '일반';

  @override
  String get account => '계정';

  @override
  String get goodMorning => '좋은 아침이에요';

  @override
  String get goodAfternoon => '좋은 오후예요';

  @override
  String get goodEvening => '좋은 저녁이에요';

  @override
  String get chatWithAI => 'AI와 채팅';

  @override
  String get agentReady => '에이전트가 준비되었어요';

  @override
  String get agentStarting => '에이전트를 시작하는 중...';

  @override
  String get chatTitle => 'ClawBox AI';

  @override
  String get statusOnline => '온라인';

  @override
  String get statusConnecting => '연결 중...';

  @override
  String get statusOffline => '오프라인';

  @override
  String get statusAuthenticating => '인증 중...';

  @override
  String get statusWaitingForConnection => '연결 대기 중...';

  @override
  String get emptyChatTitle => '무엇을 도와드릴까요?';

  @override
  String get emptyChatSubtitle => '프로젝트에 대해 무엇이든 물어보세요';

  @override
  String get dateToday => '오늘';

  @override
  String get dateYesterday => '어제';

  @override
  String get connectionError => '연결 오류';

  @override
  String get reconnect => '다시 연결';

  @override
  String get typeMessage => '메시지를 입력하세요...';

  @override
  String get sessions => '세션';

  @override
  String get newSession => '새 세션';

  @override
  String get noSessionsYet => '아직 세션이 없습니다';

  @override
  String get timeNow => '방금';

  @override
  String timeMinutes(int minutes) {
    return '$minutes분';
  }

  @override
  String timeHours(int hours) {
    return '$hours시간';
  }

  @override
  String timeDays(int days) {
    return '$days일';
  }

  @override
  String get skills => '스킬';

  @override
  String get allSkills => '전체';

  @override
  String get searchSkills => '스킬 검색...';

  @override
  String get installed => '설치됨';

  @override
  String get install => '설치';

  @override
  String get uninstall => '제거';

  @override
  String get installing => '설치 중...';

  @override
  String get uninstalling => '제거 중...';

  @override
  String get installSuccess => '스킬이 설치되었습니다';

  @override
  String get uninstallSuccess => '스킬이 제거되었습니다';

  @override
  String get installFailed => '스킬 설치에 실패했습니다';

  @override
  String get uninstallFailed => '스킬 제거에 실패했습니다';

  @override
  String get noSkillsFound => '스킬을 찾을 수 없습니다';

  @override
  String get version => '버전';

  @override
  String get author => '작성자';

  @override
  String get uninstallConfirmTitle => '스킬을 제거할까요?';

  @override
  String get uninstallConfirmMessage => '이 스킬이 인스턴스에서 제거됩니다.';

  @override
  String get aiDataProcessing => 'AI 데이터 처리';

  @override
  String get aiDataSharing => 'AI 데이터 공유';

  @override
  String get aiDataProviders => 'AI 데이터 제공업체';

  @override
  String get requestDataDeletion => '데이터 삭제 요청';

  @override
  String get aiConsentDataSentTitle => 'AI 서비스에 전송되는 데이터';

  @override
  String get aiConsentDataSentMessages => '채팅에서 보내는 텍스트 메시지';

  @override
  String get aiConsentDataSentImages => '이미지 첨부 파일 (JPEG, PNG, GIF, WebP)';

  @override
  String get aiConsentDataSentContext => 'AI 응답을 위한 대화 컨텍스트';

  @override
  String get aiConsentRecipientsTitle => '데이터 수신자';

  @override
  String get aiConsentRecipientOpenRouter => 'OpenRouter (AI 요청 라우팅)';

  @override
  String get aiConsentRecipientProviders =>
      'OpenAI, Anthropic, Google (AI 모델 제공업체)';

  @override
  String get aiConsentUsageTitle => '데이터 사용 방법';

  @override
  String get aiConsentUsageResponses => 'AI 응답 생성에만 사용';

  @override
  String get aiConsentUsageNoTraining => 'AI 모델 학습에 사용되지 않음';

  @override
  String get aiConsentUsageDeletion => '계정 삭제 시 함께 삭제';

  @override
  String get aiConsentViewPrivacy => '개인정보처리방침 보기';

  @override
  String get revokeAiConsentTitle => 'AI 데이터 동의를 철회할까요?';

  @override
  String get revokeAiConsentMessage => '채팅 기능을 사용하려면 다시 동의해야 합니다.';

  @override
  String get revoke => '철회';

  @override
  String get aiDataProvidersTitle => 'AI 서비스 제공업체';

  @override
  String get aiDataProvidersDesc => '귀하의 데이터는 다음 제3자 AI 서비스에 의해 처리될 수 있습니다:';

  @override
  String get aiDisclosureAgree => '동의 후 계속하기';

  @override
  String get aiConsentRequired => '이 서비스를 이용하려면 AI 데이터 동의가 필요합니다.';

  @override
  String get connectingBot => 'Telegram 봇 연결 중...';

  @override
  String get connectingBotDesc => '봇에 연결하는 중입니다.\n보통 몇 초 정도 소요됩니다.';

  @override
  String get pendingPairingCodes => '대기 중인 페어링 코드';

  @override
  String get noPendingCodes => 'Telegram 봇에 메시지를 보내면 페어링 코드가 여기에 나타납니다.';

  @override
  String get tapToApprove => '탭하여 승인';

  @override
  String get pairingApproved => '페어링이 승인되었습니다!';

  @override
  String get dismiss => '무시';
}
