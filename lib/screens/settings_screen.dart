import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../providers/theme_provider.dart';
import '../services/settings_service.dart';
import '../services/storage_service.dart';
import '../services/hashtag_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/color_picker.dart';
import '../widgets/gold_input.dart';
import '../widgets/custom_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settings = SettingsService();
  final StorageService _storage = StorageService();
  final HashtagService _hashtagService = HashtagService();
  late TextEditingController _appNameController;
  late TextEditingController _nameController;
  late TextEditingController _handleController;
  late TextEditingController _hashtagController;
  late TextEditingController _fontSizeController;
  late TextEditingController _widthController;
  late TextEditingController _heightController;
  int _quality = 90;
  List<String> _hashtags = [];

  @override
  void initState() {
    super.initState();
    _appNameController = TextEditingController(text: _settings.getAppName());
    _nameController = TextEditingController(text: _settings.getUserName());
    _handleController = TextEditingController(text: _settings.getUserHandle());
    _hashtagController = TextEditingController();
    _fontSizeController = TextEditingController(text: _settings.getDefaultFontSize().toString());
    _widthController = TextEditingController(text: _settings.getDefaultCardWidth().toString());
    _heightController = TextEditingController(text: _settings.getDefaultCardHeight().toString());
    _quality = _settings.getExportQuality();
    _hashtags = _hashtagService.getAllHashtags();
  }

  void _loadHashtags() {
    setState(() {
      _hashtags = _hashtagService.getAllHashtags();
    });
  }

  @override
  void dispose() {
    _appNameController.dispose();
    _nameController.dispose();
    _handleController.dispose();
    _hashtagController.dispose();
    _fontSizeController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // App Customization
            _SettingsSection(
              title: 'App Customization',
              onSave: () async {
                final appState = context.read<AppStateProvider>();
                await appState.init();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved successfully')),
                  );
                }
              },
              children: [
                GoldInput(
                  label: 'App Name',
                  controller: _appNameController,
                  onChanged: (value) => _settings.setAppName(value),
                ),
                const SizedBox(height: 16),
                // Theme toggle
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return Row(
                      children: [
                        Icon(Icons.dark_mode, color: AppColors.primaryGold, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'AMOLED (Pitch Black)',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Switch(
                          value: themeProvider.isAmoled,
                          onChanged: (value) {
                            themeProvider.setAmoledTheme(value);
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Global Theme Accent Color
                Text(
                  'Global Theme Accent',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Solid Colors',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: AppColors.presetColors.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final color = AppColors.presetColors[index];
                      final isSelected = _settings.getAppThemePrimary() == color.value && _settings.getAppThemeSecondary() == null;
                      return GestureDetector(
                        onTap: () {
                          context.read<ThemeProvider>().setAppThemeColor(color);
                          setState(() {});
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Gradients',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: AppColors.presetGradients.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final colors = AppColors.presetGradients[index];
                      final isSelected = _settings.getAppThemePrimary() == colors[0].value && _settings.getAppThemeSecondary() == colors[1].value;
                      return GestureDetector(
                        onTap: () {
                          context.read<ThemeProvider>().setAppThemeColor(colors[0], colors[1]);
                          setState(() {});
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // User Profile
            _SettingsSection(
              title: 'User Profile',
              onSave: () async {
                final appState = context.read<AppStateProvider>();
                await appState.init();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved successfully')),
                  );
                }
              },
              children: [
                GoldInput(
                  label: 'Name',
                  controller: _nameController,
                  onChanged: (value) => _settings.setUserName(value),
                ),
                const SizedBox(height: 12),
                GoldInput(
                  label: 'Handle',
                  controller: _handleController,
                  onChanged: (value) {
                    final clean = value.startsWith('@') ? value : '@$value';
                    _settings.setUserHandle(clean);
                  },
                  prefix: Text(
                    '@',
                    style: TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Hashtag Management
            _SettingsSection(
              title: 'Hashtag Management',
              children: [
                Row(
                  children: [
                    Text(
                      '#',
                      style: TextStyle(
                        color: AppColors.primaryGold,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GoldInput(
                        hint: 'New hashtag...',
                        controller: _hashtagController,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GoldButton(
                      label: 'ADD',
                      isSmall: true,
                      onPressed: () async {
                        if (_hashtagController.text.isNotEmpty) {
                          await _hashtagService.addHashtag(_hashtagController.text);
                          _hashtagController.clear();
                          _loadHashtags();
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_hashtags.isEmpty)
                  Text(
                    'No custom hashtags added yet.',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _hashtags.map((tag) {
                      return Chip(
                        label: Text(
                          '#$tag',
                          style: TextStyle(
                            color: AppColors.primaryGold,
                            fontSize: 12,
                            fontFamily: 'JetBrainsMono',
                          ),
                        ),
                        backgroundColor: AppColors.surface,
                        deleteIcon: Icon(Icons.close, size: 16, color: AppColors.textSecondary),
                        onDeleted: () async {
                          await _hashtagService.removeHashtag(tag);
                          _loadHashtags();
                        },
                        side: BorderSide(color: AppColors.borderMuted),
                      );
                    }).toList(),
                  ),
              ],
            ),

            // Export Settings
            _SettingsSection(
              title: 'Export Settings',
              onSave: () async {
                final appState = context.read<AppStateProvider>();
                await appState.init();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved successfully')),
                  );
                }
              },
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Default Format',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderMuted),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _settings.getDefaultFormat(),
                          dropdownColor: AppColors.surface,
                          icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryGold),
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontFamily: 'JetBrainsMono',
                            fontSize: 14,
                          ),
                          onChanged: (value) {
                            if (value != null) {
                              _settings.setDefaultFormat(value);
                              setState(() {});
                            }
                          },
                          items: AppConstants.exportFormats.map((format) {
                            return DropdownMenuItem(
                              value: format,
                              child: Text(format),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Quality slider
                Row(
                  children: [
                    Text(
                      'Quality:',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: _quality.toDouble(),
                        min: 10,
                        max: 100,
                        divisions: 90,
                        label: '$_quality%',
                        onChanged: (value) {
                          setState(() {
                            _quality = value.toInt();
                          });
                        },
                        onChangeEnd: (value) {
                          _settings.setExportQuality(value.toInt());
                        },
                      ),
                    ),
                    Text(
                      '$_quality%',
                      style: TextStyle(
                        color: AppColors.primaryGold,
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Card Defaults
            _SettingsSection(
              title: 'Card Defaults',
              onSave: () async {
                final fontSize = double.tryParse(_fontSizeController.text) ?? 16.0;
                final width = double.tryParse(_widthController.text) ?? 1080.0;
                final height = double.tryParse(_heightController.text) ?? 1080.0;
                await _settings.setDefaultFontSize(fontSize);
                await _settings.setDefaultCardWidth(width);
                await _settings.setDefaultCardHeight(height);
                final appState = context.read<AppStateProvider>();
                await appState.init();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved successfully')),
                  );
                }
              },
              children: [
                Row(
                  children: [
                    Expanded(child: GoldInput(label: 'Width', controller: _widthController, keyboardType: TextInputType.number)),
                    const SizedBox(width: 16),
                    Expanded(child: GoldInput(label: 'Height', controller: _heightController, keyboardType: TextInputType.number)),
                  ],
                ),
                const SizedBox(height: 16),
                GoldInput(label: 'Font Size', controller: _fontSizeController, keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                // Default font
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Font',
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderMuted),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _settings.getDefaultFont(),
                          dropdownColor: AppColors.surface,
                          icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryGold),
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontFamily: 'JetBrainsMono',
                            fontSize: 14,
                          ),
                          onChanged: (value) {
                            if (value != null) {
                              _settings.setDefaultFont(value);
                              setState(() {});
                            }
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
                  ],
                ),
                const SizedBox(height: 16),
                // Colors
                GoldColorPicker(
                  color: Color(_settings.getDefaultTextColor()),
                  onColorChanged: (color) => _settings.setDefaultTextColor(color.value),
                  label: 'Text Color',
                ),
                const SizedBox(height: 12),
                GoldColorPicker(
                  color: Color(_settings.getDefaultBgColor()),
                  onColorChanged: (color) => _settings.setDefaultBgColor(color.value),
                  label: 'Background',
                ),
                const SizedBox(height: 12),
                GoldColorPicker(
                  color: Color(_settings.getDefaultAccentColor()),
                  onColorChanged: (color) => _settings.setDefaultAccentColor(color.value),
                  label: 'Accent',
                ),
              ],
            ),

            // Storage
            _SettingsSection(
              title: 'Storage',
              children: [
                ListTile(
                  leading: Icon(Icons.delete_sweep, color: AppColors.primaryGold),
                  title: Text(
                    'Clear Cache',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  subtitle: Text(
                    'Remove temporary files',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  trailing: Icon(Icons.chevron_right, color: AppColors.textMuted),
                  onTap: () async {
                    await _storage.clearCache();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cache cleared')),
                      );
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete_forever, color: AppColors.error),
                  title: Text(
                    'Reset All Settings',
                    style: TextStyle(color: AppColors.error),
                  ),
                  subtitle: Text(
                    'Restore default settings',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: AppColors.surface,
                        title: Text(
                          'Reset All Settings?',
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                        content: Text(
                          'This will restore all settings to their default values. This cannot be undone.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('CANCEL'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await _settings.resetAll();
                              Navigator.pop(context);
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                              foregroundColor: AppColors.textPrimary,
                            ),
                            child: Text('RESET'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),

            // About
            _SettingsSection(
              title: 'About',
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline, color: AppColors.primaryGold),
                  title: Text(
                    'Version',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  trailing: Text(
                    AppConstants.appVersion,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontFamily: 'JetBrainsMono',
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person_outline, color: AppColors.primaryGold),
                  title: Text(
                    'Creator',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  trailing: Text(
                    AppConstants.creatorName,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontFamily: 'JetBrainsMono',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            GoldButton(
              label: 'APPLY CHANGES',
              onPressed: () async {
                // Sync settings with app state
                final appState = context.read<AppStateProvider>();
                await appState.init(); // Reloads all defaults
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings applied successfully')),
                  );
                }
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback? onSave;

  const _SettingsSection({
    required this.title,
    required this.children,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: AppColors.primaryGold,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JetBrainsMono',
                  letterSpacing: 2,
                ),
              ),
              if (onSave != null)
                IconButton(
                  icon: Icon(Icons.check, color: AppColors.primaryGold, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onSave,
                ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
