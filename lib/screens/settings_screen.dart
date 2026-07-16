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
  int _quality = 90;
  List<String> _hashtags = [];

  @override
  void initState() {
    super.initState();
    _appNameController = TextEditingController(text: _settings.getAppName());
    _nameController = TextEditingController(text: _settings.getUserName());
    _handleController = TextEditingController(text: _settings.getUserHandle());
    _hashtagController = TextEditingController();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // App Customization
            _SettingsSection(
              title: 'App Customization',
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
                        const Icon(Icons.dark_mode, color: AppColors.primaryGold, size: 20),
                        const SizedBox(width: 12),
                        const Expanded(
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
              ],
            ),

            // User Profile
            _SettingsSection(
              title: 'User Profile',
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
                  prefix: const Text(
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
                    const Text(
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
                  const Text(
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
                          style: const TextStyle(
                            color: AppColors.primaryGold,
                            fontSize: 12,
                            fontFamily: 'JetBrainsMono',
                          ),
                        ),
                        backgroundColor: AppColors.surface,
                        deleteIcon: const Icon(Icons.close, size: 16, color: AppColors.textSecondary),
                        onDeleted: () async {
                          await _hashtagService.removeHashtag(tag);
                          _loadHashtags();
                        },
                        side: const BorderSide(color: AppColors.borderMuted),
                      );
                    }).toList(),
                  ),
              ],
            ),

            // Export Settings
            _SettingsSection(
              title: 'Export Settings',
              children: [
                Row(
                  children: [
                    const Expanded(
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
                          icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryGold),
                          style: const TextStyle(
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
                    const Text(
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

            // Card Defaults
            _SettingsSection(
              title: 'Card Defaults',
              children: [
                // Default font
                Row(
                  children: [
                    const Expanded(
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
                          icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryGold),
                          style: const TextStyle(
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
                  leading: const Icon(Icons.delete_sweep, color: AppColors.primaryGold),
                  title: const Text(
                    'Clear Cache',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  subtitle: const Text(
                    'Remove temporary files',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
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
                  leading: const Icon(Icons.delete_forever, color: AppColors.error),
                  title: const Text(
                    'Reset All Settings',
                    style: TextStyle(color: AppColors.error),
                  ),
                  subtitle: const Text(
                    'Restore default settings',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: AppColors.surface,
                        title: const Text(
                          'Reset All Settings?',
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                        content: const Text(
                          'This will restore all settings to their default values. This cannot be undone.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('CANCEL'),
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
                            child: const Text('RESET'),
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
                  leading: const Icon(Icons.info_outline, color: AppColors.primaryGold),
                  title: const Text(
                    'Version',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  trailing: Text(
                    AppConstants.appVersion,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontFamily: 'JetBrainsMono',
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline, color: AppColors.primaryGold),
                  title: const Text(
                    'Creator',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  trailing: Text(
                    AppConstants.creatorName,
                    style: const TextStyle(
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

  const _SettingsSection({
    required this.title,
    required this.children,
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
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppColors.primaryGold,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'JetBrainsMono',
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
