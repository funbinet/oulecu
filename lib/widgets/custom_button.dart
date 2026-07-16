import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GoldButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isOutlined;
  final bool isSmall;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const GoldButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isOutlined = false,
    this.isSmall = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton(
        onPressed: onPressed,
        child: _buttonContent(),
      );
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        minimumSize: isSmall ? const Size(0, 40) : const Size(double.infinity, 48),
        padding: isSmall ? const EdgeInsets.symmetric(horizontal: 20, vertical: 8) : null,
      ),
      child: _buttonContent(),
    );
  }

  Widget _buttonContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: isSmall ? 16 : 18),
          SizedBox(width: isSmall ? 6 : 8),
          Text(
            label,
            style: TextStyle(
              fontSize: isSmall ? 12 : 15,
              letterSpacing: 0.5,
            ),
          ),
        ],
      );
    }
    return Text(
      label,
      style: TextStyle(
        fontSize: isSmall ? 12 : 15,
        letterSpacing: 0.5,
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback onNext;
  final String backLabel;
  final String nextLabel;

  const ActionButtons({
    super.key,
    this.onBack,
    required this.onNext,
    this.backLabel = 'Back',
    this.nextLabel = 'Next',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (onBack != null)
            Expanded(
              child: GoldButton(
                label: backLabel,
                onPressed: onBack,
                isOutlined: true,
              ),
            ),
          if (onBack != null) const SizedBox(width: 12),
          Expanded(
            flex: onBack != null ? 1 : 2,
            child: GoldButton(
              label: nextLabel,
              onPressed: onNext,
              icon: Icons.arrow_forward,
            ),
          ),
        ],
      ),
    );
  }
}

class DiscardButton extends StatelessWidget {
  final VoidCallback onDiscard;
  final bool enabled;

  const DiscardButton({
    super.key,
    required this.onDiscard,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: enabled
          ? () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.surface,
                  title: const Text(
                    'Discard Changes?',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  content: const Text(
                    'Are you sure you want to discard all your changes? This action cannot be undone.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CANCEL'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onDiscard();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: AppColors.textPrimary,
                      ),
                      child: const Text('DISCARD'),
                    ),
                  ],
                ),
              );
            }
          : null,
      icon: Icon(Icons.delete_outline, size: 18,
          color: enabled ? AppColors.error : AppColors.textMuted.withOpacity(0.3)),
      label: Text(
        'DISCARD',
        style: TextStyle(
          color: enabled ? AppColors.error : AppColors.textMuted.withOpacity(0.3),
          fontSize: 12,
        ),
      ),
    );
  }
}
