import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class ProfileState {
  final String userName;
  final String callName;
  final String agentName;
  final String? creature;
  final String? agentEmoji;
  final String? vibe;
  final Set<String> tasks;

  const ProfileState({
    this.userName = '',
    this.callName = '',
    this.agentName = '',
    this.creature,
    this.agentEmoji,
    this.vibe,
    this.tasks = const {},
  });

  ProfileState copyWith({
    String? userName,
    String? callName,
    String? agentName,
    String? creature,
    String? agentEmoji,
    String? vibe,
    Set<String>? tasks,
  }) {
    return ProfileState(
      userName: userName ?? this.userName,
      callName: callName ?? this.callName,
      agentName: agentName ?? this.agentName,
      creature: creature ?? this.creature,
      agentEmoji: agentEmoji ?? this.agentEmoji,
      vibe: vibe ?? this.vibe,
      tasks: tasks ?? this.tasks,
    );
  }

  bool get isUserProfileComplete => userName.isNotEmpty && callName.isNotEmpty;
  bool get isAgentCreationComplete => agentName.isNotEmpty;
  bool get isVibeComplete => vibe != null;
  bool get isTaskSelectionComplete => tasks.isNotEmpty;

  /// Convert to API profile format for POST /instances
  Map<String, dynamic> toApiProfile() {
    return {
      'user': {
        if (userName.isNotEmpty) 'name': userName,
        if (callName.isNotEmpty) 'callName': callName,
        if (tasks.isNotEmpty) 'notes': tasks.join(', '),
        'timezone': DateTime.now().timeZoneName,
      },
      'agent': {
        if (agentName.isNotEmpty) 'name': agentName,
        if (creature != null) 'creature': creature,
        if (vibe != null) 'vibe': vibe,
        if (agentEmoji != null) 'emoji': agentEmoji,
      },
    };
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(const ProfileState());

  void setUserProfile({required String userName, required String callName}) {
    state = state.copyWith(userName: userName, callName: callName);
  }

  void setAgentCreation({
    required String agentName,
    String? creature,
    String? agentEmoji,
  }) {
    state = state.copyWith(
      agentName: agentName,
      creature: creature,
      agentEmoji: agentEmoji,
    );
  }

  void setVibe(String vibe) {
    state = state.copyWith(vibe: vibe);
  }

  void toggleTask(String task) {
    final tasks = Set<String>.from(state.tasks);
    if (tasks.contains(task)) {
      tasks.remove(task);
    } else {
      tasks.add(task);
    }
    state = state.copyWith(tasks: tasks);
  }

  void reset() {
    state = const ProfileState();
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(),
);
