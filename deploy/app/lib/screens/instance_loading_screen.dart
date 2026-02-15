import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/instance_provider.dart';
import '../theme/app_theme.dart';

class InstanceLoadingScreen extends ConsumerStatefulWidget {
  const InstanceLoadingScreen({super.key});

  @override
  ConsumerState<InstanceLoadingScreen> createState() => _InstanceLoadingScreenState();
}

class _InstanceLoadingScreenState extends ConsumerState<InstanceLoadingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(instanceProvider);
      if (state.status == InstanceStatus.idle) {
        ref.read(instanceProvider.notifier).ensureInstance();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(instanceProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (state.status == InstanceStatus.error) ...[
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              '인스턴스 생성에 실패했습니다',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '네트워크 연결을 확인하고 다시 시도해주세요.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => ref.read(instanceProvider.notifier).ensureInstance(),
              child: const Text('다시 시도'),
            ),
          ] else ...[
            SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              _statusTitle(state.status),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _statusDescription(state.status),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (state.instance?.manager != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      state.instance!.manager!.phase,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  String _statusTitle(InstanceStatus status) {
    switch (status) {
      case InstanceStatus.creating:
        return '인스턴스 생성 중...';
      case InstanceStatus.polling:
        return '설정 진행 중...';
      default:
        return '준비 중...';
    }
  }

  String _statusDescription(InstanceStatus status) {
    switch (status) {
      case InstanceStatus.creating:
        return 'AI 인스턴스를 생성하고 있습니다.\n잠시만 기다려주세요.';
      case InstanceStatus.polling:
        return '인스턴스가 시작되고 있습니다.\n보통 1-2분 정도 소요됩니다.';
      default:
        return '잠시만 기다려주세요...';
    }
  }
}
