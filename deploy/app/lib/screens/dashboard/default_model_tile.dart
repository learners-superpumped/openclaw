import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:clawbox/l10n/app_localizations.dart';
import '../../providers/model_config_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/model_picker_sheet.dart';

class DefaultModelTile extends ConsumerWidget {
  final String instanceId;
  final bool isReady;
  final VoidCallback? onModelChanged;

  const DefaultModelTile({
    super.key,
    required this.instanceId,
    required this.isReady,
    this.onModelChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final configState = ref.watch(modelConfigProvider);
    final currentModel = configState.currentModel;
    final defaultModel = configState.defaultModel;
    final isLoading =
        !isReady || (configState.isLoading && defaultModel == null);

    return GlassCard.solid(
      padding: const EdgeInsets.all(16),
      onTap: isReady ? () => _openModelPicker(context, ref) : null,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.defaultModel.toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 12),
                Skeletonizer(
                  enabled: isLoading,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentModel?.name ??
                            defaultModel ??
                            'Loading model name',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: defaultModel != null && !isLoading
                                  ? AppColors.textPrimary
                                  : AppColors.textTertiary,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentModel?.id ??
                            defaultModel ??
                            'provider/model-name',
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 20),
        ],
      ),
    );
  }

  Future<void> _openModelPicker(BuildContext context, WidgetRef ref) async {
    final configState = ref.read(modelConfigProvider);
    final selected = await ModelPickerSheet.show(
      context,
      models: configState.models,
      currentModelRef: configState.defaultModel,
    );
    if (selected == null || !context.mounted) return;

    final success = await ref
        .read(modelConfigProvider.notifier)
        .setDefaultModel(instanceId, selected.gatewayModelRef);

    if (context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? l10n.gatewayRestartNotice : l10n.changeDefaultModelError,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      if (success) onModelChanged?.call();
    }
  }
}
