import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/chat_message.dart';
import '../providers/api_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/instance_provider.dart';
import '../providers/onboarding_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/ai_consent_sheet.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/compaction_indicator.dart';
import 'package:clawbox/l10n/app_localizations.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with WidgetsBindingObserver {
  static const _consentKey = 'ai_data_consent_v2';
  ChatNotifier? _chatNotifier;
  final ScrollController _scrollController = ScrollController();
  bool _isNearBottom = true;
  bool _showNewMessagesFab = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);
    Future.microtask(() {
      if (mounted) _checkConsentAndConnect();
    });
  }

  void _onScroll() {
    // In reversed list, position 0 is the bottom (newest messages)
    final nearBottom = _scrollController.offset < 100;
    if (nearBottom != _isNearBottom) {
      setState(() {
        _isNearBottom = nearBottom;
        if (nearBottom) _showNewMessagesFab = false;
      });
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _checkConsentAndConnect() async {
    final storage = ref.read(secureStorageProvider);
    final consent = await storage.read(key: _consentKey);
    if (consent == 'true') {
      _connectWhenReady();
      return;
    }
    if (!mounted) return;
    ref.read(analyticsProvider).logChatConsentShown();
    final agreed = await AiConsentSheet.show(context);
    if (agreed == true) {
      ref.read(analyticsProvider).logChatConsentAccepted();
      await storage.write(key: _consentKey, value: 'true');
      if (mounted) {
        ref.read(aiDisclosureAcceptedProvider.notifier).state = true;
        _connectWhenReady();
      }
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
    // On web, the browser maintains WebSocket connections in background tabs,
    // so we only disconnect/reconnect on native platforms.
    if (kIsWeb) return;

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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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

    // Listen for new messages while scrolled up
    ref.listen<ChatState>(chatProvider, (previous, next) {
      if (previous != null &&
          next.messages.length > previous.messages.length &&
          !_isNearBottom) {
        setState(() => _showNewMessagesFab = true);
      }
      // Show snackbar when compaction completes
      if (previous != null &&
          previous.isCompacting &&
          !next.isCompacting &&
          mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.contextCompacted),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
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
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).pop();
        },
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

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          // Compaction indicator
          if (chatState.isCompacting) const CompactionIndicator(),
          Expanded(
            child: Stack(
              children: [
                messages.isEmpty && streamingMessage == null
                    ? _buildEmptyState()
                    : _buildMessageList(messages, streamingMessage, chatState),
                // "New messages" FAB
                if (_showNewMessagesFab)
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _scrollToBottom();
                          setState(() => _showNewMessagesFab = false);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.arrow_downward_rounded,
                                size: 16,
                                color: AppColors.background,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                AppLocalizations.of(context)!.newMessagesBelow,
                                style: const TextStyle(
                                  color: AppColors.background,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const ChatInputBar(),
        ],
      ),
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
    ChatState chatState,
  ) {
    // Build a flat list of all messages including streaming
    final allMessages = <ChatMessage>[...messages, ?streamingMessage];

    // Compute group info for each message
    final groupInfo = _computeGroupInfo(allMessages);

    // History pagination info
    final int? total = chatState.totalMessageCount;
    final int resolvedTotal = total ?? 0;
    final hasHiddenMessages =
        total != null && resolvedTotal > allMessages.length;

    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: allMessages.length + (hasHiddenMessages ? 1 : 0),
      itemBuilder: (context, index) {
        // Extra item at the end (top of reversed list) for pagination info
        if (hasHiddenMessages && index == allMessages.length) {
          return _buildHiddenMessagesInfo(resolvedTotal, allMessages.length);
        }

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

  Widget _buildHiddenMessagesInfo(int total, int showing) {
    final l10n = AppLocalizations.of(context)!;
    final hidden = total - showing;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${l10n.showingLastMessages} $showing (${l10n.messagesHidden} $hidden)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
              fontSize: 11,
            ),
          ),
        ),
      ),
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
                HapticFeedback.lightImpact();
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
