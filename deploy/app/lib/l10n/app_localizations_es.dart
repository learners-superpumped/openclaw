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
      'Tu instancia se está iniciando.\nEsto suele tardar 4-5 minutos.\nPuedes hacer otras cosas y volver después.';

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

  @override
  String get connectingBot => 'Conectando tu bot de Telegram...';

  @override
  String get connectingBotDesc =>
      'Por favor espera mientras conectamos con tu bot.\nEsto suele tardar unos segundos.';

  @override
  String get botRestarting => 'Reiniciando tu bot...';

  @override
  String get botRestartingDesc =>
      'Tu bot se está reiniciando con la nueva configuración.\nEsto suele tardar unos segundos.';

  @override
  String get pendingPairingCodes => 'Códigos de emparejamiento pendientes';

  @override
  String get noPendingCodes =>
      'Envía un mensaje a tu bot de Telegram y el código de emparejamiento aparecerá aquí.';

  @override
  String get tapToApprove => 'Toca para aprobar';

  @override
  String get pairingApproved => '¡Emparejamiento aprobado!';

  @override
  String get dismiss => 'Ignorar';

  @override
  String get paywallTitle => 'Desbloquea tu asistente IA';

  @override
  String get paywallFeature1 => 'Tu asistente IA personal en Telegram';

  @override
  String get paywallFeature2 =>
      'Chatea en cualquier momento, respuestas instantáneas';

  @override
  String get paywallFeature3 => 'Configuración en un toque, listo en minutos';

  @override
  String get paywallReview =>
      'Solo envío un mensaje a mi bot en Telegram y obtengo respuestas al instante. Es como tener un asistente personal en el bolsillo.';

  @override
  String get paywallReviewAuthor => 'Alex K';

  @override
  String get subscribe => 'Suscribirse';

  @override
  String get cancelAnytime => 'Cancela cuando quieras';

  @override
  String get restore => 'Restaurar';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get weekly => 'Semanal';

  @override
  String get monthly => 'Mensual';

  @override
  String get annual => 'Anual';

  @override
  String get lifetime => 'Vitalicio';

  @override
  String savePercent(int percent) {
    return 'Ahorra $percent%';
  }

  @override
  String get channels => 'Canales';

  @override
  String get channelsDesc => 'Gestiona tus canales de mensajería';

  @override
  String get channelConnected => 'Conectado';

  @override
  String get channelDisconnected => 'Desconectado';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get connectWhatsApp => 'Conectar WhatsApp';

  @override
  String get generateQrCode => 'Regenerar código QR';

  @override
  String get scanQrCode => 'Escanear código QR con WhatsApp';

  @override
  String get waitingForScan => 'Esperando escaneo...';

  @override
  String get disconnectChannel => 'Desconectar';

  @override
  String get disconnectConfirmTitle => '¿Desconectar canal?';

  @override
  String get disconnectConfirmMessage =>
      'Este canal será desconectado. Puedes reconectarlo más tarde.';

  @override
  String pendingCount(int count) {
    return '$count pendientes';
  }

  @override
  String channelsSummary(int connected) {
    return '$connected conectados';
  }

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscord => 'Conectar Discord';

  @override
  String get discordBotToken => 'Token de bot de Discord';

  @override
  String get connect => 'Conectar';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get pasteImage => 'Pegar imagen';

  @override
  String get messageQueued => 'No hay mensajes en cola';

  @override
  String get messagesInQueue => 'Mensajes en cola';

  @override
  String get removeFromQueue => 'Eliminar de la cola';

  @override
  String get sessionSettings => 'Configuración de sesión';

  @override
  String get reasoningLevel => 'Nivel de razonamiento';

  @override
  String get thinkingMode => 'Modo de pensamiento';

  @override
  String get verboseLevel => 'Nivel de detalle';

  @override
  String get deleteSession => 'Eliminar sesión';

  @override
  String get deleteSessionConfirm =>
      'Esta sesión y su historial se eliminarán permanentemente. Esta acción no se puede deshacer.';

  @override
  String get newMessagesBelow => 'Nuevos mensajes';

  @override
  String get focusMode => 'Modo enfoque';

  @override
  String get exitFocusMode => 'Salir del modo enfoque';

  @override
  String get compactingContext => 'Compactando contexto...';

  @override
  String get contextCompacted => 'Contexto compactado';

  @override
  String get showingLastMessages => 'Mostrando últimos';

  @override
  String get messagesHidden => 'ocultos:';

  @override
  String get largeMessageWarning => 'Mensaje largo';

  @override
  String get largeMessagePlaintext => 'Mensaje largo mostrado como texto plano';

  @override
  String get reasoningLow => 'Bajo';

  @override
  String get reasoningMedium => 'Medio';

  @override
  String get reasoningHigh => 'Alto';

  @override
  String get editSessionLabel => 'Etiqueta de sesión';

  @override
  String get discordBotSetup => 'Configuración del bot de Discord';

  @override
  String get discordBotSetupDesc =>
      'Crea un bot en el Portal de Desarrolladores de Discord.';

  @override
  String get stepCreateApp =>
      'Ve al Portal de Desarrolladores de Discord y crea una aplicación';

  @override
  String get stepAddBot => 'Ve a la pestaña Bot y añade un bot';

  @override
  String get stepEnableIntents =>
      'Activa Message Content Intent en Privileged Intents';

  @override
  String get stepCopyToken => 'Copia el token del bot e introdúcelo abajo';

  @override
  String get connectingDiscordBot => 'Conectando tu bot de Discord...';

  @override
  String get connectingDiscordBotDesc =>
      'Por favor espera mientras conectamos con tu bot.\nEsto suele tardar unos segundos.';

  @override
  String get discordBotRestarting => 'Reiniciando tu bot...';

  @override
  String get discordBotRestartingDesc =>
      'Tu bot se está reiniciando con la nueva configuración.\nEsto suele tardar unos segundos.';

  @override
  String get discordNoPendingCodes =>
      'Envía un DM a tu bot de Discord y el código de emparejamiento aparecerá aquí.';

  @override
  String get discordPairing => 'Emparejamiento de Discord';

  @override
  String get discordPairingDesc =>
      'Introduce el código de autenticación que aparece al enviar un DM al bot.';

  @override
  String get webAccess => 'Acceso Web';

  @override
  String get webAccessPreparing => 'Preparando acceso web...';

  @override
  String get webAccessPreparingHint =>
      'La configuración SSL puede tardar 15 minutos o más';

  @override
  String get gatewayNetwork => 'Red';

  @override
  String get gatewayCertificate => 'Certificado';

  @override
  String get remoteView => 'Vista Remota';

  @override
  String get remoteViewDescription => 'Ver pantalla del agente en tiempo real';

  @override
  String get vncConnecting => 'Conectando...';

  @override
  String get vncConnected => 'Conectado';

  @override
  String get vncDisconnected => 'Desconectado';

  @override
  String get vncError => 'Error de conexión';

  @override
  String get aiUsage => 'Uso de IA';

  @override
  String get resetsWeekly => 'Se reinicia semanalmente';

  @override
  String get resetsMonthly => 'Se reinicia mensualmente';

  @override
  String get resetsDaily => 'Se reinicia diariamente';

  @override
  String get orDivider => 'O';

  @override
  String get viewOnWeb => 'Ver en ClawHub';

  @override
  String get defaultModel => 'Modelo predeterminado';

  @override
  String get searchModels => 'Buscar modelos...';

  @override
  String get noModelsFound => 'No se encontraron modelos';

  @override
  String get gatewayRestartNotice =>
      'Modelo cambiado. El gateway se está reiniciando...';

  @override
  String get changeDefaultModelError =>
      'Error al cambiar el modelo predeterminado';

  @override
  String get commonContinue => 'Continuar';

  @override
  String get onboardingBadgeTopApp => '#1 App OpenClaw';

  @override
  String get onboardingWelcomeTitle =>
      'Tu agente de IA.\nListo en 60 segundos.';

  @override
  String get onboardingWelcomeSubtitle =>
      'Sin configuración. Sin claves API. Sin conocimientos técnicos.';

  @override
  String get onboardingGithubStarsBadge => '200K+ estrellas en GitHub';

  @override
  String get onboardingPoweredByModels =>
      'Impulsado por más de 400 modelos de IA';

  @override
  String get onboardingQuoteSamAltman =>
      '“Un genio con ideas asombrosas sobre el futuro de agentes muy inteligentes”';

  @override
  String get onboardingQuoteSamAltmanAttribution =>
      '— Sam Altman, CEO de OpenAI';

  @override
  String get onboardingGithubStarCount => '200,000+';

  @override
  String get onboardingGithubStarsLabel => 'Estrellas en GitHub';

  @override
  String get onboardingGithubFastestGrowing =>
      'El proyecto de más rápido crecimiento en la historia de GitHub';

  @override
  String get onboardingGithubStarsSingleDay =>
      '25,310 estrellas en un solo día';

  @override
  String get onboardingTweetsSectionTitle =>
      'Respaldado por líderes en IA y tecnología';

  @override
  String get onboardingEasySetupTitle =>
      'Configuración en 60 segundos.\nNo se necesita experiencia.';

  @override
  String get onboardingEasySetupSubtitle =>
      'No necesitas saber nada técnico. Nosotros nos encargamos del resto.';

  @override
  String get onboardingEasySetupNoApiKeys => 'Sin claves API necesarias';

  @override
  String get onboardingEasySetupNoTerminal =>
      'Sin terminal ni línea de comandos';

  @override
  String get onboardingEasySetupNoServer => 'Sin Mac Mini ni servidor';

  @override
  String get onboardingEasySetupNoTechKnowledge => 'Sin conocimientos técnicos';

  @override
  String get onboardingSafeByDesignTitle =>
      'Seguro por diseño.\nTus datos, tus reglas.';

  @override
  String get onboardingSafeByDesignPressQuote =>
      '“ClawBox es una sensación de IA, pero su seguridad sigue en desarrollo”';

  @override
  String get onboardingSafeByDesignSubtitle =>
      'Tu agente se ejecuta en un entorno AWS completamente aislado. Comparte solo lo que quieras. Tu agente, tu espacio.';

  @override
  String get onboardingSafeByDesignCheck1 =>
      'Entorno de nube completamente separado';

  @override
  String get onboardingSafeByDesignCheck2 =>
      'Tú controlas a qué accede tu agente';

  @override
  String get onboardingSafeByDesignCheck3 =>
      'Computación independiente, no compartida';

  @override
  String get commonLogout => 'Cerrar sesión';

  @override
  String get onboardingFullFeaturesTitle =>
      '100% ClawBox.\nTodas las funciones incluidas.';

  @override
  String get onboardingFullFeaturesSubtitle =>
      'Todo lo que tu ordenador puede hacer, Atlas lo hace por ti:';

  @override
  String get onboardingFullFeaturesExample1 =>
      '“Revisa mis correos y redacta respuestas para los que necesiten atención”';

  @override
  String get onboardingFullFeaturesExample2 =>
      '“Vuelve a pedir la leche que compré la última vez en Amazon”';

  @override
  String get onboardingFullFeaturesExample3 =>
      '“Planifica un viaje de 5 noches a Las Vegas — vuelos, hoteles — y envíame el itinerario por correo”';

  @override
  String get onboardingFullFeaturesTagline =>
      'Sin límites. Sin curva de aprendizaje. Solo resultados.';

  @override
  String get newPaywallTitle => 'Desbloquea todo el poder de tu agente';

  @override
  String get newPaywallSubtitle =>
      'Todo está configurado. Empieza a usar tu agente ahora.';

  @override
  String get newPaywallBenefit1 => 'Ordenador en la nube dedicado — 24/7';

  @override
  String get newPaywallBenefit2 => 'Más de 400 modelos de IA — ilimitado';

  @override
  String get newPaywallBenefit3 => 'Más de 100 AgentSkills — listas para usar';

  @override
  String get newPaywallFaqPriceQuestion => '¿Por qué este precio?';

  @override
  String get newPaywallFaqPriceAnswer =>
      'Asignamos un ordenador en la nube dedicado solo para ti, funcionando 24/7, con acceso ilimitado a más de 400 modelos de IA. Este es el coste real de un agente de IA personal que realmente funciona.';

  @override
  String get newPaywallFaqCheaperQuestion => '¿Hay alternativas más baratas?';

  @override
  String get newPaywallFaqCheaperAnswer =>
      'Un entorno dedicado real con acceso real a modelos de IA requiere infraestructura real. No escatimamos — tu agente funciona en su propia nube aislada, no en recursos compartidos.';

  @override
  String get newPaywallPeriodWeek => '/ semana';

  @override
  String get newPaywallPeriodMonth => '/ mes';

  @override
  String get newPaywallBestValueBadge => 'MEJOR VALOR';

  @override
  String get newPaywallStartNowButton => 'Empezar ahora';

  @override
  String get newPaywallRestorePurchase => 'Restaurar compra';

  @override
  String get newPaywallHaveReferralCode => '¿Tienes un código de referencia?';

  @override
  String get newPaywallSocialProof => 'Más de 200.000 agentes desplegados';

  @override
  String get newPaywallReferralSheetTitle => 'Ingresar código de referencia';

  @override
  String get newPaywallReferralHint => 'ej. FRIEND2024';

  @override
  String get newPaywallReferralApplyButton => 'Aplicar';

  @override
  String get newPaywallReferralAppliedSuccess =>
      '¡Código de referencia aplicado!';

  @override
  String get newPaywallReferralInvalid => 'Código de referencia inválido';

  @override
  String get userProfileTitle => 'Cuéntanos sobre ti';

  @override
  String get userProfileSubtitle =>
      'Para que tu agente sepa para quién trabaja';

  @override
  String get userProfileNameLabel => 'Tu nombre';

  @override
  String get userProfileNameHint => 'Juan García';

  @override
  String get userProfileCallNameLabel => '¿Cómo deberíamos llamarte?';

  @override
  String get userProfileCallNameHint => 'Juan';

  @override
  String get taskSelectionTitle => '¿Qué debería hacer tu agente?';

  @override
  String get taskSelectionSubtitle => 'Selecciona al menos 1';

  @override
  String get taskOptionEmailManagement => 'Gestión de correo';

  @override
  String get taskOptionWebResearch => 'Investigación web';

  @override
  String get taskOptionTaskAutomation => 'Automatización de tareas';

  @override
  String get taskOptionScheduling => 'Programación';

  @override
  String get taskOptionSocialMedia => 'Redes sociales';

  @override
  String get taskOptionWriting => 'Escritura';

  @override
  String get taskOptionDataAnalysis => 'Análisis de datos';

  @override
  String get taskOptionSmartHome => 'Hogar inteligente';

  @override
  String get vibeSelectionTitle => 'Define el estilo de tu agente';

  @override
  String get vibeSelectionSubtitle => '¿Cómo debería comunicarse tu agente?';

  @override
  String get vibeNameCasual => 'Casual';

  @override
  String get vibeDescCasual =>
      'Relajado y amigable. Como enviar mensajes a un amigo inteligente.';

  @override
  String get vibeNameProfessional => 'Profesional';

  @override
  String get vibeDescProfessional =>
      'Claro y estructurado. Comunicación lista para negocios.';

  @override
  String get vibeNameFriendly => 'Amigable';

  @override
  String get vibeDescFriendly => 'Cálido y alentador. Siempre positivo y útil.';

  @override
  String get vibeNameDirect => 'Directo';

  @override
  String get vibeDescDirect =>
      'Directo al grano. Sin rodeos, máxima eficiencia.';

  @override
  String get agentCreationTitle => 'Crea tu agente';

  @override
  String get agentCreationSubtitle =>
      'Elige un aspecto y personalidad para tu agente';

  @override
  String get agentCreationNameLabel => 'Nombre del agente';

  @override
  String get agentCreationNameHint => 'Atlas';

  @override
  String get agentCreationCreatureLabel => 'Tipo de criatura';

  @override
  String get agentCreationEmojiLabel => 'Emoji del agente';

  @override
  String get creatureCat => 'Gato';

  @override
  String get creatureDragon => 'Dragón';

  @override
  String get creatureFox => 'Zorro';

  @override
  String get creatureOwl => 'Búho';

  @override
  String get creatureRabbit => 'Conejo';

  @override
  String get creatureBear => 'Oso';

  @override
  String get creatureDino => 'Dinosaurio';

  @override
  String get creaturePenguin => 'Pingüino';

  @override
  String get creaturePerson => 'Persona';

  @override
  String get creatureWolf => 'Lobo';

  @override
  String get creaturePanda => 'Panda';

  @override
  String get creatureUnicorn => 'Unicornio';

  @override
  String get commonFallbackFriend => 'amigo';

  @override
  String get commonFallbackYourAgent => 'tu agente';

  @override
  String get fakeLoadingStep1 => 'Perfil configurado';

  @override
  String get fakeLoadingStep2 => 'Personalidad establecida';

  @override
  String get fakeLoadingStep3 => 'Desplegando en la nube...';

  @override
  String get fakeLoadingStep4 => 'Conectando más de 400 modelos de IA';

  @override
  String get fakeLoadingStep5 => 'Asignando recursos de computación';

  @override
  String get fakeLoadingStep6 => 'Cargando más de 100 AgentSkills';

  @override
  String get fakeLoadingStep7 => 'Configurando espacio de trabajo del agente';

  @override
  String fakeLoadingTitle(String callName) {
    return 'Hey $callName, espera un momento...';
  }

  @override
  String get fakeLoadingSubtitle =>
      'Estamos configurando tu agente en la nube.\nTu agente personal está casi listo.';

  @override
  String get agentCompleteSubtitle =>
      'Tu agente está completamente desplegado y optimizado para tus tareas.';

  @override
  String get agentCompleteStatus1 => 'Agente 24/7 — siempre activo';

  @override
  String get agentCompleteStatus2 => 'Más de 400 modelos de IA — conectados';

  @override
  String get agentCompleteStatus3 => 'Más de 100 AgentSkills — cargados';

  @override
  String get agentCompleteStatus4 => 'Recursos de computación — asegurados';

  @override
  String agentCompleteTitle(String agentName, String callName) {
    return '¡$agentName está listo, $callName!';
  }

  @override
  String get agentCompleteOptimizedForLabel => 'OPTIMIZADO PARA';

  @override
  String agentCompleteLiveHint(String agentName) {
    return '$agentName está activo y esperándote';
  }
}
