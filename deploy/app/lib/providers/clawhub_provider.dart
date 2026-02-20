import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/skill.dart';
import 'api_provider.dart';
import 'instance_provider.dart';

class ClawHubState {
  final List<BrowseSkillItem> skills;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final String? searchQuery;
  final String? cursor;
  final bool hasMore;
  final Set<String> installingSlugs;
  final Set<String> uninstallingSlugs;
  final bool filterInstalled;

  const ClawHubState({
    this.skills = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.searchQuery,
    this.cursor,
    this.hasMore = true,
    this.installingSlugs = const {},
    this.uninstallingSlugs = const {},
    this.filterInstalled = false,
  });

  ClawHubState copyWith({
    List<BrowseSkillItem>? skills,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    String? searchQuery,
    String? cursor,
    bool? hasMore,
    Set<String>? installingSlugs,
    Set<String>? uninstallingSlugs,
    bool? filterInstalled,
  }) {
    return ClawHubState(
      skills: skills ?? this.skills,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      cursor: cursor ?? this.cursor,
      hasMore: hasMore ?? this.hasMore,
      installingSlugs: installingSlugs ?? this.installingSlugs,
      uninstallingSlugs: uninstallingSlugs ?? this.uninstallingSlugs,
      filterInstalled: filterInstalled ?? this.filterInstalled,
    );
  }
}

class ClawHubNotifier extends StateNotifier<ClawHubState> {
  final Ref _ref;

  ClawHubNotifier(this._ref) : super(const ClawHubState());

  String? get _instanceId => _ref.read(instanceProvider).instance?.instanceId;

  Future<void> loadSkills({String? q}) async {
    final instanceId = _instanceId;
    if (instanceId == null) return;

    state = ClawHubState(
      isLoading: true,
      searchQuery: q,
      installingSlugs: state.installingSlugs,
      uninstallingSlugs: state.uninstallingSlugs,
      filterInstalled: state.filterInstalled,
    );
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.browseSkills(instanceId, q: q);
      state = state.copyWith(
        skills: response.skills,
        cursor: response.cursor,
        hasMore: response.cursor != null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    final instanceId = _instanceId;
    if (instanceId == null || !state.hasMore || state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true);
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.browseSkills(
        instanceId,
        q: state.searchQuery,
        cursor: state.cursor,
      );
      state = state.copyWith(
        skills: [...state.skills, ...response.skills],
        cursor: response.cursor,
        hasMore: response.cursor != null,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  Future<void> installSkill(String slug) async {
    final instanceId = _instanceId;
    if (instanceId == null) return;

    state = state.copyWith(
      installingSlugs: {...state.installingSlugs, slug},
    );
    try {
      final apiClient = _ref.read(apiClientProvider);
      await apiClient.installSkill(instanceId, slug);
      if (state.filterInstalled) {
        await loadInstalledSkills();
      } else {
        await loadSkills(q: state.searchQuery);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(
        installingSlugs: {...state.installingSlugs}..remove(slug),
      );
    }
  }

  Future<void> uninstallSkill(String slug) async {
    final instanceId = _instanceId;
    if (instanceId == null) return;

    state = state.copyWith(
      uninstallingSlugs: {...state.uninstallingSlugs, slug},
    );
    try {
      final apiClient = _ref.read(apiClientProvider);
      await apiClient.uninstallSkill(instanceId, slug);
      if (state.filterInstalled) {
        await loadInstalledSkills();
      } else {
        await loadSkills(q: state.searchQuery);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(
        uninstallingSlugs: {...state.uninstallingSlugs}..remove(slug),
      );
    }
  }

  void setFilterInstalled(bool value) {
    state = state.copyWith(filterInstalled: value);
    if (value) {
      loadInstalledSkills();
    } else {
      loadSkills(q: state.searchQuery);
    }
  }

  Future<void> loadInstalledSkills() async {
    final instanceId = _instanceId;
    if (instanceId == null) return;

    state = state.copyWith(isLoading: true);
    try {
      final apiClient = _ref.read(apiClientProvider);
      final items = await apiClient.getInstalledSkills(instanceId);
      final skills = items.map((e) => BrowseSkillItem.fromInstalledJson(e)).toList();
      state = state.copyWith(skills: skills, isLoading: false, hasMore: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  List<BrowseSkillItem> get filteredSkills => state.skills;

  Future<BrowseSkillDetail> getSkillDetail(String slug) async {
    final instanceId = _instanceId;
    if (instanceId == null) throw Exception('No instance');

    final apiClient = _ref.read(apiClientProvider);
    return apiClient.browseSkillDetail(instanceId, slug);
  }
}

final clawHubProvider = StateNotifierProvider<ClawHubNotifier, ClawHubState>((ref) {
  return ClawHubNotifier(ref);
});
