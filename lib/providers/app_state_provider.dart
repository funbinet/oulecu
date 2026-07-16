import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/card_config.dart';
import '../models/template.dart';
import '../models/user_profile.dart';
import '../services/settings_service.dart';
import '../services/storage_service.dart';
import '../services/render_service.dart';
import '../utils/constants.dart';

enum CreationStep {
  home,
  hashtag,
  edit,
  design,
  template,
  preview,
  generating,
  export,
}

class AppStateProvider extends ChangeNotifier {
  final SettingsService _settings = SettingsService();
  final StorageService _storage = StorageService();
  final RenderService _render = RenderService();

  // Current step
  CreationStep _currentStep = CreationStep.home;
  CreationStep get currentStep => _currentStep;

  // Card configuration
  CardConfig _cardConfig = CardConfig();
  CardConfig get cardConfig => _cardConfig;

  // Selected templates
  List<Template> _selectedTemplates = [];
  List<Template> get selectedTemplates => _selectedTemplates;

  // Generated files
  List<String> _generatedFiles = [];
  List<String> get generatedFiles => _generatedFiles;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _loadingMessage = '';
  String get loadingMessage => _loadingMessage;

  double _progress = 0;
  double get progress => _progress;

  // User profile
  UserProfile _userProfile = UserProfile();
  UserProfile get userProfile => _userProfile;

  // Undo/Redo stacks
  final List<CardConfig> _undoStack = [];
  final List<CardConfig> _redoStack = [];

  // Tab switching callback (set by MainScreen)
  VoidCallback? onNavigateToMyContent;

  // Getters for content
  String get topic => _cardConfig.topic;
  String get subtopic => _cardConfig.subtopic;
  String get content => _cardConfig.content;
  List<String> get hashtags => _cardConfig.hashtags;
  String? get link => _cardConfig.link;

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  Future<void> init() async {
    await _settings.init();
    await _loadUserProfile();
    await _loadDefaultSettings();
  }

  Future<void> _loadUserProfile() async {
    _userProfile = UserProfile(
      name: _settings.getUserName(),
      handle: _settings.getUserHandle(),
      avatarPath: _settings.getUserAvatar(),
      cardsGenerated: _settings.getCardsGenerated(),
      tagsUsed: _settings.getTagsUsed(),
      daysActive: _settings.getDaysActive(),
      firstOpenDate: _settings.getFirstOpenDate() > 0
          ? DateTime.fromMillisecondsSinceEpoch(_settings.getFirstOpenDate())
          : null,
    );

    // Load avatar bytes from persisted file
    Uint8List? avatarBytes;
    final avatarPath = _userProfile.avatarPath;
    if (avatarPath != null && avatarPath.isNotEmpty) {
      try {
        final file = File(avatarPath);
        if (await file.exists()) {
          avatarBytes = await file.readAsBytes();
          _userProfile = _userProfile.copyWith(avatarBytes: avatarBytes);
        }
      } catch (e) {
        debugPrint('Error loading avatar: $e');
      }
    }

    // Update card config with user profile
    _cardConfig = _cardConfig.copyWith(
      name: _userProfile.name,
      handle: _userProfile.handle,
      avatarPath: _userProfile.avatarPath,
      avatarBytes: avatarBytes,
    );

    notifyListeners();
  }

  Future<void> _loadDefaultSettings() async {
    _cardConfig = _cardConfig.copyWith(
      fontFamily: _settings.getDefaultFont(),
      fontSize: _settings.getDefaultFontSize(),
      textColor: Color(_settings.getDefaultTextColor()),
      backgroundColor: Color(_settings.getDefaultBgColor()),
      accentColor: Color(_settings.getDefaultAccentColor()),
      showDate: _settings.getShowDate(),
      showTime: _settings.getShowTime(),
      logoPlacement: _settings.getLogoPlacement(),
      exportFormats: [_settings.getDefaultFormat()],
      quality: _settings.getExportQuality(),
      cardWidth: _settings.getDefaultCardWidth(),
      cardHeight: _settings.getDefaultCardHeight(),
    );
    notifyListeners();
  }

  /// Reload user profile from settings (call after settings changes)
  Future<void> reloadUserProfile() async {
    await _loadUserProfile();
  }

