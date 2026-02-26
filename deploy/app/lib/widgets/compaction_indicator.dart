import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'package:clawbox/l10n/app_localizations.dart';

class CompactionIndicator extends StatelessWidget {
  const CompactionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.08),
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            l10n.compactingContext,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}
