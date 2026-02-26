import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/instance.dart';
import 'api_provider.dart';
import 'channel_provider.dart';
import 'onboarding_provider.dart';
import 'usage_provider.dart';

const _kTelegramSetupSkipped = 'telegram_setup_skipped';

enum InstanceStatus { idle, creating, polling, ready, error }

class InstanceState {
  final InstanceStatus status;
  final Instance? instance;
  final String? error;

  const InstanceState({
    this.status = InstanceStatus.idle,
    this.instance,
    this.error,
  });

  InstanceState copyWith({
    InstanceStatus? status,
    Instance? instance,
    String? error,
  }) {
    return InstanceState(
      status: status ?? this.status,
      instance: instance ?? this.instance,
      error: error,
    );
  }
}

class InstanceNotifier extends StateNotifier<InstanceState> {
  final Ref _ref;
  Timer? _pollTimer;

  InstanceNotifier(this._ref) : super(const InstanceState());

  Future<void> ensureInstance() async {
    state = state.copyWith(status: InstanceStatus.creating);
    try {
      final apiClient = _ref.read(apiClientProvider);
      final instances = await apiClient.listInstances();
      if (instances.isNotEmpty) {
        final instance = instances.first;
        if (instance.isReady) {
          await _checkTelegramSetup(instance);
          state = InstanceState(
            status: InstanceStatus.ready,
            instance: instance,
          );
        } else {
          state = InstanceState(
            status: InstanceStatus.polling,
            instance: instance,
          );
          _startPolling(instance.instanceId);
        }
      } else {
        await createAndPoll();
      }
    } catch (e) {
      _ref
          .read(analyticsProvider)
          .logInstanceCreationFailed(error: e.toString());
      state = InstanceState(status: InstanceStatus.error, error: e.toString());
    }
  }

  Future<void> createAndPoll() async {
    state = state.copyWith(status: InstanceStatus.creating);
    try {
      final apiClient = _ref.read(apiClientProvider);
      final instance = await apiClient.createInstance();
      state = InstanceState(status: InstanceStatus.polling, instance: instance);
      _startPolling(instance.instanceId);
    } catch (e) {
      _ref
          .read(analyticsProvider)
          .logInstanceCreationFailed(error: e.toString());
      state = InstanceState(status: InstanceStatus.error, error: e.toString());
    }
  }

  Future<void> loadExisting() async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final instances = await apiClient.listInstances();
      if (instances.isNotEmpty) {
        final instance = instances.first;
        if (instance.isReady) {
          await _checkTelegramSetup(instance);
          state = InstanceState(
            status: InstanceStatus.ready,
            instance: instance,
          );
        } else {
          state = InstanceState(
            status: InstanceStatus.polling,
            instance: instance,
          );
          _startPolling(instance.instanceId);
        }
      }
    } catch (e) {
      state = InstanceState(status: InstanceStatus.error, error: e.toString());
    }
  }

  void _startPolling(String instanceId) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      try {
        final apiClient = _ref.read(apiClientProvider);
        final instance = await apiClient.getInstance(instanceId);
        state = state.copyWith(instance: instance);
        if (instance.isReady) {
          _pollTimer?.cancel();
          _ref.read(analyticsProvider).logInstanceCreationCompleted();
          await _checkTelegramSetup(instance);
          state = state.copyWith(status: InstanceStatus.ready);
        }
      } catch (_) {}
    });
  }

  Future<void> _checkTelegramSetup(Instance instance) async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final status = await apiClient.getTelegramStatus(instance.instanceId);
      final telegram = status['telegram'] as Map<String, dynamic>?;
      final accounts = status['accounts'] as List?;
      if (telegram?['configured'] == true &&
          accounts != null &&
          accounts.isNotEmpty) {
        _ref.read(setupProgressProvider.notifier).state =
            OnboardingStep.dashboard;
      } else {
        final storage = _ref.read(secureStorageProvider);
        final skipped = await storage.read(key: _kTelegramSetupSkipped);
        if (skipped == 'true') {
          _ref.read(setupProgressProvider.notifier).state =
              OnboardingStep.dashboard;
        }
      }
    } catch (_) {}
  }

  Future<void> deleteInstance() async {
    final instance = state.instance;
    if (instance == null) return;
    final apiClient = _ref.read(apiClientProvider);
    await apiClient.deleteInstance(instance.instanceId);
    resetState();
  }

  Future<void> refresh({bool includeChannels = false}) async {
    if (state.instance != null) {
      try {
        final apiClient = _ref.read(apiClientProvider);
        final includes = <String>[];
        if (includeChannels) includes.add('channels');
        includes.add('usage');

        final instance = await apiClient.getInstance(
          state.instance!.instanceId,
          include: includes,
          probe: includeChannels,
        );
        state = state.copyWith(instance: instance);

        if (instance.channels != null) {
          _ref
              .read(channelProvider.notifier)
              .updateFromEmbedded(instance.channels!);
        }
        if (instance.usage != null) {
          _ref.read(usageProvider.notifier).updateFromInstance(instance.usage!);
        }
      } catch (_) {}
    }
  }

  void resetState() {
    _pollTimer?.cancel();
    state = const InstanceState();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }
}

final instanceProvider = StateNotifierProvider<InstanceNotifier, InstanceState>(
  (ref) {
    return InstanceNotifier(ref);
  },
);
