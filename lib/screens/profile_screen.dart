import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_state_provider.dart';
import '../services/settings_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SettingsService _settings = SettingsService();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<AppStateProvider>().updateStats();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Profile'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Avatar
                  GestureDetector(
                    onTap: () => _showAvatarPicker(context, appState),
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryGold.withOpacity(0.1),
                            border: Border.all(
                              color: AppColors.primaryGold,
                              width: 2.5,
                            ),
                            image: appState.cardConfig.avatarBytes != null
                                ? DecorationImage(
                                    image: MemoryImage(appState.cardConfig.avatarBytes!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: appState.cardConfig.avatarBytes == null
                              ? const Icon(
                                  Icons.person,
                                  size: 48,
                                  color: AppColors.primaryGold,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
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
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    appState.cardConfig.name,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  // Handle
                  Text(
                    appState.cardConfig.handle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primaryGold,
                          fontFamily: 'JetBrainsMono',
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Statistics
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderMuted),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatItem(
                          icon: Icons.image,
                          value: '${appState.userProfile.cardsGenerated}',
                          label: 'Cards',
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppColors.divider,
                        ),
                        _StatItem(
                          icon: Icons.tag,
                          value: '${appState.userProfile.tagsUsed}',
                          label: 'Tags',
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppColors.divider,
                        ),
                        _StatItem(
                          icon: Icons.calendar_today,
                          value: '${appState.userProfile.daysActive}',
                          label: 'Days',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick Actions
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
                          'QUICK ACTIONS',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 12),
                        _ActionTile(
                          icon: Icons.download,
                          label: 'Export All',
                          onTap: () {
                            // Export all functionality
                          },
                        ),
                        const Divider(color: AppColors.divider),
                        _ActionTile(
                          icon: Icons.cleaning_services,
                          label: 'Clear Cache',
                          onTap: () async {
                            final storage = context.read<StorageService>();
                            await storage.clearCache();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Cache cleared')),
                              );
                            }
                          },
                        ),
                        const Divider(color: AppColors.divider),
                        _ActionTile(
                          icon: Icons.share,
                          label: 'Share App',
                          onTap: () {
                            Share.share(
                              'Check out OULECU - the ultimate offline image card generator!\n\nGitHub: ${AppConstants.githubUrl}\nCodeberg: ${AppConstants.codebergUrl}',
                            );
                          },
                        ),
                        const Divider(color: AppColors.divider),
                        _ActionTile(
                          icon: Icons.feedback,
                          label: 'Send Feedback',
                          onTap: () => _showFeedbackDialog(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Creator Info
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderMuted),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.code,
                          size: 32,
                          color: AppColors.primaryGold,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Created with passion by',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppConstants.creatorName,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.primaryGold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        // Social links
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _SocialButton(
                              icon: Icons.email,
                              label: 'Email',
                              onTap: () async {
                                final Uri emailLaunchUri = Uri(
                                  scheme: 'mailto',
                                  path: AppConstants.creatorEmail,
                                );
                                await launchUrl(emailLaunchUri);
                              },
                            ),
                            const SizedBox(width: 16),
                            _SocialButton(
                              icon: Icons.code,
                              label: 'GitHub',
                              onTap: () async {
                                final Uri url = Uri.parse(AppConstants.githubUrl);
                                await launchUrl(url);
                              },
                            ),
                            const SizedBox(width: 16),
                            _SocialButton(
                              icon: Icons.code_off,
                              label: 'Codeberg',
                              onTap: () async {
                                final Uri url = Uri.parse(AppConstants.codebergUrl);
                                await launchUrl(url);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Contact info
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              _ContactRow(
                                icon: Icons.email,
                                text: AppConstants.creatorEmail,
                              ),
                              const SizedBox(height: 8),
                              _ContactRow(
                                icon: Icons.code,
                                text: 'github.com/funbinet',
                              ),
                              const SizedBox(height: 8),
                              _ContactRow(
                                icon: Icons.code_off,
                                text: 'codeberg.org/funbinet',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // App info
                  Text(
                    'OULECU v${AppConstants.appVersion}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'Built with Flutter',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                        ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
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
                leading: const Icon(Icons.photo_library, color: AppColors.primaryGold),
                title: const Text('Gallery', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    final bytes = await picked.readAsBytes();
                    appState.setAvatar(picked.path, bytes);
                    _settings.setUserAvatar(picked.path);
                  }
                },
              ),
              const Divider(color: AppColors.divider),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primaryGold),
                title: const Text('Camera', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await _imagePicker.pickImage(source: ImageSource.camera);
                  if (picked != null) {
                    final bytes = await picked.readAsBytes();
                    appState.setAvatar(picked.path, bytes);
                    _settings.setUserAvatar(picked.path);
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

  void _showFeedbackDialog(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Send Feedback',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'We value your feedback! Send your thoughts, bug reports, or feature requests.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: feedbackController,
              maxLines: 4,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontFamily: 'JetBrainsMono',
              ),
              decoration: const InputDecoration(
                hintText: 'Type your feedback here...',
              ),
            ),
            const SizedBox(height: 16),
            // Contact options
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CONTACT',
                    style: TextStyle(
                      color: AppColors.primaryGold.withOpacity(0.8),
                      fontSize: 10,
                      fontFamily: 'JetBrainsMono',
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _ContactRow(
                    icon: Icons.email,
                    text: AppConstants.creatorEmail,
                  ),
                  const SizedBox(height: 6),
                  _ContactRow(
                    icon: Icons.code,
                    text: 'github.com/funbinet',
                  ),
                  const SizedBox(height: 6),
                  _ContactRow(
                    icon: Icons.code_off,
                    text: 'codeberg.org/funbinet',
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thank you for your feedback!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('SEND'),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors.primaryGold),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'JetBrainsMono',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGold, size: 22),
      title: Text(
        label,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 18),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 36,
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderMuted),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.primaryGold),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontFamily: 'JetBrainsMono',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontFamily: 'JetBrainsMono',
            ),
          ),
        ),
      ],
    );
  }
}
