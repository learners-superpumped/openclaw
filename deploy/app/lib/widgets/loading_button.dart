import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget label;
  final Widget? icon;
  final bool isLoading;
  final bool outlined;
  final Size? minimumSize;

  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.outlined = false,
    this.minimumSize,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;
    final effectiveLabel = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : label;

    final style = minimumSize != null
        ? (outlined ? OutlinedButton.styleFrom : FilledButton.styleFrom)(
            minimumSize: minimumSize,
          )
        : null;

    if (icon != null && !isLoading) {
      if (outlined) {
        return OutlinedButton.icon(
          onPressed: effectiveOnPressed,
          icon: icon!,
          label: effectiveLabel,
          style: style,
        );
      }
      return FilledButton.icon(
        onPressed: effectiveOnPressed,
        icon: icon!,
        label: effectiveLabel,
        style: style,
      );
    }

    if (outlined) {
      return OutlinedButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: effectiveLabel,
      );
    }
    return FilledButton(
      onPressed: effectiveOnPressed,
      style: style,
      child: effectiveLabel,
    );
  }
}
