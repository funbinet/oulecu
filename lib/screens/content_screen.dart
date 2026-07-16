import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  final StorageService _storage = StorageService();
  List<GeneratedCard> _cards = [];
  bool _isLoading = true;
  String _sortBy = 'Latest';

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final cards = await _storage.getAllGeneratedCards();
      setState(() {
        _cards = _sortCards(cards);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<GeneratedCard> _sortCards(List<GeneratedCard> cards) {
    switch (_sortBy) {
      case 'Oldest':
        return cards..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      case 'A-Z':
        return cards..sort((a, b) => a.filePath.compareTo(b.filePath));
      case 'Latest':
      default:
        return cards..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Content'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            onPressed: () {
              // Show filter options
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              // Show search
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter tabs
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: ['Latest', 'Oldest', 'A-Z'].map((sort) {
                  final isSelected = _sortBy == sort;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _sortBy = sort;
                          _cards = _sortCards(_cards);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryGold.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryGold : AppColors.borderMuted,
                          ),
                        ),
                        child: Text(
                          sort.toUpperCase(),
                          style: TextStyle(
                            color: isSelected ? AppColors.primaryGold : AppColors.textSecondary,
                            fontSize: 11,
                            fontFamily: 'JetBrainsMono',
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Content grid
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
                      ),
                    )
                  : _cards.isEmpty
                      ? _buildEmptyState()
                      : _buildGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: AppColors.textMuted.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No Content Yet',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Generated cards will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted.withOpacity(0.7),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return RefreshIndicator(
      onRefresh: _loadCards,
      color: AppColors.primaryGold,
      backgroundColor: AppColors.surface,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          return _ImageCard(
            card: card,
            onTap: () => _showImageOptions(context, card),
          );
        },
      ),
    );
  }

  void _showImageOptions(BuildContext context, GeneratedCard card) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Thumbnail preview
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderMuted),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(card.filePath),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                card.filePath.split('/').last,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontFamily: 'JetBrainsMono',
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.divider),
              ListTile(
                leading: const Icon(Icons.visibility, color: AppColors.primaryGold),
                title: const Text('View', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  Navigator.pop(context);
                  _showFullImage(context, card);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: AppColors.primaryGold),
                title: const Text('Share', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () async {
                  Navigator.pop(context);
                  await Share.shareXFiles(
                    [XFile(card.filePath)],
                    text: 'Created with OULECU',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: AppColors.error),
                title: const Text('Delete', style: TextStyle(color: AppColors.error)),
                onTap: () async {
                  Navigator.pop(context);
                  await _storage.deleteGeneratedCard(card.id!);
                  _loadCards();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context, GeneratedCard card) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4,
            child: Image.file(
              File(card.filePath),
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.surface,
                padding: const EdgeInsets.all(32),
                child: const Icon(
                  Icons.broken_image,
                  size: 64,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  final GeneratedCard card;
  final VoidCallback onTap;

  const _ImageCard({
    required this.card,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderMuted),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(card.filePath),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image,
                    size: 32,
                    color: AppColors.textMuted.withOpacity(0.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card.filePath.split('/').last,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                      fontFamily: 'JetBrainsMono',
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
