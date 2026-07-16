import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TextEditorTools extends StatelessWidget {
  final bool isBold;
  final bool isItalic;
  final TextAlign textAlign;
  final double fontSize;
  final Function(bool) onBoldToggle;
  final Function(bool) onItalicToggle;
  final Function(TextAlign) onAlignChange;
  final Function(double) onFontSizeChange;
  final VoidCallback onImagePick;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final bool canUndo;
  final bool canRedo;

  const TextEditorTools({
    super.key,
    required this.isBold,
    required this.isItalic,
    required this.textAlign,
    required this.fontSize,
    required this.onBoldToggle,
    required this.onItalicToggle,
    required this.onAlignChange,
    required this.onFontSizeChange,
    required this.onImagePick,
    required this.onUndo,
    required this.onRedo,
    required this.canUndo,
    required this.canRedo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.borderMuted, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Bold
          _ToolButton(
            icon: Icons.format_bold,
            isActive: isBold,
            onTap: () => onBoldToggle(!isBold),
            tooltip: 'Bold',
          ),
          // Italic
          _ToolButton(
            icon: Icons.format_italic,
            isActive: isItalic,
            onTap: () => onItalicToggle(!isItalic),
            tooltip: 'Italic',
          ),
          // Align
          _ToolButton(
            icon: textAlign == TextAlign.center
                ? Icons.format_align_center
                : textAlign == TextAlign.right
                    ? Icons.format_align_right
                    : Icons.format_align_left,
            onTap: () {
              final next = textAlign == TextAlign.left
                  ? TextAlign.center
                  : textAlign == TextAlign.center
                      ? TextAlign.right
                      : TextAlign.left;
              onAlignChange(next);
            },
            tooltip: 'Align',
          ),
          // Font size
          _ToolButton(
            icon: Icons.format_size,
            onTap: () => _showFontSizePicker(context),
            tooltip: 'Font Size: ${fontSize.toInt()}',
          ),
          // Image
          _ToolButton(
            icon: Icons.image,
            onTap: onImagePick,
            tooltip: 'Insert Image',
          ),
          // Undo
          _ToolButton(
            icon: Icons.undo,
            onTap: canUndo ? onUndo : null,
            isActive: canUndo,
            tooltip: 'Undo',
          ),
          // Redo
          _ToolButton(
            icon: Icons.redo,
            onTap: canRedo ? onRedo : null,
            isActive: canRedo,
            tooltip: 'Redo',
          ),
        ],
      ),
    );
  }

  void _showFontSizePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FONT SIZE',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 16),
            StatefulBuilder(
              builder: (context, setState) => Slider(
                value: fontSize,
                min: 10,
                max: 32,
                divisions: 22,
                label: fontSize.toInt().toString(),
                onChanged: (value) {
                  onFontSizeChange(value);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('10', style: Theme.of(context).textTheme.bodySmall),
                Text(fontSize.toInt().toString(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primaryGold,
                        )),
                Text('32', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isActive;
  final String? tooltip;

  const _ToolButton({
    required this.icon,
    this.onTap,
    this.isActive = false,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final color = onTap == null
        ? AppColors.textMuted.withOpacity(0.3)
        : isActive
            ? AppColors.primaryGold
            : AppColors.textSecondary;

    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, size: 20, color: color),
      tooltip: tooltip,
      padding: const EdgeInsets.all(6),
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}
