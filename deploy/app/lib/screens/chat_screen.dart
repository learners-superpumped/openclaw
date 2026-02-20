import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat_message.dart';
import '../providers/api_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/instance_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_message_bubble.dart';
import 'package:clawbox/l10n/app_localizations.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with WidgetsBindingObserver {
  static const _consentKey = 'ai_data_consent_accepted';
  ChatNotifier? _chatNotifier;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() {
      if (mounted) _checkConsentAndConnect();
    });
  }

  Future<void> _checkConsentAndConnect() async {
    final storage = ref.read(secureStorageProvider);
    final consent = await storage.read(key: _consentKey);
    if (consent == 'true') {
      _connectWhenReady();
      return;
    }
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final agreed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text(l10n.aiDataConsentTitle),
        content: Text(l10n.aiDataConsentMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              l10n.decline,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.agree,
              style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
    if (agreed == true) {
      await storage.write(key: _consentKey, value: 'true');
      if (mounted) _connectWhenReady();
    } else {
      if (mounted) Navigator.of(context).pop();
    }
  }

  void _connectWhenReady() {
    final instanceState = ref.read(instanceProvider);
    if (instanceState.status == InstanceStatus.ready &&
        instanceState.instance != null) {
      final chatState = ref.read(chatProvider);
      if (chatState.connectionState == ChatConnectionState.disconnected ||
          chatState.connectionState == ChatConnectionState.error) {
        _chatNotifier ??= ref.read(chatProvider.notifier);
        _chatNotifier!.connect(instanceState.instance!.instanceId);
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        ref.read(chatProvider.notifier).disconnect();
        break;
      case AppLifecycleState.resumed:
        _connectWhenReady();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final notifier = _chatNotifier;
    super.dispose();
    if (notifier != null) {
      Future.microtask(() => notifier.disconnect());
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);

    // When instance becomes ready, connect automatically
    ref.listen<InstanceState>(instanceProvider, (previous, next) {
      if (previous != null &&
          previous.status != InstanceStatus.ready &&
          next.status == InstanceStatus.ready &&
          next.instance != null) {
        Future.microtask(() {
          if (mounted) {
            ref.read(chatProvider.notifier).connect(next.instance!.instanceId);
          }
        });
      }
    });

    return Scaffold(
      appBar: _buildAppBar(chatState),
      body: _buildBody(chatState),
    );
  }

  PreferredSizeWidget _buildAppBar(ChatState chatState) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Chat',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: [
        _buildConnectionDot(chatState.connectionState),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildConnectionDot(ChatConnectionState connectionState) {
    Color dotColor;
    switch (connectionState) {
      case ChatConnectionState.connected:
        dotColor = AppColors.accentGreen;
        break;
      case ChatConnectionState.connecting:
      case ChatConnectionState.authenticating:
        dotColor = AppColors.warning;
        break;
      case ChatConnectionState.error:
      case ChatConnectionState.disconnected:
        dotColor = AppColors.error;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: dotColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildBody(ChatState chatState) {
    switch (chatState.connectionState) {
      case ChatConnectionState.disconnected:
      case ChatConnectionState.connecting:
      case ChatConnectionState.authenticating:
        return _buildLoadingState(chatState.connectionState);
      case ChatConnectionState.connected:
        return _buildConnectedState(chatState);
      case ChatConnectionState.error:
        return _buildErrorState(chatState);
    }
  }

  Widget _buildLoadingState(ChatConnectionState connectionState) {
    String message;
    switch (connectionState) {
      case ChatConnectionState.connecting:
        message = 'Connecting...';
        break;
      case ChatConnectionState.authenticating:
        message = 'Authenticating...';
        break;
      default:
        message = 'Waiting for connection...';
        break;
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedState(ChatState chatState) {
    final messages = chatState.messages;
    final streamingMessage = chatState.streamingMessage;

    return Column(
      children: [
        Expanded(
          child: messages.isEmpty && streamingMessage == null
              ? _buildEmptyState()
              : _buildMessageList(messages, streamingMessage),
        ),
        const ChatInputBar(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.accent,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Start a conversation',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Send a message to begin chatting with AI',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(
    List<ChatMessage> messages,
    ChatMessage? streamingMessage,
  ) {
    final totalItems =
        messages.length + (streamingMessage != null ? 1 : 0);

    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        if (streamingMessage != null && index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ChatMessageBubble(message: streamingMessage),
          );
        }

        final offset = streamingMessage != null ? index - 1 : index;
        final messageIndex = messages.length - 1 - offset;
        final message = messages[messageIndex];

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ChatMessageBubble(message: message),
        );
      },
    );
  }

  Widget _buildErrorState(ChatState chatState) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Connection Error',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.textPrimary),
            ),
            if (chatState.error != null) ...[
              const SizedBox(height: 8),
              Text(
                chatState.error!,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                final instanceState = ref.read(instanceProvider);
                if (instanceState.instance != null) {
                  ref
                      .read(chatProvider.notifier)
                      .connect(instanceState.instance!.instanceId);
                }
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reconnect'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(160, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
