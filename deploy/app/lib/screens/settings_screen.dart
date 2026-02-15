import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../providers/instance_provider.dart';
import '../providers/onboarding_provider.dart';
import '../services/revenue_cat_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _SettingsTile(
            icon: Icons.credit_card_rounded,
            iconColor: AppColors.accent,
            title: '구독 관리',
            subtitle: '구독 상태 확인 및 관리',
            onTap: () => RevenueCatService.showCustomerCenter(),
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.restart_alt_rounded,
            iconColor: AppColors.error,
            title: '인스턴스 재생성',
            subtitle: '모든 데이터를 초기화하고 다시 설정',
            onTap: () => _showDeleteConfirmation(context, ref),
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.logout_rounded,
            iconColor: AppColors.error,
            title: '로그아웃',
            subtitle: '계정에서 로그아웃',
            onTap: () => ref.read(authProvider.notifier).signOut(),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text('인스턴스 재생성'),
        content: const Text(
          '모든 데이터가 초기화되고 처음부터 다시 설정됩니다. 이 작업은 되돌릴 수 없습니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '취소',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteInstance(ref);
            },
            child: Text(
              '재생성',
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteInstance(WidgetRef ref) {
    ref.read(instanceProvider.notifier).deleteInstance();
    ref.read(setupProgressProvider.notifier).state = OnboardingStep.telegramSetup;
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
