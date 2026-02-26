import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ai_model.dart';
import 'api_provider.dart';

class ModelConfigState {
  final List<AiModel> models;
  final String? defaultModel;
  final String? configHash;
  final bool isLoading;

  const ModelConfigState({
    this.models = const [],
    this.defaultModel,
    this.configHash,
    this.isLoading = false,
  });

  ModelConfigState copyWith({
    List<AiModel>? models,
    String? defaultModel,
    String? configHash,
    bool? isLoading,
  }) {
    return ModelConfigState(
      models: models ?? this.models,
      defaultModel: defaultModel ?? this.defaultModel,
      configHash: configHash ?? this.configHash,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Find the AiModel matching the current defaultModel ref.
  AiModel? get currentModel {
    if (defaultModel == null || models.isEmpty) return null;
    // defaultModel is gateway ref like "openrouter/anthropic/claude-opus-4-6"
    // AiModel.gatewayModelRef produces the same format
    try {
      return models.firstWhere((m) => m.gatewayModelRef == defaultModel);
    } catch (_) {
      return null;
    }
  }
}

class ModelConfigNotifier extends StateNotifier<ModelConfigState> {
  final Ref _ref;

  ModelConfigNotifier(this._ref) : super(const ModelConfigState());

  Future<void> load(String instanceId) async {
    state = state.copyWith(isLoading: true);
    try {
      final apiClient = _ref.read(apiClientProvider);
      final results = await Future.wait([
        apiClient.listModels(),
        apiClient.instanceRpc(instanceId, 'config.get'),
      ]);

      final models = results[0] as List<AiModel>;
      final configRes = results[1] as Map<String, dynamic>;

      // REST RPC proxy returns payload directly (no ok/payload wrapper)
      final config = configRes['config'] as Map<String, dynamic>?;
      final configHash = configRes['hash'] as String?;

      final agents = config?['agents'] as Map<String, dynamic>?;
      final defaults = agents?['defaults'] as Map<String, dynamic>?;
      final model = defaults?['model'] as Map<String, dynamic>?;
      final defaultModel = model?['primary'] as String?;

      state = ModelConfigState(
        models: models,
        defaultModel: defaultModel,
        configHash: configHash,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _refreshConfig(String instanceId) async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final configRes = await apiClient.instanceRpc(instanceId, 'config.get');
      final config = configRes['config'] as Map<String, dynamic>?;
      final configHash = configRes['hash'] as String?;

      final agents = config?['agents'] as Map<String, dynamic>?;
      final defaults = agents?['defaults'] as Map<String, dynamic>?;
      final model = defaults?['model'] as Map<String, dynamic>?;
      final defaultModel = model?['primary'] as String?;

      state = state.copyWith(
        defaultModel: defaultModel,
        configHash: configHash,
      );
    } catch (_) {}
  }

  Future<bool> setDefaultModel(
    String instanceId,
    String gatewayModelRef,
  ) async {
    final baseHash = state.configHash;
    if (baseHash == null) return false;

    try {
      final apiClient = _ref.read(apiClientProvider);
      final raw =
          '{"agents":{"defaults":{"model":{"primary":"$gatewayModelRef"}}}}';
      final res = await apiClient.instanceRpc(instanceId, 'config.patch', {
        'raw': raw,
        'baseHash': baseHash,
      });

      // REST RPC proxy returns payload directly
      final ok = res['ok'] as bool? ?? false;
      if (!ok) return false;

      // config.patch doesn't return hash; reload config to get new hash
      state = state.copyWith(defaultModel: gatewayModelRef);
      // Refresh in background to get updated hash
      _refreshConfig(instanceId);
      return true;
    } catch (_) {
      return false;
    }
  }
}

final modelConfigProvider =
    StateNotifierProvider<ModelConfigNotifier, ModelConfigState>((ref) {
      return ModelConfigNotifier(ref);
    });
