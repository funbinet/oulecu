import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('SettingsService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // Theme
  String? getThemeMode() => prefs.getString(AppConstants.keyThemeMode);
  Future<void> setThemeMode(String mode) => prefs.setString(AppConstants.keyThemeMode, mode);
  
  bool getAmoledTheme() => prefs.getBool('keyAmoledTheme') ?? true;
  Future<void> setAmoledTheme(bool isAmoled) => prefs.setBool('keyAmoledTheme', isAmoled);

  // App Customization
  String getAppName() => prefs.getString(AppConstants.keyAppName) ?? AppConstants.defaultAppName;
  Future<void> setAppName(String name) => prefs.setString(AppConstants.keyAppName, name);

  int getAppIconIndex() => prefs.getInt(AppConstants.keyAppIconIndex) ?? 0;
  Future<void> setAppIconIndex(int index) => prefs.setInt(AppConstants.keyAppIconIndex, index);

  // User Profile
  String getUserName() => prefs.getString(AppConstants.keyUserName) ?? AppConstants.defaultUserName;
  Future<void> setUserName(String name) => prefs.setString(AppConstants.keyUserName, name);

  String getUserHandle() => prefs.getString(AppConstants.keyUserHandle) ?? AppConstants.defaultUserHandle;
  Future<void> setUserHandle(String handle) => prefs.setString(AppConstants.keyUserHandle, handle);

  String? getUserAvatar() => prefs.getString(AppConstants.keyUserAvatar);
  Future<void> setUserAvatar(String path) => prefs.setString(AppConstants.keyUserAvatar, path);

  // Hashtags
  List<String> getHashtags() {
    final jsonStr = prefs.getString(AppConstants.keyHashtags);
    if (jsonStr == null) return List.from(AppConstants.defaultHashtags);
    try {
      return List<String>.from(jsonDecode(jsonStr));
    } catch (_) {
      return List.from(AppConstants.defaultHashtags);
    }
  }

  Future<void> setHashtags(List<String> tags) => prefs.setString(AppConstants.keyHashtags, jsonEncode(tags));

  Future<void> addHashtag(String tag) async {
    final tags = getHashtags();
    final cleanTag = tag.replaceAll('#', '').trim().toLowerCase();
    if (cleanTag.isNotEmpty && !tags.contains(cleanTag) && tags.length < AppConstants.maxHashtagStorage) {
      tags.add(cleanTag);
      await setHashtags(tags);
    }
  }

  Future<void> removeHashtag(String tag) async {
    final tags = getHashtags();
    tags.remove(tag.replaceAll('#', '').trim().toLowerCase());
    await setHashtags(tags);
  }

  // Export Settings
  String getDefaultFormat() => prefs.getString(AppConstants.keyDefaultFormat) ?? AppConstants.defaultFormat;
  Future<void> setDefaultFormat(String format) => prefs.setString(AppConstants.keyDefaultFormat, format);

  int getExportQuality() => prefs.getInt(AppConstants.keyExportQuality) ?? AppConstants.defaultQuality;
  Future<void> setExportQuality(int quality) => prefs.setInt(AppConstants.keyExportQuality, quality);

  String getSaveLocation() => prefs.getString(AppConstants.keySaveLocation) ?? 'Downloads';
  Future<void> setSaveLocation(String location) => prefs.setString(AppConstants.keySaveLocation, location);

  // Card Defaults
  String getDefaultFont() => prefs.getString(AppConstants.keyDefaultFont) ?? AppConstants.defaultFont;
  Future<void> setDefaultFont(String font) => prefs.setString(AppConstants.keyDefaultFont, font);

  double getDefaultFontSize() => prefs.getDouble(AppConstants.keyDefaultFontSize) ?? AppConstants.defaultFontSize;
  Future<void> setDefaultFontSize(double size) => prefs.setDouble(AppConstants.keyDefaultFontSize, size);

  int getDefaultTextColor() => prefs.getInt(AppConstants.keyDefaultTextColor) ?? 0xFFFFFFFF;
  Future<void> setDefaultTextColor(int color) => prefs.setInt(AppConstants.keyDefaultTextColor, color);

  int getDefaultBgColor() => prefs.getInt(AppConstants.keyDefaultBgColor) ?? 0xFF000000;
  Future<void> setDefaultBgColor(int color) => prefs.setInt(AppConstants.keyDefaultBgColor, color);

  int getDefaultAccentColor() => prefs.getInt(AppConstants.keyDefaultAccentColor) ?? 0xFFFFD700;
  Future<void> setDefaultAccentColor(int color) => prefs.setInt(AppConstants.keyDefaultAccentColor, color);

  double getDefaultCardWidth() => prefs.getDouble(AppConstants.keyDefaultCardWidth) ?? AppConstants.defaultCardWidth;
  Future<void> setDefaultCardWidth(double width) => prefs.setDouble(AppConstants.keyDefaultCardWidth, width);

  double getDefaultCardHeight() => prefs.getDouble(AppConstants.keyDefaultCardHeight) ?? AppConstants.defaultCardHeight;
  Future<void> setDefaultCardHeight(double height) => prefs.setDouble(AppConstants.keyDefaultCardHeight, height);

  // Display Settings
  bool getShowDate() => prefs.getBool(AppConstants.keyShowDate) ?? true;
  Future<void> setShowDate(bool show) => prefs.setBool(AppConstants.keyShowDate, show);

  bool getShowTime() => prefs.getBool(AppConstants.keyShowTime) ?? true;
  Future<void> setShowTime(bool show) => prefs.setBool(AppConstants.keyShowTime, show);

  bool getShowLocation() => prefs.getBool(AppConstants.keyShowLocation) ?? false;
  Future<void> setShowLocation(bool show) => prefs.setBool(AppConstants.keyShowLocation, show);

  String getLogoPlacement() => prefs.getString(AppConstants.keyLogoPlacement) ?? 'Bottom Right';
  Future<void> setLogoPlacement(String placement) => prefs.setString(AppConstants.keyLogoPlacement, placement);

  // Presets
  List<Map<String, dynamic>> getPresets() {
    final jsonStr = prefs.getString(AppConstants.keyPresets);
    if (jsonStr == null) return [];
    try {
      return List<Map<String, dynamic>>.from(jsonDecode(jsonStr));
    } catch (_) {
      return [];
    }
  }

  Future<void> setPresets(List<Map<String, dynamic>> presets) =>
      prefs.setString(AppConstants.keyPresets, jsonEncode(presets));

  // Statistics
  int getCardsGenerated() => prefs.getInt(AppConstants.keyCardsGenerated) ?? 0;
  Future<void> setCardsGenerated(int count) => prefs.setInt(AppConstants.keyCardsGenerated, count);
  Future<void> incrementCardsGenerated() => prefs.setInt(AppConstants.keyCardsGenerated, getCardsGenerated() + 1);

  int getTagsUsed() => prefs.getInt(AppConstants.keyTagsUsed) ?? 0;
  Future<void> setTagsUsed(int count) => prefs.setInt(AppConstants.keyTagsUsed, count);

  int getDaysActive() => prefs.getInt(AppConstants.keyDaysActive) ?? 0;
  Future<void> setDaysActive(int count) => prefs.setInt(AppConstants.keyDaysActive, count);

  int getFirstOpenDate() => prefs.getInt(AppConstants.keyFirstOpenDate) ?? 0;
  Future<void> setFirstOpenDate(int timestamp) => prefs.setInt(AppConstants.keyFirstOpenDate, timestamp);

  // Reset
  Future<void> resetAll() async {
    await prefs.clear();
  }
}
