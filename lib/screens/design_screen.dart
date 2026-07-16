import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/color_picker.dart';
import '../widgets/custom_button.dart';

class DesignScreen extends StatelessWidget {
  const DesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final config = appState.cardConfig;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => appState.goBack(),
            ),
            title: const Text('Design Card'),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Background
                      _CollapsibleSection(
                        title: 'Background',
                        child: Column(
                          children: [
                            GoldColorPicker(
                              color: config.backgroundColor,
                              onColorChanged: appState.setBackgroundColor,
                              label: 'Background Color',
                            ),
                            const SizedBox(height: 12),
                            GoldColorPicker(
                              color: config.gradientEndColor ?? config.backgroundColor,
                              onColorChanged: (color) {
                                if (color.value != config.backgroundColor.value) {
                                  appState.setGradientEndColor(color);
                                }
                              },
                              label: 'Gradient End (optional)',
                            ),
                          ],
                        ),
                      ),

                      // Text
                      _CollapsibleSection(
                        title: 'Text',
                        child: Column(
                          children: [
                            GoldColorPicker(
                              color: config.textColor,
                              onColorChanged: appState.setTextColor,
                              label: 'Text Color',
                            ),
                            const SizedBox(height: 12),
                            // Font selection
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.borderMuted),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: config.fontFamily,
                                  isExpanded: true,
                                  dropdownColor: AppColors.surface,
                                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryGold),
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 14,
                                  ),
                                  onChanged: (value) {
                                    if (value != null) appState.setFontFamily(value);
                                  },
                                  items: AppConstants.availableFonts.map((font) {
                                    return DropdownMenuItem(
                                      value: font,
                                      child: Text(font),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Font size
                            Row(
                              children: [
                                const Text(
                                  'Size:',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 13,
                                  ),
                                ),
                                Expanded(
                                  child: Slider(
                                    value: config.fontSize,
                                    min: 10,
                                    max: 32,
                                    divisions: 22,
                                    label: config.fontSize.toInt().toString(),
                                    onChanged: appState.setFontSize,
                                  ),
                                ),
                                Text(
                                  config.fontSize.toInt().toString(),
                                  style: const TextStyle(
                                    color: AppColors.primaryGold,
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Accent Color
                      _CollapsibleSection(
                        title: 'Accent Color',
                        child: GoldColorPicker(
                          color: config.accentColor,
                          onColorChanged: appState.setAccentColor,
                          label: 'Accent',
                        ),
                      ),

                      // Border
                      _CollapsibleSection(
                        title: 'Border',
                        child: Column(
                          children: [
                            GoldColorPicker(
                              color: config.borderColor,
                              onColorChanged: appState.setBorderColor,
                              label: 'Border Color',
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Text(
                                  'Width:',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 13,
                                  ),
                                ),
                                Expanded(
                                  child: Slider(
                                    value: config.borderWidth,
                                    min: 0,
                                    max: 10,
                                    divisions: 20,
                                    label: config.borderWidth.toStringAsFixed(1),
                                    onChanged: appState.setBorderWidth,
                                  ),
                                ),
                                Text(
                                  config.borderWidth.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: AppColors.primaryGold,
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Shadow
                      _CollapsibleSection(
                        title: 'Shadow',
                        child: Column(
                          children: [
                            _ToggleItem(
                              label: 'Enable Shadow',
                              value: config.shadowEnabled,
                              onChanged: appState.setShadowEnabled,
                            ),
                          ],
                        ),
                      ),

                      // Corners
                      _CollapsibleSection(
                        title: 'Corners',
                        child: Column(
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: AppConstants.cornerStyles.map((style) {
                                final isSelected = config.cornerStyle == style;
                                return GestureDetector(
                                  onTap: () => appState.setCornerStyle(style),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primaryGold.withOpacity(0.15)
                                          : AppColors.surface,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected ? AppColors.primaryGold : AppColors.borderMuted,
                                      ),
                                    ),
                                    child: Text(
                                      style,
                                      style: TextStyle(
                                        color: isSelected ? AppColors.primaryGold : AppColors.textSecondary,
                                        fontSize: 12,
                                        fontFamily: 'JetBrainsMono',
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      // Dimensions
                      _CollapsibleSection(
                        title: 'Dimensions',
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _DimensionInput(
                                    label: 'Width',
                                    value: config.cardWidth.toInt(),
                                    onChanged: (value) {
                                      appState.setCardDimensions(
                                        value.toDouble(),
                                        config.cardHeight,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'x',
                                  style: TextStyle(
                                    color: AppColors.primaryGold,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _DimensionInput(
                                    label: 'Height',
                                    value: config.cardHeight.toInt(),
                                    onChanged: (value) {
                                      appState.setCardDimensions(
                                        config.cardWidth,
                                        value.toDouble(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: const Border(top: BorderSide(color: AppColors.borderMuted)),
                  ),
                  child: ActionButtons(
                    onBack: () => appState.goBack(),
                    onNext: () => appState.goNext(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CollapsibleSection extends StatefulWidget {
  final String title;
  final Widget child;

  const _CollapsibleSection({
    required this.title,
    required this.child,
  });

  @override
  State<_CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<_CollapsibleSection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderMuted),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrainsMono',
                      letterSpacing: 1.5,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.primaryGold,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: widget.child,
            ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleItem({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _DimensionInput extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _DimensionInput({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value.toString(),
      keyboardType: TextInputType.number,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontFamily: 'JetBrainsMono',
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
      ),
      onChanged: (val) {
        final parsed = int.tryParse(val);
        if (parsed != null && parsed > 0) {
          onChanged(parsed);
        }
      },
    );
  }
}
