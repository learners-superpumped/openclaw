import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
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
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: false,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.accent,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.chatTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 15),
                ),
                _buildConnectionStatus(chatState.connectionState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(ChatConnectionState connectionState) {
    final l10n = AppLocalizations.of(context)!;
    Color dotColor;
    String label;
    switch (connectionState) {
      case ChatConnectionState.connected:
        dotColor = AppColors.accentGreen;
        label = l10n.statusOnline;
        break;
      case ChatConnectionState.connecting:
      case ChatConnectionState.authenticating:
        dotColor = AppColors.warning;
        label = l10n.statusConnecting;
        break;
      case ChatConnectionState.error:
      case ChatConnectionState.disconnected:
        dotColor = AppColors.error;
        label = l10n.statusOffline;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textTertiary,
            fontSize: 11,
          ),
        ),
      ],
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
    final l10n = AppLocalizations.of(context)!;
    String message;
    switch (connectionState) {
      case ChatConnectionState.connecting:
        message = l10n.statusConnecting;
        break;
      case ChatConnectionState.authenticating:
        message = l10n.statusAuthenticating;
        break;
      default:
        message = l10n.statusWaitingForConnection;
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
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.accent,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.emptyChatTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.emptyChatSubtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(
    List<ChatMessage> messages,
    ChatMessage? streamingMessage,
  ) {
    // Build a flat list of all messages including streaming
    final allMessages = <ChatMessage>[...messages, ?streamingMessage];

    // Compute group info for each message
    final groupInfo = _computeGroupInfo(allMessages);

    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: allMessages.length,
      itemBuilder: (context, index) {
        // reversed list: index 0 = most recent
        final messageIndex = allMessages.length - 1 - index;
        final message = allMessages[messageIndex];
        final info = groupInfo[messageIndex];

        final bubble = ChatMessageBubble(
          message: message,
          isFirstInGroup: info.isFirstInGroup,
          isLastInGroup: info.isLastInGroup,
        );

        // Spacing: 2px within group, 16px between groups
        final bottomSpacing = info.isLastInGroup ? 16.0 : 2.0;

        // Date separator (shown above the message, but since list is reversed,
        // we place it below the bubble in code)
        if (info.showDateSeparator) {
          return Column(
            children: [
              _buildDateSeparator(message.timestamp),
              Padding(
                padding: EdgeInsets.only(bottom: bottomSpacing),
                child: bubble,
              ),
            ],
          );
        }

        return Padding(
          padding: EdgeInsets.only(bottom: bottomSpacing),
          child: bubble,
        );
      },
    );
  }

  List<_MessageGroupInfo> _computeGroupInfo(List<ChatMessage> messages) {
    final infos = List.generate(messages.length, (_) => _MessageGroupInfo());

    for (var i = 0; i < messages.length; i++) {
      final current = messages[i];
      final prev = i > 0 ? messages[i - 1] : null;
      final next = i < messages.length - 1 ? messages[i + 1] : null;

      // First in group: no previous, or different role, or different date
      infos[i].isFirstInGroup =
          prev == null ||
          prev.role != current.role ||
          !_isSameDay(prev.timestamp, current.timestamp);

      // Last in group: no next, or different role, or different date
      infos[i].isLastInGroup =
          next == null ||
          next.role != current.role ||
          !_isSameDay(current.timestamp, next.timestamp);

      // Show date separator if first message or different day from previous
      infos[i].showDateSeparator =
          prev == null || !_isSameDay(prev.timestamp, current.timestamp);
    }

    return infos;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildDateSeparator(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(date.year, date.month, date.day);
    final diff = today.difference(messageDay).inDays;

    final l10n = AppLocalizations.of(context)!;
    String label;
    if (diff == 0) {
      label = l10n.dateToday;
    } else if (diff == 1) {
      label = l10n.dateYesterday;
    } else {
      label = DateFormat('MMM d, yyyy').format(date);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
              fontSize: 11,
            ),
          ),
        ),
      ),
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
              AppLocalizations.of(context)!.connectionError,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.textPrimary),
            ),
            if (chatState.error != null) ...[
              const SizedBox(height: 8),
              Text(
                chatState.error!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
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
              label: Text(AppLocalizations.of(context)!.reconnect),
              style: FilledButton.styleFrom(minimumSize: const Size(160, 48)),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageGroupInfo {
  bool isFirstInGroup = true;
  bool isLastInGroup = true;
  bool showDateSeparator = false;
}
