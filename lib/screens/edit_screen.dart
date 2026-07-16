import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';
import '../utils/shape_utils.dart';

import '../utils/constants.dart';
import '../widgets/gold_input.dart';
import '../widgets/custom_button.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _handleController;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppStateProvider>();
    _nameController = TextEditingController(text: appState.cardConfig.name);
    _handleController = TextEditingController(text: appState.cardConfig.handle);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _handleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => appState.goBack(),
            ),
            title: const Text('Edit Content'),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                tooltip: 'Save',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile settings saved'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar & Name/Handle section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderMuted),
                          ),
                          child: Row(
                            children: [
                              // Avatar
                              GestureDetector(
                                onTap: () => _showAvatarPicker(context, appState),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 72,
                                      height: 72,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primaryGold.withOpacity(0.1),
                                        border: Border.all(
                                          color: AppColors.primaryGold,
                                          width: 2,
                                        ),
                                        image: appState.cardConfig.avatarBytes != null
                                            ? DecorationImage(
                                                image: MemoryImage(appState.cardConfig.avatarBytes!),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: appState.cardConfig.avatarBytes == null
                                          ? Icon(
                                              Icons.person,
                                              size: 36,
                                              color: AppColors.primaryGold,
                                            )
                                          : null,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryGold,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.edit,
                                          size: 14,
                                          color: AppColors.background,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Name & Handle
                              Expanded(
                                child: Column(
                                  children: [
                                    GoldInput(
                                      label: 'NAME',
                                      controller: _nameController,
                                      onChanged: appState.setName,
                                    ),
                                    const SizedBox(height: 12),
                                    GoldInput(
                                      label: 'HANDLE',
                                      controller: _handleController,
                                      onChanged: appState.setHandle,
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
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Logo Placement
                        Container(
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
                                'LOGO PLACEMENT',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: AppConstants.logoPlacements.map((placement) {
                                  final isSelected = appState.cardConfig.logoPlacement == placement;
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: GestureDetector(
                                        onTap: () => appState.setLogoPlacement(placement),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.primaryGold.withOpacity(0.15)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: isSelected
                                                  ? AppColors.primaryGold
                                                  : AppColors.borderMuted,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Text(
                                            placement,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? AppColors.primaryGold
                                                  : AppColors.textSecondary,
                                              fontSize: 11,
                                              fontFamily: 'JetBrainsMono',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Display Toggles
                        Container(
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
                                'DISPLAY OPTIONS',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 12),
                              _ToggleItem(
                                icon: Icons.calendar_today,
                                label: 'Show Date',
                                value: appState.cardConfig.showDate,
                                onChanged: appState.setShowDate,
                              ),
                              const Divider(color: AppColors.divider),
                              _ToggleItem(
                                icon: Icons.access_time,
                                label: 'Show Time',
                                value: appState.cardConfig.showTime,
                                onChanged: appState.setShowTime,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Live Preview
                        Text(
                          'LIVE PREVIEW',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 12),
                        _CardPreview(appState: appState),
                      ],
                    ),
                  ),
                ),
                // Bottom actions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      top: BorderSide(color: AppColors.borderMuted),
                    ),
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

  void _showAvatarPicker(BuildContext context, AppStateProvider appState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'CHANGE AVATAR',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.primaryGold),
                title: Text('Gallery', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    final bytes = await picked.readAsBytes();
                    appState.setAvatar(picked.path, bytes);
                  }
                },
              ),
              const Divider(color: AppColors.divider),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.primaryGold),
                title: Text('Camera', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await _imagePicker.pickImage(source: ImageSource.camera);
                  if (picked != null) {
                    final bytes = await picked.readAsBytes();
                    appState.setAvatar(picked.path, bytes);
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryGold),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
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
      ),
    );
  }
}

class _CardPreview extends StatelessWidget {
  final AppStateProvider appState;

  const _CardPreview({required this.appState});

  @override
  Widget build(BuildContext context) {
    final config = appState.cardConfig;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: config.accentColor.withOpacity(0.3)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          // User row
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: config.accentColor.withOpacity(0.2),
                  border: Border.all(color: config.accentColor, width: 1),
                  image: config.avatarBytes != null
                      ? DecorationImage(
                          image: MemoryImage(config.avatarBytes!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: config.avatarBytes == null
                    ? Icon(Icons.person, size: 16, color: config.accentColor)
                    : null,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config.name,
                    style: TextStyle(
                      color: config.textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: config.fontFamily,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        config.handle,
                        style: TextStyle(
                          color: config.accentColor.withOpacity(0.7),
                          fontSize: 11,
                          fontFamily: config.fontFamily,
                        ),
                      ),
                      if (config.showDate || config.showTime)
                        Text(
                          ' • ${[
                            if (config.showDate) 'Oct 24',
                            if (config.showTime) '14:30'
                          ].join(' ')}',
                          style: TextStyle(
                            color: config.accentColor.withOpacity(0.5),
                            fontSize: 10,
                            fontFamily: config.fontFamily,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Topic
          if (config.topic.isNotEmpty)
            Text(
              config.topic.toUpperCase(),
              style: TextStyle(
                color: config.accentColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: config.fontFamily,
              ),
            ),
          if (config.subtopic.isNotEmpty)
            Text(
              config.subtopic,
              style: TextStyle(
                color: config.textColor.withOpacity(0.7),
                fontSize: 12,
                fontFamily: config.fontFamily,
              ),
            ),
          const SizedBox(height: 8),
          // Content snippet
          Text(
            config.content.isNotEmpty
                ? config.content.length > 100
                    ? '${config.content.substring(0, 100)}...'
                    : config.content
                : 'Your content will appear here...',
            style: TextStyle(
              color: config.textColor.withOpacity(0.8),
              fontSize: 11,
              fontFamily: config.fontFamily,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          // Hashtags
          if (config.hashtags.isNotEmpty)
            Wrap(
              spacing: 4,
              children: config.hashtags.take(3).map((tag) {
                return Text(
                  '#$tag ',
                  style: TextStyle(
                    color: config.accentColor.withOpacity(0.6),
                    fontSize: 10,
                    fontFamily: config.fontFamily,
                  ),
                );
              }).toList(),
            ),
            ],
          ),
          // Logo
          Positioned(
            top: config.logoPlacement.startsWith('Top') ? 0 : null,
            bottom: config.logoPlacement.startsWith('Bottom') ? 0 : null,
            left: config.logoPlacement.endsWith('Left') ? 0 : null,
            right: config.logoPlacement.endsWith('Right') ? 0 : null,
            child: Image.asset(
              'assets/images/logo.png',
              width: 24,
              height: 24,
              color: config.accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
