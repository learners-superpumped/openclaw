import 'package:clawbox/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../providers/api_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../providers/profile_provider.dart';
import 'widgets/onboarding_scaffold.dart';

class _TaskOption {
  final String label;
  final IconData icon;

  const _TaskOption({required this.label, required this.icon});
}

class TaskSelectionScreen extends ConsumerStatefulWidget {
  const TaskSelectionScreen({super.key});

  @override
  ConsumerState<TaskSelectionScreen> createState() =>
      _TaskSelectionScreenState();
}

class _TaskSelectionScreenState extends ConsumerState<TaskSelectionScreen> {
  final Set<String> _selectedTasks = {};

  @override
  void initState() {
    super.initState();
    ref.read(analyticsProvider).logOnboardingStepViewed(step: 'task_selection');
  }

  void _onContinue() {
    HapticFeedback.lightImpact();
    ref
        .read(analyticsProvider)
        .logOnboardingStepCompleted(step: 'task_selection');
    if (_selectedTasks.isEmpty) return;
    for (final task in _selectedTasks) {
      ref.read(profileProvider.notifier).toggleTask(task);
    }
    ref.read(onboardingScreenProvider.notifier).state =
        OnboardingStep.githubPress;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final tasksColA = [
      _TaskOption(
        label: l10n.taskOptionEmailManagement,
        icon: LucideIcons.mail,
      ),
      _TaskOption(label: l10n.taskOptionWebResearch, icon: LucideIcons.globe),
      _TaskOption(
        label: l10n.taskOptionTaskAutomation,
        icon: LucideIcons.repeat,
      ),
      _TaskOption(label: l10n.taskOptionScheduling, icon: LucideIcons.calendar),
    ];

    final tasksColB = [
      _TaskOption(label: l10n.taskOptionSocialMedia, icon: LucideIcons.share2),
      _TaskOption(label: l10n.taskOptionWriting, icon: LucideIcons.penTool),
      _TaskOption(
        label: l10n.taskOptionDataAnalysis,
        icon: LucideIcons.barChart,
      ),
      _TaskOption(label: l10n.taskOptionSmartHome, icon: LucideIcons.home),
    ];

    return OnboardingScaffold(
      showBackButton: true,
      onBackPressed: () {
        HapticFeedback.lightImpact();
        ref
            .read(analyticsProvider)
            .logOnboardingBackTapped(fromStep: 'task_selection');
        ref.read(onboardingScreenProvider.notifier).state =
            OnboardingStep.vibeSelection;
      },
      buttonText: l10n.commonContinue,
      onButtonPressed: _selectedTasks.isNotEmpty ? _onContinue : null,
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 4),
                Text(
                  l10n.taskSelectionTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEAEAEB),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.taskSelectionSubtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8A8B8D),
                  ),
                ),
              ],
            ),
          ),

          // Grid area — responsive layout
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 600;

                if (isWide) {
                  // Tablet/Web: 4 columns x 2 rows, horizontally wider
                  final allTasks = [
                    for (int i = 0; i < tasksColA.length; i++) ...[
                      tasksColA[i],
                      tasksColB[i],
                    ],
                  ];
                  // Reorder to: row1 = [0,1,2,3], row2 = [4,5,6,7]
                  final row1 = allTasks.sublist(0, 4);
                  final row2 = allTasks.sublist(4, 8);

                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  for (int i = 0; i < row1.length; i++) ...[
                                    if (i > 0) const SizedBox(width: 12),
                                    Expanded(child: _buildTaskCard(row1[i])),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: Row(
                                children: [
                                  for (int i = 0; i < row2.length; i++) ...[
                                    if (i > 0) const SizedBox(width: 12),
                                    Expanded(child: _buildTaskCard(row2[i])),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                // Mobile: 2 columns x 4 rows (original layout)
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      // Column A
                      Expanded(
                        child: Column(
                          children: [
                            for (int i = 0; i < tasksColA.length; i++) ...[
                              if (i > 0) const SizedBox(height: 12),
                              Expanded(child: _buildTaskCard(tasksColA[i])),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Column B
                      Expanded(
                        child: Column(
                          children: [
                            for (int i = 0; i < tasksColB.length; i++) ...[
                              if (i > 0) const SizedBox(height: 12),
                              Expanded(child: _buildTaskCard(tasksColB[i])),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(_TaskOption task) {
    final isSelected = _selectedTasks.contains(task.label);
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        final wasSelected = isSelected;
        setState(() {
          if (wasSelected) {
            _selectedTasks.remove(task.label);
          } else {
            _selectedTasks.add(task.label);
          }
        });
        ref
            .read(analyticsProvider)
            .logOnboardingTaskToggled(task: task.label, selected: !wasSelected);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF141415),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : const Color(0xFF1F2023),
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              task.icon,
              size: 24,
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFF8A8B8D),
            ),
            const SizedBox(height: 8),
            Text(
              task.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFFEAEAEB),
                fontFamily: 'JetBrains Mono',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
