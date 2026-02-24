import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/usage.dart';
import 'api_provider.dart';

class UsageState {
  final Usage? usage;
  final bool isLoading;

  const UsageState({this.usage, this.isLoading = false});

  UsageState copyWith({Usage? usage, bool? isLoading}) {
    return UsageState(
      usage: usage ?? this.usage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class UsageNotifier extends StateNotifier<UsageState> {
  final Ref _ref;

  UsageNotifier(this._ref) : super(const UsageState());

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    try {
      final apiClient = _ref.read(apiClientProvider);
      final usage = await apiClient.getUsage();
      state = UsageState(usage: usage);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final usageProvider = StateNotifierProvider<UsageNotifier, UsageState>((ref) {
  return UsageNotifier(ref);
});
