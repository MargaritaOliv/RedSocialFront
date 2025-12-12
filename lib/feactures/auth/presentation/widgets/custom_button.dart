import 'package:flutter/material.dart';
import 'package:redsocial/theme/shapes.dart';

enum ButtonType { primary, secondary, outlined }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isLoading) {
      return SizedBox(
        width: width,
        height: 56,
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == ButtonType.primary ? colorScheme.onPrimary : colorScheme.primary,
              ),
            ),
          ),
        ),
      );
    }

    switch (type) {
      case ButtonType.primary:
        return SizedBox(
          width: width,
          height: 56,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: AppShapes.buttonBorderRadius,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: theme.textTheme.labelLarge,
                ),
              ],
            ),
          ),
        );

      case ButtonType.secondary:
        return SizedBox(
          width: width,
          height: 56,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.secondaryContainer,
              foregroundColor: colorScheme.onSecondaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: AppShapes.buttonBorderRadius,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: theme.textTheme.labelLarge,
                ),
              ],
            ),
          ),
        );

      case ButtonType.outlined:
        return SizedBox(
          width: width,
          height: 56,
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.primary,
              side: BorderSide(color: colorScheme.outline, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: AppShapes.buttonBorderRadius,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: theme.textTheme.labelLarge,
                ),
              ],
            ),
          ),
        );
    }
  }
}