  // Navigation
  void setStep(CreationStep step) {
    _currentStep = step;
    notifyListeners();
  }

  void goBack() {
    switch (_currentStep) {
      case CreationStep.home:
        break;
      case CreationStep.hashtag:
        _currentStep = CreationStep.home;
        break;
      case CreationStep.edit:
        _currentStep = CreationStep.hashtag;
        break;
      case CreationStep.design:
        _currentStep = CreationStep.edit;
        break;
      case CreationStep.template:
        _currentStep = CreationStep.design;
        break;
      case CreationStep.preview:
        _currentStep = CreationStep.template;
        break;
      case CreationStep.generating:
        _currentStep = CreationStep.preview;
        break;
      case CreationStep.export:
        _currentStep = CreationStep.generating;
        break;
    }
    notifyListeners();
  }

  void goNext() {
    switch (_currentStep) {
      case CreationStep.home:
        _saveStateForUndo();
        _currentStep = CreationStep.hashtag;
        break;
      case CreationStep.hashtag:
        _currentStep = CreationStep.edit;
        break;
      case CreationStep.edit:
        _currentStep = CreationStep.design;
        break;
      case CreationStep.design:
        _currentStep = CreationStep.template;
        break;
      case CreationStep.template:
        _currentStep = CreationStep.preview;
        break;
      case CreationStep.preview:
        _currentStep = CreationStep.generating;
        break;
      case CreationStep.generating:
        _currentStep = CreationStep.export;
        break;
      case CreationStep.export:
        _currentStep = CreationStep.home;
        _resetWorkflow();
        break; // Changed from return to break so notifyListeners is called
    }
    notifyListeners();
  }

  /// Reset workflow completely (called when manually navigating to Home)
  void resetToHome() {
    _currentStep = CreationStep.home;
    _resetWorkflow();
    notifyListeners();
  }

  /// Navigate to My Content tab after generation
  void navigateToMyContent() {
    _currentStep = CreationStep.home;
    _resetWorkflow();
    onNavigateToMyContent?.call();
    notifyListeners();
  }

  void _resetWorkflow() {
    _cardConfig = CardConfig(
      name: _userProfile.name,
      handle: _userProfile.handle,
      avatarPath: _userProfile.avatarPath,
      avatarBytes: _userProfile.avatarBytes,
      fontFamily: _settings.getDefaultFont(),
      fontSize: _settings.getDefaultFontSize(),
      textColor: Color(_settings.getDefaultTextColor()),
      backgroundColor: Color(_settings.getDefaultBgColor()),
      accentColor: Color(_settings.getDefaultAccentColor()),
    );
    _selectedTemplates = [];
    _generatedFiles = [];
    _undoStack.clear();
    _redoStack.clear();
    notifyListeners();
  }

  // Content editing
  void setTopic(String value) {
    _cardConfig = _cardConfig.copyWith(topic: value);
    notifyListeners();
  }

  void setSubtopic(String value) {
    _cardConfig = _cardConfig.copyWith(subtopic: value);
    notifyListeners();
  }

  void setContent(String value) {
    _saveStateForUndo();
    _cardConfig = _cardConfig.copyWith(content: value);
    notifyListeners();
  }

  void setContentImage(String? imagePath, Uint8List? bytes) {
    _cardConfig.contentImagePath = imagePath;
    _cardConfig.contentImageBytes = bytes;
    notifyListeners();
  }

  // Hashtags
  void setHashtags(List<String> tags) {
    if (tags.length <= AppConstants.maxHashtags) {
      _cardConfig = _cardConfig.copyWith(hashtags: tags);
      notifyListeners();
    }
  }

  void addHashtag(String tag) {
    final cleanTag = tag.replaceAll('#', '').trim();
    if (cleanTag.isNotEmpty &&
        !_cardConfig.hashtags.contains(cleanTag) &&
        _cardConfig.hashtags.length < AppConstants.maxHashtags) {
      final newTags = [..._cardConfig.hashtags, cleanTag];
      _cardConfig = _cardConfig.copyWith(hashtags: newTags);
      notifyListeners();
    }
  }

  void removeHashtag(String tag) {
    final cleanTag = tag.replaceAll('#', '').trim();
    final newTags = _cardConfig.hashtags.where((t) => t != cleanTag).toList();
    _cardConfig = _cardConfig.copyWith(hashtags: newTags);
    notifyListeners();
  }

