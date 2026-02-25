class AiModelPricing {
  final String prompt;
  final String completion;

  const AiModelPricing({required this.prompt, required this.completion});

  factory AiModelPricing.fromJson(Map<String, dynamic> json) {
    return AiModelPricing(
      prompt: json['prompt']?.toString() ?? '0',
      completion: json['completion']?.toString() ?? '0',
    );
  }
}

class AiModel {
  final String id;
  final String name;
  final int? contextLength;
  final AiModelPricing? pricing;

  const AiModel({
    required this.id,
    required this.name,
    this.contextLength,
    this.pricing,
  });

  /// OpenRouter model ID prefixed for gateway config.
  /// e.g. "anthropic/claude-opus-4-6" → "openrouter/anthropic/claude-opus-4-6"
  String get gatewayModelRef => 'openrouter/$id';

  /// Extract provider from model ID (e.g. "anthropic" from "anthropic/claude-opus-4-6").
  String get provider {
    final slash = id.indexOf('/');
    return slash > 0 ? id.substring(0, slash) : id;
  }

  /// Short model name without provider prefix.
  String get shortName {
    final slash = id.indexOf('/');
    return slash > 0 ? id.substring(slash + 1) : id;
  }

  factory AiModel.fromJson(Map<String, dynamic> json) {
    return AiModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? json['id'] as String,
      contextLength: json['context_length'] as int?,
      pricing: json['pricing'] != null
          ? AiModelPricing.fromJson(json['pricing'] as Map<String, dynamic>)
          : null,
    );
  }
}
