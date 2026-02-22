// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get login => 'Entrar';

  @override
  String get loginSubtitle => 'Conecte sua conta para começar o ClawBox';

  @override
  String get loginFailed => 'Falha no login.';

  @override
  String get continueWithGoogle => 'Continuar com Google';

  @override
  String get continueWithApple => 'Continuar com Apple';

  @override
  String get instance => 'Instância';

  @override
  String get statusRunning => 'Em execução';

  @override
  String get statusWaiting => 'Aguardando';

  @override
  String get labelId => 'ID';

  @override
  String get labelName => 'Nome';

  @override
  String get statusConnected => 'Conectado';

  @override
  String get statusDisconnected => 'Desconectado';

  @override
  String get labelBot => 'Bot';

  @override
  String get settings => 'Configurações';

  @override
  String get manageSubscription => 'Gerenciar assinatura';

  @override
  String get manageSubscriptionDesc =>
      'Verificar e gerenciar o status da assinatura';

  @override
  String get recreateInstance => 'Recriar instância';

  @override
  String get recreateInstanceDesc => 'Redefinir todos os dados e reconfigurar';

  @override
  String get logout => 'Sair';

  @override
  String get logoutDesc => 'Sair da conta';

  @override
  String get recreateConfirmMessage =>
      'Todos os dados serão redefinidos e reconfigurados do zero. Esta ação não pode ser desfeita.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get recreate => 'Recriar';

  @override
  String get tagline => 'Conheça seu assistente de IA em um mensageiro';

  @override
  String get getStarted => 'Começar';

  @override
  String get alreadySubscribed => 'Já é assinante?';

  @override
  String get instanceCreationFailed => 'Falha ao criar a instância';

  @override
  String get checkNetworkAndRetry =>
      'Verifique sua conexão de rede e tente novamente.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get creatingInstance => 'Criando instância...';

  @override
  String get settingUp => 'Configurando...';

  @override
  String get preparing => 'Preparando...';

  @override
  String get creatingInstanceDesc =>
      'Criando sua instância de IA.\nPor favor, aguarde.';

  @override
  String get startingInstanceDesc =>
      'Sua instância está sendo iniciada.\nIsso geralmente leva 4-5 minutos.\nVocê pode fazer outras coisas e voltar depois.';

  @override
  String get pleaseWait => 'Por favor, aguarde...';

  @override
  String get telegramBotSetup => 'Configuração do bot do Telegram';

  @override
  String get telegramBotSetupDesc =>
      'Crie um bot através do @BotFather no Telegram.';

  @override
  String get stepSearchBotFather => 'Pesquise @BotFather no Telegram';

  @override
  String get stepNewBot => 'Digite o comando /newbot';

  @override
  String get stepSetBotName => 'Defina o nome e username do bot';

  @override
  String get stepEnterToken => 'Insira o token recebido abaixo';

  @override
  String get enterBotToken => 'Insira o token do bot';

  @override
  String get next => 'Próximo';

  @override
  String get botTokenError =>
      'Falha ao configurar o token do bot. Verifique seu token.';

  @override
  String get telegramPairing => 'Pareamento do Telegram';

  @override
  String get telegramPairingDesc =>
      'Insira o código de autenticação exibido ao enviar uma mensagem ao bot.';

  @override
  String get authCode => 'Código de autenticação';

  @override
  String get approve => 'Aprovar';

  @override
  String get pairingError => 'Falha no pareamento. Tente novamente.';

  @override
  String get home => 'Início';

  @override
  String get setup => 'Configurações';

  @override
  String get deleteAccount => 'Excluir conta';

  @override
  String get deleteAccountDesc =>
      'Excluir permanentemente sua conta e todos os dados';

  @override
  String get deleteAccountConfirmTitle => 'Excluir conta?';

  @override
  String get deleteAccountConfirmMessage =>
      'Sua instância será excluída e todos os dados serão permanentemente perdidos. Esta ação não pode ser desfeita. Você pode criar uma nova conta após a exclusão.';

  @override
  String get delete => 'Excluir';

  @override
  String get setupCompleteTitle => 'Configuração concluída!';

  @override
  String get setupCompleteDesc =>
      'Envie uma mensagem para seu bot no Telegram e o OpenClaw responderá. Comece a conversar agora!';

  @override
  String get startChatting => 'Começar a conversar';

  @override
  String openBotOnTelegram(String botUsername) {
    return 'Abrir @$botUsername';
  }

  @override
  String get haveReferralCode => 'Tem um código de indicação?';

  @override
  String get enterReferralCode => 'Inserir código de indicação';

  @override
  String get referralCodeHint => 'Insira seu código';

  @override
  String get referralCodeInvalid => 'Código de indicação inválido.';

  @override
  String get referralCodeSuccess => 'Código de indicação aplicado!';

  @override
  String get skipTelegramTitle => 'Pular configuração do Telegram?';

  @override
  String get skipTelegramDesc =>
      'Você pode conectar mais tarde. Até lá, você pode conversar dentro do aplicativo.';

  @override
  String get skip => 'Pular';

  @override
  String get connectTelegram => 'Conectar Telegram';

  @override
  String get connectTelegramDesc =>
      'Conecte o Telegram para conversar também no mensageiro';

  @override
  String get logIn => 'Entrar';

  @override
  String get signUp => 'Criar conta';

  @override
  String get signUpSubtitle => 'Crie sua conta para começar o ClawBox';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Senha';

  @override
  String get confirmPassword => 'Confirmar senha';

  @override
  String get nameOptional => 'Nome (opcional)';

  @override
  String get or => 'ou';

  @override
  String get dontHaveAccount => 'Não tem uma conta?';

  @override
  String get alreadyHaveAccount => 'Já tem uma conta?';

  @override
  String get invalidEmail => 'Insira um e-mail válido';

  @override
  String get passwordTooShort => 'A senha deve ter pelo menos 8 caracteres';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem';

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
  String get goodMorning => 'Bom dia';

  @override
  String get goodAfternoon => 'Boa tarde';

  @override
  String get goodEvening => 'Boa noite';

  @override
  String get chatWithAI => 'Conversar com IA';

  @override
  String get agentReady => 'Seu agente está pronto';

  @override
  String get agentStarting => 'O agente está iniciando...';

  @override
  String get chatTitle => 'ClawBox AI';

  @override
  String get statusOnline => 'Online';

  @override
  String get statusConnecting => 'Conectando...';

  @override
  String get statusOffline => 'Offline';

  @override
  String get statusAuthenticating => 'Autenticando...';

  @override
  String get statusWaitingForConnection => 'Aguardando conexão...';

  @override
  String get emptyChatTitle => 'Como posso ajudar você hoje?';

  @override
  String get emptyChatSubtitle => 'Pergunte qualquer coisa sobre seu projeto';

  @override
  String get dateToday => 'Hoje';

  @override
  String get dateYesterday => 'Ontem';

  @override
  String get connectionError => 'Erro de conexão';

  @override
  String get reconnect => 'Reconectar';

  @override
  String get typeMessage => 'Digite uma mensagem...';

  @override
  String get sessions => 'Sessões';

  @override
  String get newSession => 'Nova sessão';

  @override
  String get noSessionsYet => 'Nenhuma sessão ainda';

  @override
  String get timeNow => 'agora';

  @override
  String timeMinutes(int minutes) {
    return '${minutes}m';
  }

  @override
  String timeHours(int hours) {
    return '${hours}h';
  }

  @override
  String timeDays(int days) {
    return '${days}d';
  }

  @override
  String get skills => 'Skills';

  @override
  String get allSkills => 'Tudo';

  @override
  String get searchSkills => 'Pesquisar skills...';

  @override
  String get installed => 'Instalado';

  @override
  String get install => 'Instalar';

  @override
  String get uninstall => 'Desinstalar';

  @override
  String get installing => 'Instalando...';

  @override
  String get uninstalling => 'Desinstalando...';

  @override
  String get installSuccess => 'Skill instalado com sucesso';

  @override
  String get uninstallSuccess => 'Skill desinstalado';

  @override
  String get installFailed => 'Falha ao instalar o skill';

  @override
  String get uninstallFailed => 'Falha ao desinstalar o skill';

  @override
  String get noSkillsFound => 'Nenhum skill encontrado';

  @override
  String get version => 'Versão';

  @override
  String get author => 'Autor';

  @override
  String get uninstallConfirmTitle => 'Desinstalar skill?';

  @override
  String get uninstallConfirmMessage =>
      'Este skill será removido da sua instância.';

  @override
  String get aiDataProcessing => 'Processamento de dados de IA';

  @override
  String get aiDataSharing => 'Compartilhamento de dados de IA';

  @override
  String get aiDataProviders => 'Provedores de dados de IA';

  @override
  String get requestDataDeletion => 'Solicitar exclusão de dados';

  @override
  String get aiConsentDataSentTitle => 'Dados enviados aos serviços de IA';

  @override
  String get aiConsentDataSentMessages => 'Mensagens de texto enviadas no chat';

  @override
  String get aiConsentDataSentImages =>
      'Imagens anexadas (JPEG, PNG, GIF, WebP)';

  @override
  String get aiConsentDataSentContext =>
      'Contexto da conversa para respostas de IA';

  @override
  String get aiConsentRecipientsTitle => 'Destinatários dos dados';

  @override
  String get aiConsentRecipientOpenRouter =>
      'OpenRouter (roteamento de solicitações de IA)';

  @override
  String get aiConsentRecipientProviders =>
      'OpenAI, Anthropic, Google (provedores de modelos de IA)';

  @override
  String get aiConsentUsageTitle => 'Como seus dados são usados';

  @override
  String get aiConsentUsageResponses =>
      'Usados apenas para gerar respostas de IA';

  @override
  String get aiConsentUsageNoTraining =>
      'Não usados para treinamento de modelos de IA';

  @override
  String get aiConsentUsageDeletion => 'Excluídos ao excluir sua conta';

  @override
  String get aiConsentViewPrivacy => 'Ver política de privacidade';

  @override
  String get revokeAiConsentTitle => 'Revogar consentimento de dados de IA?';

  @override
  String get revokeAiConsentMessage =>
      'Você precisará concordar novamente antes de usar o recurso de chat.';

  @override
  String get revoke => 'Revogar';

  @override
  String get aiDataProvidersTitle => 'Provedores de serviços de IA';

  @override
  String get aiDataProvidersDesc =>
      'Seus dados podem ser processados pelos seguintes serviços de IA de terceiros:';

  @override
  String get aiDisclosureAgree => 'Concordar e continuar';

  @override
  String get aiConsentRequired =>
      'O consentimento de dados de IA é necessário para usar este serviço.';

  @override
  String get connectingBot => 'Conectando seu bot do Telegram...';

  @override
  String get connectingBotDesc =>
      'Por favor, aguarde enquanto conectamos ao seu bot.\nIsso geralmente leva alguns segundos.';

  @override
  String get botRestarting => 'Reiniciando seu bot...';

  @override
  String get botRestartingDesc =>
      'Seu bot está reiniciando com a nova configuração.\nIsso geralmente leva alguns segundos.';

  @override
  String get pendingPairingCodes => 'Códigos de pareamento pendentes';

  @override
  String get noPendingCodes =>
      'Envie uma mensagem para seu bot do Telegram e o código de pareamento aparecerá aqui.';

  @override
  String get tapToApprove => 'Toque para aprovar';

  @override
  String get pairingApproved => 'Pareamento aprovado!';

  @override
  String get dismiss => 'Ignorar';
}
