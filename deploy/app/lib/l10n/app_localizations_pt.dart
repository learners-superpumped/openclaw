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
      'Sua instância está sendo iniciada.\nIsso geralmente leva 1-2 minutos.';

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
}
