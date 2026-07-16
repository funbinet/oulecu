import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/settings_service.dart';
import '../theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  final SettingsService _settings = SettingsService();

  ThemeMode _themeMode = ThemeMode.dark;
  bool _isAmoled = true;

  ThemeMode get themeMode => _themeMode;
  bool get isAmoled => _isAmoled;

  ThemeData get currentTheme => AppTheme.getTheme(isAmoled: _isAmoled);

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> init() async {
    await _settings.init();
    final saved = _settings.getThemeMode();
    if (saved != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.name == saved,
        orElse: () => ThemeMode.dark,
      );
    }
    _isAmoled = _settings.getAmoledTheme();
    AppColors.isAmoled = _isAmoled;
    
    final primary = _settings.getAppThemePrimary();
    final secondary = _settings.getAppThemeSecondary();
    AppColors.setAccentColor(
      Color(primary), 
      secondary != null ? Color(secondary) : null,
    );
    
    _updateSystemUI();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _settings.setThemeMode(mode.name);
    _updateSystemUI();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await _settings.setThemeMode(_themeMode.name);
    _updateSystemUI();
    notifyListeners();
  }

  Future<void> setAmoledTheme(bool value) async {
    _isAmoled = value;
    AppColors.isAmoled = value;
    await _settings.setAmoledTheme(value);
    _updateSystemUI();
    notifyListeners();
  }

  Future<void> setAppThemeColor(Color primary, [Color? secondary]) async {
    AppColors.setAccentColor(primary, secondary);
    await _settings.setAppThemePrimary(primary.value);
    await _settings.setAppThemeSecondary(secondary?.value);
    _updateSystemUI();
    notifyListeners();
  }

  void _updateSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.getSurface(_isAmoled),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }
}
