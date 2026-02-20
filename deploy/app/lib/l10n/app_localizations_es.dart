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

  @override
  String get haveReferralCode => '¿Tienes un código de referencia?';

  @override
  String get enterReferralCode => 'Ingresar código de referencia';

  @override
  String get referralCodeHint => 'Ingresa tu código';

  @override
  String get referralCodeInvalid => 'Código de referencia inválido.';

  @override
  String get referralCodeSuccess => '¡Código de referencia aplicado!';

  @override
  String get skipTelegramTitle => '¿Omitir configuración de Telegram?';

  @override
  String get skipTelegramDesc =>
      'Puedes conectarte más tarde. Hasta entonces, puedes chatear dentro de la aplicación.';

  @override
  String get skip => 'Omitir';

  @override
  String get connectTelegram => 'Conectar Telegram';

  @override
  String get connectTelegramDesc =>
      'Conecta Telegram para chatear también en el mensajero';

  @override
  String get logIn => 'Iniciar sesión';

  @override
  String get signUp => 'Registrarse';

  @override
  String get signUpSubtitle => 'Crea tu cuenta para comenzar con ClawBox';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get nameOptional => 'Nombre (opcional)';

  @override
  String get or => 'o';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta?';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get invalidEmail => 'Ingresa un correo electrónico válido';

  @override
  String get passwordTooShort =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

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
  String get goodMorning => 'Buenos días';

  @override
  String get goodAfternoon => 'Buenas tardes';

  @override
  String get goodEvening => 'Buenas noches';

  @override
  String get chatWithAI => 'Chatear con IA';

  @override
  String get agentReady => 'Tu agente está listo';

  @override
  String get agentStarting => 'El agente se está iniciando...';

  @override
  String get chatTitle => 'ClawBox AI';

  @override
  String get statusOnline => 'En línea';

  @override
  String get statusConnecting => 'Conectando...';

  @override
  String get statusOffline => 'Sin conexión';

  @override
  String get statusAuthenticating => 'Autenticando...';

  @override
  String get statusWaitingForConnection => 'Esperando conexión...';

  @override
  String get emptyChatTitle => '¿En qué puedo ayudarte hoy?';

  @override
  String get emptyChatSubtitle => 'Pregúntame lo que quieras sobre tu proyecto';

  @override
  String get dateToday => 'Hoy';

  @override
  String get dateYesterday => 'Ayer';

  @override
  String get connectionError => 'Error de conexión';

  @override
  String get reconnect => 'Reconectar';

  @override
  String get typeMessage => 'Escribe un mensaje...';

  @override
  String get sessions => 'Sesiones';

  @override
  String get newSession => 'Nueva sesión';

  @override
  String get noSessionsYet => 'Aún no hay sesiones';

  @override
  String get timeNow => 'ahora';

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
  String get allSkills => 'Todo';

  @override
  String get searchSkills => 'Buscar skills...';

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
  String get installSuccess => 'Skill instalado correctamente';

  @override
  String get uninstallSuccess => 'Skill desinstalado';

  @override
  String get installFailed => 'Error al instalar el skill';

  @override
  String get uninstallFailed => 'Error al desinstalar el skill';

  @override
  String get noSkillsFound => 'No se encontraron skills';

  @override
  String get version => 'Versión';

  @override
  String get author => 'Autor';

  @override
  String get uninstallConfirmTitle => '¿Desinstalar skill?';

  @override
  String get uninstallConfirmMessage =>
      'Este skill será eliminado de tu instancia.';

  @override
  String get aiDataProcessing => 'Procesamiento de datos de IA';

  @override
  String get aiDataSharing => 'Compartir datos de IA';

  @override
  String get aiDataProviders => 'Proveedores de datos de IA';

  @override
  String get requestDataDeletion => 'Solicitar eliminación de datos';

  @override
  String get aiConsentDataSentTitle => 'Datos enviados a servicios de IA';

  @override
  String get aiConsentDataSentMessages =>
      'Mensajes de texto enviados en el chat';

  @override
  String get aiConsentDataSentImages =>
      'Imágenes adjuntas (JPEG, PNG, GIF, WebP)';

  @override
  String get aiConsentDataSentContext =>
      'Contexto de conversación para respuestas de IA';

  @override
  String get aiConsentRecipientsTitle => 'Destinatarios de datos';

  @override
  String get aiConsentRecipientOpenRouter =>
      'OpenRouter (enrutamiento de solicitudes de IA)';

  @override
  String get aiConsentRecipientProviders =>
      'OpenAI, Anthropic, Google (proveedores de modelos de IA)';

  @override
  String get aiConsentUsageTitle => 'Cómo se usan tus datos';

  @override
  String get aiConsentUsageResponses =>
      'Usados únicamente para generar respuestas de IA';

  @override
  String get aiConsentUsageNoTraining =>
      'No se usan para entrenar modelos de IA';

  @override
  String get aiConsentUsageDeletion => 'Se eliminan al eliminar tu cuenta';

  @override
  String get aiConsentViewPrivacy => 'Ver política de privacidad';

  @override
  String get revokeAiConsentTitle => '¿Revocar consentimiento de datos de IA?';

  @override
  String get revokeAiConsentMessage =>
      'Deberás aceptar nuevamente antes de usar la función de chat.';

  @override
  String get revoke => 'Revocar';

  @override
  String get aiDataProvidersTitle => 'Proveedores de servicios de IA';

  @override
  String get aiDataProvidersDesc =>
      'Tus datos pueden ser procesados por los siguientes servicios de IA de terceros:';

  @override
  String get aiDisclosureAgree => 'Aceptar y continuar';

  @override
  String get aiConsentRequired =>
      'Se requiere el consentimiento de datos de IA para usar este servicio.';
}
