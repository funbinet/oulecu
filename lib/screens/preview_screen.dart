import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';
import '../utils/shape_utils.dart';
import '../utils/markdown_parser.dart';

import '../widgets/custom_button.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  int _currentIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final templates = appState.selectedTemplates;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => appState.goBack(),
            ),
            title: const Text('Preview Cards'),
            actions: [
              if (templates.length > 1)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      '${_currentIndex + 1}/${templates.length}',
                      style: TextStyle(
                        color: AppColors.primaryGold,
                        fontSize: 14,
                        fontFamily: 'JetBrainsMono',
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: templates.length == 1
                      ? _buildSinglePreview(appState, templates.first)
                      : _buildMultiPreview(appState, templates),
                ),
                // Bottom actions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border(top: BorderSide(color: AppColors.borderMuted)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GoldButton(
                              label: 'Back',
                              onPressed: () => appState.goBack(),
                              isOutlined: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GoldButton(
                              label: 'Generate',
                              onPressed: () => _showExportDialog(context, appState),
                              icon: Icons.download,
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
        );
      },
    );
  }

  Widget _buildSinglePreview(dynamic appState, dynamic template) {
    return Center(
      child: _CardPreviewWidget(
        appState: appState,
        template: template,
      ),
    );
  }

  Widget _buildMultiPreview(dynamic appState, List<dynamic> templates) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemCount: templates.length,
      itemBuilder: (context, index) {
        return Center(
          child: _CardPreviewWidget(
            appState: appState,
            template: templates[index],
          ),
        );
      },
    );
  }

  void _showExportDialog(BuildContext context, AppStateProvider appState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _ExportFormatSheet(appState: appState),
    );
  }
}

class _CardPreviewWidget extends StatelessWidget {
  final dynamic appState;
  final dynamic template;

  const _CardPreviewWidget({
    required this.appState,
    required this.template,
  });

  @override
  Widget build(BuildContext context) {
    final config = appState.cardConfig;

    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldGlow.withOpacity(0.3),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: config.cardWidth / config.cardHeight,
        child: Container(
          decoration: BoxDecoration(
            gradient: template.gradientEndColor != null
                ? LinearGradient(
                    colors: [template.backgroundColor, template.gradientEndColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: template.gradientEndColor == null ? template.backgroundColor : null,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: template.accentColor.withOpacity(0.5), width: config.borderWidth > 0 ? config.borderWidth : 2.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: config.cardWidth,
                height: config.cardHeight,
                child: _buildCardContent(config, template),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(dynamic config, dynamic template) {
    return Padding(
      padding: const EdgeInsets.all(32), // Scales nicely with larger width/height
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User row
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: template.accentColor.withOpacity(0.2),
                  border: Border.all(color: template.accentColor, width: 1.5),
                  image: config.avatarBytes != null
                      ? DecorationImage(
                          image: MemoryImage(config.avatarBytes as Uint8List),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: config.avatarBytes == null
                    ? Icon(Icons.person, size: 24, color: template.accentColor)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.name,
                      style: TextStyle(
                        color: config.textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: config.fontFamily,
                      ),
                    ),
                    Text(
                      config.handle,
                      style: TextStyle(
                        color: config.accentColor.withOpacity(0.7),
                        fontSize: 12,
                        fontFamily: config.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'OULECU',
                style: TextStyle(
                  color: template.accentColor.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JetBrainsMono',
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Topic
          if (config.topic.isNotEmpty)
            Text(
              config.topic.toUpperCase(),
              style: TextStyle(
                color: template.accentColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: config.fontFamily,
                letterSpacing: 2,
              ),
            ),
          if (config.subtopic.isNotEmpty)
            Text(
              config.subtopic,
              style: TextStyle(
                color: config.textColor.withOpacity(0.7),
                fontSize: 13,
                fontFamily: config.fontFamily,
              ),
            ),
          const SizedBox(height: 12),
          // Content image
          if (config.contentImageBytes != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                config.contentImageBytes as Uint8List,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          if (config.contentImageBytes != null) const SizedBox(height: 16),
          // Content
          Expanded(
            child: Text.rich(
              MarkdownParser.parse(
                config.content,
                TextStyle(
                  color: template.textColor.withOpacity(0.9),
                  fontSize: config.fontSize,
                  fontFamily: config.fontFamily,
                  height: 1.5,
                  fontWeight: config.fontWeight,
                  fontStyle: config.fontStyle,
                ),
              ),
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              textAlign: config.textAlign,
            ),
          ),
          // Hashtags
          if (config.hashtags.isNotEmpty)
            Wrap(
              spacing: 8,
              children: config.hashtags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: template.accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: template.accentColor.withOpacity(0.3),
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    '#$tag',
                    style: TextStyle(
                      color: template.accentColor,
                      fontSize: 12,
                      fontFamily: config.fontFamily,
                    ),
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 8),
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (config.link != null && config.link.isNotEmpty)
                Expanded(
                  child: Text(
                    config.link.toString().replaceAll(RegExp(r'^https?://'), ''),
                    style: TextStyle(
                      color: template.accentColor.withOpacity(0.6),
                      fontSize: 14,
                      fontFamily: config.fontFamily,
                      decoration: TextDecoration.underline,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (config.showDate)
                    Text(
                      '13/07/2025',
                      style: TextStyle(
                        color: template.textColor.withOpacity(0.4),
                        fontSize: 14,
                        fontFamily: config.fontFamily,
                      ),
                    ),
                  if (config.showDate && config.showTime)
                    Text(
                      '  |  ',
                      style: TextStyle(
                        color: template.textColor.withOpacity(0.2),
                        fontSize: 14,
                      ),
                    ),
                  if (config.showTime)
                    Text(
                      '12:00',
                      style: TextStyle(
                        color: template.textColor.withOpacity(0.4),
                        fontSize: 14,
                        fontFamily: config.fontFamily,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExportFormatSheet extends StatefulWidget {
  final AppStateProvider appState;

  const _ExportFormatSheet({required this.appState});

  @override
  State<_ExportFormatSheet> createState() => _ExportFormatSheetState();
}

class _ExportFormatSheetState extends State<_ExportFormatSheet> {
  final List<String> _selectedFormats = ['PNG'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SELECT EXPORT FORMAT',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 20),
            _buildFormatOption('PNG', 'Best quality, larger file', true),
            const SizedBox(height: 12),
            _buildFormatOption('JPG', 'Good compression', false),
            const SizedBox(height: 12),
            _buildFormatOption('JPEG', 'Same as JPG', false),
            const SizedBox(height: 12),
            _buildFormatOption('WebP', 'Modern format', false),
            const SizedBox(height: 24),
            GoldButton(
              label: 'Generate Cards',
              onPressed: () {
                widget.appState.setExportFormats(_selectedFormats);
                Navigator.pop(context);
                widget.appState.goNext();
              },
              icon: Icons.download,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatOption(String format, String description, bool isDefault) {
    final isSelected = _selectedFormats.contains(format);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected && _selectedFormats.length > 1) {
            _selectedFormats.remove(format);
          } else if (!isSelected) {
            _selectedFormats.add(format);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGold.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryGold : AppColors.borderMuted,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryGold : AppColors.textMuted,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Icon(
                        Icons.check,
                        size: 14,
                        color: AppColors.primaryGold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    format,
                    style: TextStyle(
                      color: isSelected ? AppColors.primaryGold : AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrainsMono',
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isDefault)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'DEFAULT',
                  style: TextStyle(
                    color: AppColors.primaryGold,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
