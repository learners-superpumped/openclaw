import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/ai_model.dart';
import '../theme/app_theme.dart';
import 'package:clawbox/l10n/app_localizations.dart';

class ModelPickerSheet extends StatefulWidget {
  final List<AiModel> models;
  final String? currentModelRef;

  const ModelPickerSheet({
    super.key,
    required this.models,
    this.currentModelRef,
  });

  /// Show the model picker and return the selected model (or null if dismissed).
  static Future<AiModel?> show(
    BuildContext context, {
    required List<AiModel> models,
    String? currentModelRef,
  }) {
    return showModalBottomSheet<AiModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => ModelPickerSheet(
          models: models,
          currentModelRef: currentModelRef,
        ),
      ),
    );
  }

  @override
  State<ModelPickerSheet> createState() => _ModelPickerSheetState();
}

class _ModelPickerSheetState extends State<ModelPickerSheet> {
  final _searchController = TextEditingController();
  List<AiModel> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.models;
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filtered = widget.models;
      } else {
        _filtered = widget.models
            .where((m) =>
                m.name.toLowerCase().contains(query) ||
                m.id.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Handle
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        // Title
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            l10n.defaultModel,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
        ),
        // Search
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: l10n.searchModels,
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.textTertiary),
              filled: true,
              fillColor: AppColors.surfaceLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ),
        const Divider(height: 1, color: AppColors.border),
        // Model list
        Expanded(
          child: _filtered.isEmpty
              ? Center(
                  child: Text(
                    l10n.noModelsFound,
                    style: const TextStyle(color: AppColors.textTertiary),
                  ),
                )
              : ListView.builder(
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final model = _filtered[index];
                    final isSelected =
                        widget.currentModelRef == model.gatewayModelRef;
                    return _ModelTile(
                      model: model,
                      isSelected: isSelected,
                      onTap: () => Navigator.of(context).pop(model),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ModelTile extends StatelessWidget {
  final AiModel model;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModelTile({
    required this.model,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.accent, size: 20)
          : const Icon(Icons.circle_outlined,
              color: AppColors.textTertiary, size: 20),
      title: Text(
        model.name,
        style: TextStyle(
          color: isSelected ? AppColors.accent : AppColors.textPrimary,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      subtitle: Text(
        model.id,
        style: const TextStyle(
          color: AppColors.textTertiary,
          fontSize: 12,
        ),
      ),
      trailing: model.contextLength != null
          ? Text(
              '${(model.contextLength! / 1000).round()}K',
              style: const TextStyle(
                color: AppColors.textTertiary,
                fontSize: 12,
              ),
            )
          : null,
    );
  }
}