  void setLink(String? value) {
    _cardConfig = _cardConfig.copyWith(link: value);
    notifyListeners();
  }

  // Edit screen
  void setName(String value) {
    _cardConfig = _cardConfig.copyWith(name: value);
    _userProfile = _userProfile.copyWith(name: value);
    _settings.setUserName(value);
    notifyListeners();
  }

  void setHandle(String value) {
    final cleanHandle = value.startsWith('@') ? value : '@$value';
    _cardConfig = _cardConfig.copyWith(handle: cleanHandle);
    _userProfile = _userProfile.copyWith(handle: cleanHandle);
    _settings.setUserHandle(cleanHandle);
    notifyListeners();
  }

  /// Set avatar and persist to app documents directory
  Future<void> setAvatar(String? imagePath, Uint8List? bytes) async {
    if (imagePath != null && bytes != null) {
      try {
        // Persist avatar to app documents directory
        final appDir = await getApplicationDocumentsDirectory();
        final avatarFile = File(path.join(appDir.path, 'oulecu_avatar.png'));
        await avatarFile.writeAsBytes(bytes);
        final persistedPath = avatarFile.path;

        _cardConfig.avatarPath = persistedPath;
        _cardConfig.avatarBytes = bytes;
        _userProfile = _userProfile.copyWith(
          avatarPath: persistedPath,
          avatarBytes: bytes,
        );
        _settings.setUserAvatar(persistedPath);
      } catch (e) {
        debugPrint('Error persisting avatar: $e');
        // Fallback: use in-memory only
        _cardConfig.avatarPath = imagePath;
        _cardConfig.avatarBytes = bytes;
        _userProfile = _userProfile.copyWith(
          avatarPath: imagePath,
          avatarBytes: bytes,
        );
      }
    } else {
      _cardConfig.avatarPath = null;
      _cardConfig.avatarBytes = null;
      _userProfile = _userProfile.copyWith(avatarPath: null, avatarBytes: null);
    }
    notifyListeners();
  }

  void setShowDate(bool value) {
    _cardConfig = _cardConfig.copyWith(showDate: value);
    notifyListeners();
  }

  void setShowTime(bool value) {
    _cardConfig = _cardConfig.copyWith(showTime: value);
    notifyListeners();
  }

  void setShowLocation(bool value) {
    _cardConfig = _cardConfig.copyWith(showLocation: value);
    notifyListeners();
  }

  void setLogoPlacement(String placement) {
    _cardConfig = _cardConfig.copyWith(logoPlacement: placement);
    notifyListeners();
  }

  // Design
  void setBackgroundColor(Color color) {
    _cardConfig = _cardConfig.copyWith(backgroundColor: color);
    notifyListeners();
  }

  void setTextColor(Color color) {
    _cardConfig = _cardConfig.copyWith(textColor: color);
    notifyListeners();
  }

  void setAccentColor(Color color) {
    _cardConfig = _cardConfig.copyWith(accentColor: color);
    notifyListeners();
  }

  void setFontFamily(String font) {
    _cardConfig = _cardConfig.copyWith(fontFamily: font);
    notifyListeners();
  }

  void setFontSize(double size) {
    _cardConfig = _cardConfig.copyWith(fontSize: size);
    notifyListeners();
  }

  void setTextAlign(TextAlign align) {
    _cardConfig = _cardConfig.copyWith(textAlign: align);
    notifyListeners();
  }

  void setFontWeight(FontWeight weight) {
    _cardConfig = _cardConfig.copyWith(fontWeight: weight);
    notifyListeners();
  }

  void setFontStyle(FontStyle style) {
    _cardConfig = _cardConfig.copyWith(fontStyle: style);
    notifyListeners();
  }

  void setBorderWidth(double width) {
    _cardConfig = _cardConfig.copyWith(borderWidth: width);
    notifyListeners();
  }

  void setBorderColor(Color color) {
    _cardConfig = _cardConfig.copyWith(borderColor: color);
    notifyListeners();
  }

  void setBorderStyle(String style) {
    _cardConfig = _cardConfig.copyWith(borderStyle: style);
    notifyListeners();
  }

