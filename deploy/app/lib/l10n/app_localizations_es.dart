// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get login => 'Iniciar sesión';

  @override
  String get loginSubtitle => 'Conecta tu cuenta para comenzar con ClawBox';

  @override
  String get loginFailed => 'Error al iniciar sesión.';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get continueWithApple => 'Continuar con Apple';

  @override
  String get instance => 'Instancia';

  @override
  String get statusRunning => 'En ejecución';

  @override
  String get statusWaiting => 'En espera';

  @override
  String get labelId => 'ID';

  @override
  String get labelName => 'Nombre';

  @override
  String get statusConnected => 'Conectado';

  @override
  String get statusDisconnected => 'Desconectado';

  @override
  String get labelBot => 'Bot';

  @override
  String get settings => 'Configuración';

  @override
  String get manageSubscription => 'Gestionar suscripción';

  @override
  String get manageSubscriptionDesc =>
      'Consultar y gestionar el estado de la suscripción';

  @override
  String get recreateInstance => 'Recrear instancia';

  @override
  String get recreateInstanceDesc =>
      'Restablecer todos los datos y reconfigurar';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logoutDesc => 'Cerrar sesión de la cuenta';

  @override
  String get recreateConfirmMessage =>
      'Todos los datos se restablecerán y se reconfigurarán desde cero. Esta acción no se puede deshacer.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get recreate => 'Recrear';

  @override
  String get tagline => 'Conoce a tu asistente de IA en un mensajero';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get alreadySubscribed => '¿Ya estás suscrito?';

  @override
  String get instanceCreationFailed => 'Error al crear la instancia';

  @override
  String get checkNetworkAndRetry =>
      'Verifica tu conexión de red e inténtalo de nuevo.';

  @override
  String get retry => 'Reintentar';

  @override
  String get creatingInstance => 'Creando instancia...';

  @override
  String get settingUp => 'Configurando...';

  @override
  String get preparing => 'Preparando...';

  @override
  String get creatingInstanceDesc =>
      'Creando tu instancia de IA.\nPor favor espera.';

  @override
  String get startingInstanceDesc =>
      'Tu instancia se está iniciando.\nEsto suele tardar 1-2 minutos.';

  @override
  String get pleaseWait => 'Por favor espera...';

  @override
  String get telegramBotSetup => 'Configuración del bot de Telegram';

  @override
  String get telegramBotSetupDesc =>
      'Crea un bot a través de @BotFather en Telegram.';

  @override
  String get stepSearchBotFather => 'Busca @BotFather en Telegram';

  @override
  String get stepNewBot => 'Introduce el comando /newbot';

  @override
  String get stepSetBotName => 'Establece el nombre y username del bot';

  @override
  String get stepEnterToken => 'Introduce el token recibido abajo';

  @override
  String get enterBotToken => 'Introduce el token del bot';

  @override
  String get next => 'Siguiente';

  @override
  String get botTokenError =>
      'Error al configurar el token del bot. Verifica tu token.';

  @override
  String get telegramPairing => 'Emparejamiento de Telegram';

  @override
  String get telegramPairingDesc =>
      'Introduce el código de autenticación que aparece al enviar un mensaje al bot.';

  @override
  String get authCode => 'Código de autenticación';

  @override
  String get approve => 'Aprobar';

  @override
  String get pairingError => 'Error en el emparejamiento. Inténtalo de nuevo.';

  @override
  String get home => 'Inicio';

  @override
  String get setup => 'Configuración';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountDesc =>
      'Eliminar permanentemente tu cuenta y todos los datos';

  @override
  String get deleteAccountConfirmTitle => '¿Eliminar cuenta?';

  @override
  String get deleteAccountConfirmMessage =>
      'Tu instancia será eliminada y todos los datos se perderán permanentemente. Esta acción no se puede deshacer. Puedes crear una nueva cuenta después de la eliminación.';

  @override
  String get delete => 'Eliminar';

  @override
  String get setupCompleteTitle => '¡Configuración completada!';

  @override
  String get setupCompleteDesc =>
      'Envía un mensaje a tu bot en Telegram y OpenClaw responderá. ¡Comienza a chatear ahora!';

  @override
  String get startChatting => 'Empezar a chatear';

  @override
  String openBotOnTelegram(String botUsername) {
    return 'Abrir @$botUsername';
  }
}
