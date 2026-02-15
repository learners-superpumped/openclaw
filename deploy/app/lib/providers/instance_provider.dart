import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/instance.dart';
import 'api_provider.dart';

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

  InstanceState copyWith({InstanceStatus? status, Instance? instance, String? error}) {
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
          state = InstanceState(status: InstanceStatus.ready, instance: instance);
        } else {
          state = InstanceState(status: InstanceStatus.polling, instance: instance);
          _startPolling(instance.instanceId);
        }
      } else {
        await createAndPoll();
      }
    } catch (e) {
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
          state = InstanceState(status: InstanceStatus.ready, instance: instance);
        } else {
          state = InstanceState(status: InstanceStatus.polling, instance: instance);
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
          state = state.copyWith(status: InstanceStatus.ready);
        }
      } catch (_) {}
    });
  }

  Future<void> refresh() async {
    if (state.instance != null) {
      try {
        final apiClient = _ref.read(apiClientProvider);
        final instance = await apiClient.getInstance(state.instance!.instanceId);
        state = state.copyWith(instance: instance);
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }
}

final instanceProvider = StateNotifierProvider<InstanceNotifier, InstanceState>((ref) {
  return InstanceNotifier(ref);
});