  void setShadowEnabled(bool enabled) {
    _cardConfig = _cardConfig.copyWith(shadowEnabled: enabled);
    notifyListeners();
  }

  void setCornerStyle(String style) {
    _cardConfig = _cardConfig.copyWith(cornerStyle: style);
    notifyListeners();
  }

  void setCornerRadius(double radius) {
    _cardConfig = _cardConfig.copyWith(cornerRadius: radius);
    notifyListeners();
  }

  void setCardDimensions(double width, double height) {
    _cardConfig = _cardConfig.copyWith(cardWidth: width, cardHeight: height);
    notifyListeners();
  }

  void setGradientEndColor(Color? color) {
    _cardConfig = _cardConfig.copyWith(gradientEndColor: color);
    notifyListeners();
  }

  // Templates
  void setSelectedTemplates(List<Template> templates) {
    _selectedTemplates = templates;
    notifyListeners();
  }

  void toggleTemplate(Template template) {
    final exists = _selectedTemplates.any((t) => t.id == template.id);
    if (exists) {
      _selectedTemplates = _selectedTemplates.where((t) => t.id != template.id).toList();
    } else {
      _selectedTemplates = [..._selectedTemplates, template];
    }
    notifyListeners();
  }

  // Export
  void setExportFormats(List<String> formats) {
    _cardConfig = _cardConfig.copyWith(exportFormats: formats);
    notifyListeners();
  }

  void setQuality(int quality) {
    _cardConfig = _cardConfig.copyWith(quality: quality);
    notifyListeners();
  }

  // Undo/Redo
  void _saveStateForUndo() {
    _undoStack.add(CardConfig.fromJson(_cardConfig.toJson()));
    if (_undoStack.length > 50) _undoStack.removeAt(0);
    _redoStack.clear();
  }

  void undo() {
    if (_undoStack.isNotEmpty) {
      _redoStack.add(CardConfig.fromJson(_cardConfig.toJson()));
      _cardConfig = _undoStack.removeLast();
      notifyListeners();
    }
  }

  void redo() {
    if (_redoStack.isNotEmpty) {
      _undoStack.add(CardConfig.fromJson(_cardConfig.toJson()));
      _cardConfig = _redoStack.removeLast();
      notifyListeners();
    }
  }

  // Generation
  Future<void> generateCards() async {
    _isLoading = true;
    _progress = 0;
    _loadingMessage = 'Preparing...';
    notifyListeners();

    try {
      final total = _selectedTemplates.length * _cardConfig.exportFormats.length;
      int completed = 0;

      final results = <String>[];

      for (final template in _selectedTemplates) {
        for (final format in _cardConfig.exportFormats) {
          _loadingMessage = AppConstants.generationMessages[
              completed % AppConstants.generationMessages.length];
          notifyListeners();

          final config = _cardConfig.copyWith(exportFormats: [format]);
          final files = await _render.renderCards(config, [template], [format]);
          results.addAll(files);

          completed++;
          _progress = completed / total;
          notifyListeners();
        }
      }

      _generatedFiles = results;

      // Update stats
      await _settings.incrementCardsGenerated();
      _userProfile = _userProfile.copyWith(
        cardsGenerated: _settings.getCardsGenerated(),
      );

      // Save card metadata
      for (final filePath in results) {
        final file = File(filePath);
        if (await file.exists()) {
          final stat = await file.stat();
          final card = GeneratedCard(
            filePath: filePath,
            timestamp: DateTime.now().millisecondsSinceEpoch,
            format: filePath.split('.').last.toUpperCase(),
            size: stat.size,
            tags: _cardConfig.hashtags,
            topic: _cardConfig.topic,
            subtopic: _cardConfig.subtopic,
          );
          await _storage.insertGeneratedCard(card);
        }
      }
    } catch (e) {
      debugPrint('Generation error: $e');
    } finally {
      _isLoading = false;
      _progress = 1;
      notifyListeners();
    }
  }

  // Statistics
  Future<void> updateStats() async {
    _userProfile = _userProfile.copyWith(
      cardsGenerated: _settings.getCardsGenerated(),
      tagsUsed: _settings.getTagsUsed(),
      daysActive: _settings.getDaysActive(),
    );
    notifyListeners();
  }
}
