import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/gold_input.dart';
import '../widgets/text_editor_tools.dart';
import '../widgets/custom_button.dart';
import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _topicController;
  late TextEditingController _subtopicController;
  late quill.QuillController _quillController;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppStateProvider>();
    _topicController = TextEditingController(text: appState.topic);
    _subtopicController = TextEditingController(text: appState.subtopic);
    if (appState.cardConfig.quillDeltaJson != null && appState.cardConfig.quillDeltaJson!.isNotEmpty) {
      try {
        final doc = quill.Document.fromJson(jsonDecode(appState.cardConfig.quillDeltaJson!));
        _quillController = quill.QuillController(document: doc, selection: const TextSelection.collapsed(offset: 0));
      } catch (_) {
        _quillController = quill.QuillController.basic();
      }
    } else {
      _quillController = quill.QuillController.basic();
      if (appState.content.isNotEmpty) {
        _quillController.document.insert(0, appState.content);
      }
    }

    // Listen to text changes to update Next button and Discard state
    _topicController.addListener(_onInputChanged);
    _subtopicController.addListener(_onInputChanged);
    _quillController.addListener(() {
      final jsonStr = jsonEncode(_quillController.document.toDelta().toJson());
      context.read<AppStateProvider>().setQuillDeltaJson(jsonStr);
      _onInputChanged();
    });
  }

  void _onInputChanged() {
    setState(() {}); // Rebuild to re-evaluate Next/Discard button states
  }

  @override
  void dispose() {
    _topicController.removeListener(_onInputChanged);
    _subtopicController.removeListener(_onInputChanged);
    _quillController.dispose();
    _topicController.dispose();
    _subtopicController.dispose();
    super.dispose();
  }

  bool get _hasContent {
    return _topicController.text.trim().isNotEmpty ||
        _subtopicController.text.trim().isNotEmpty ||
        _quillController.document.toPlainText().trim().isNotEmpty;
  }

  bool get _canProceed {
    return _quillController.document.toPlainText().trim().isNotEmpty ||
        context.read<AppStateProvider>().cardConfig.contentImageBytes != null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final hasImage = appState.cardConfig.contentImageBytes != null;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 28,
                  height: 28,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.image,
                    color: AppColors.primaryGold,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 10),
                const Text('OULECU'),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Content area
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Topic input
                        GoldInput(
                          label: 'TOPIC',
                          hint: 'Enter topic...',
                          controller: _topicController,
                          onChanged: appState.setTopic,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 12),
                        // Subtopic input
                        GoldInput(
                          label: 'SUBTOPIC',
                          hint: 'Enter subtopic...',
                          controller: _subtopicController,
                          onChanged: appState.setSubtopic,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        // Content text area with styling applied
                        _buildContentArea(appState),
                        const SizedBox(height: 12),
                        // Quill Toolbar
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: quill.QuillSimpleToolbar(
                            controller: _quillController,
                            config: quill.QuillSimpleToolbarConfig(
                              showFontFamily: false,
                              showFontSize: false,
                              showListNumbers: true,
                              showListBullets: true,
                              showIndent: false,
                              showLink: true,
                              showCodeBlock: false,
                              showInlineCode: false,
                              showSearchButton: false,
                              showSubscript: false,
                              showSuperscript: false,
                              showDirection: false,
                              showUndo: true,
                              showRedo: true,
                              showBackgroundColorButton: false,
                              showColorButton: true,
                              customButtons: [
                                quill.QuillToolbarCustomButtonOptions(
                                  icon: const Icon(Icons.image),
                                  onPressed: () => _showImagePicker(context, appState),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom action bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      top: BorderSide(color: AppColors.borderMuted, width: 1),
                    ),
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        DiscardButton(
                          enabled: _hasContent || hasImage,
                          onDiscard: () {
                            _topicController.clear();
                            _subtopicController.clear();
                            _quillController.document = quill.Document();
                            appState.setTopic('');
                            appState.setSubtopic('');
                            appState.setQuillDeltaJson('');
                            appState.setContentImage(null, null);
                          },
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 140,
                          child: GoldButton(
                            label: 'NEXT',
                            onPressed: (_quillController.document.toPlainText().trim().isNotEmpty || hasImage)
                                ? () {
                                    appState.setTopic(_topicController.text);
                                    appState.setSubtopic(_subtopicController.text);
                                    appState.goNext();
                                  }
                                : null,
                            icon: Icons.arrow_forward,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContentArea(AppStateProvider appState) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderMuted, width: 1),
      ),
      child: Column(
        children: [
          // Content image (if any)
          if (appState.cardConfig.contentImageBytes != null)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: Image.memory(
                    appState.cardConfig.contentImageBytes!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: double.infinity,
                      height: 200,
                      color: AppColors.surfaceLight,
                      child: Center(
                        child: Icon(Icons.broken_image, color: AppColors.textMuted, size: 48),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => appState.setContentImage(null, null),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          // Content text field — now with Quill Editor
          Container(
            padding: const EdgeInsets.all(12),
            height: 250,
            child: quill.QuillEditor.basic(
              controller: _quillController,
              config: const quill.QuillEditorConfig(),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePicker(BuildContext context, AppStateProvider appState) {
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
                'INSERT IMAGE',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Icon(Icons.photo_library_outlined, color: AppColors.primaryGold),
                title: Text(
                  'Gallery',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                subtitle: Text(
                  'Choose from your photos',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final picked = await _imagePicker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 1920,
                      maxHeight: 1920,
                      imageQuality: 85,
                    );
                    if (picked != null) {
                      final bytes = await picked.readAsBytes();
                      appState.setContentImage(picked.path, bytes);
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to pick image')),
                      );
                    }
                  }
                },
              ),
              const Divider(color: AppColors.divider),
              ListTile(
                leading: Icon(Icons.camera_alt_outlined, color: AppColors.primaryGold),
                title: Text(
                  'Camera',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                subtitle: Text(
                  'Take a new photo',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final picked = await _imagePicker.pickImage(
                      source: ImageSource.camera,
                      maxWidth: 1920,
                      maxHeight: 1920,
                      imageQuality: 85,
                    );
                    if (picked != null) {
                      final bytes = await picked.readAsBytes();
                      appState.setContentImage(picked.path, bytes);
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to capture image')),
                      );
                    }
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
