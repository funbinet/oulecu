import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../services/hashtag_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/gold_input.dart';
import '../widgets/custom_button.dart';

class HashtagScreen extends StatefulWidget {
  const HashtagScreen({super.key});

  @override
  State<HashtagScreen> createState() => _HashtagScreenState();
}

class _HashtagScreenState extends State<HashtagScreen> {
  late TextEditingController _linkController;
  late TextEditingController _newTagController;
  final HashtagService _hashtagService = HashtagService();
  bool _saveNewTag = false;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppStateProvider>();
    _linkController = TextEditingController(text: appState.link ?? '');
    _newTagController = TextEditingController();
  }

  @override
  void dispose() {
    _linkController.dispose();
    _newTagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final availableTags = _hashtagService.getAllHashtags();
        final selectedTags = appState.hashtags;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => appState.goBack(),
            ),
            title: const Text('Add Hashtags'),
            actions: [
              TextButton.icon(
                onPressed: () {
                  // Edit tags mode
                },
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Edit'),
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
                        // Link input
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
                              Row(
                                children: [
                                  const Icon(
                                    Icons.link,
                                    size: 18,
                                    color: AppColors.primaryGold,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'LINK',
                                    style: Theme.of(context).textTheme.labelLarge,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              GoldInput(
                                hint: 'Paste your link here...',
                                controller: _linkController,
                                onChanged: appState.setLink,
                                keyboardType: TextInputType.url,
                                prefix: const Icon(Icons.link, size: 18),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Selected tags
                        if (selectedTags.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'SELECTED (${selectedTags.length}/${AppConstants.maxHashtags})',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              TextButton(
                                onPressed: () {
                                  appState.setHashtags([]);
                                },
                                child: const Text('CLEAR ALL'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: selectedTags.map((tag) {
                              return _SelectedTagChip(
                                tag: tag,
                                onRemove: () => appState.removeHashtag(tag),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Available tags
                        Text(
                          'AVAILABLE TAGS',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: availableTags.map((tag) {
                            final isSelected = selectedTags.contains(tag);
                            return _AvailableTagChip(
                              tag: tag,
                              isSelected: isSelected,
                              onTap: () {
                                if (isSelected) {
                                  appState.removeHashtag(tag);
                                } else {
                                  appState.addHashtag(tag);
                                }
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),

                        // Add new tag
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
                                'ADD NEW TAG',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 12),
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
                                      hint: 'Enter new tag...',
                                      controller: _newTagController,
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GoldButton(
                                    label: 'ADD',
                                    isSmall: true,
                                    onPressed: () {
                                      if (_newTagController.text.isNotEmpty) {
                                        final tag = _newTagController.text.trim();
                                        appState.addHashtag(tag);
                                        if (_saveNewTag) {
                                          _hashtagService.addHashtag(tag);
                                        }
                                        _newTagController.clear();
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _saveNewTag,
                                    onChanged: (value) {
                                      setState(() {
                                        _saveNewTag = value ?? false;
                                      });
                                    },
                                  ),
                                  const Text(
                                    'Save to available tags',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
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
                ),
                // Bottom actions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: const Border(
                      top: BorderSide(color: AppColors.borderMuted),
                    ),
                  ),
                  child: ActionButtons(
                    onBack: () => appState.goBack(),
                    onNext: () {
                      appState.setLink(_linkController.text);
                      appState.goNext();
                    },
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

class _SelectedTagChip extends StatelessWidget {
  final String tag;
  final VoidCallback onRemove;

  const _SelectedTagChip({
    required this.tag,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryGold.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#$tag',
            style: const TextStyle(
              color: AppColors.primaryGold,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'JetBrainsMono',
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 16,
              color: AppColors.primaryGold,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailableTagChip extends StatelessWidget {
  final String tag;
  final bool isSelected;
  final VoidCallback onTap;

  const _AvailableTagChip({
    required this.tag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGold.withOpacity(0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryGold.withOpacity(0.4)
                : AppColors.borderMuted,
            width: 1,
          ),
        ),
        child: Text(
          '#$tag',
          style: TextStyle(
            color: isSelected ? AppColors.primaryGold : AppColors.textSecondary,
            fontSize: 12,
            fontFamily: 'JetBrainsMono',
          ),
        ),
      ),
    );
  }
}
