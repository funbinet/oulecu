import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'OULECU';
  static const String appVersion = 'v2.7.0';
  static const String creatorName = 'OULEC';
  static const String creatorEmail = 'funbinet@gmail.com';
  static const String githubUrl = 'https://github.com/funbinet/oulecu';
  static const String codebergUrl = 'https://codeberg.org/funbinet/oulecu';

  // Storage Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyAppName = 'app_name';
  static const String keyAppIconIndex = 'app_icon_index';
  static const String keyUserName = 'user_name';
  static const String keyUserHandle = 'user_handle';
  static const String keyUserAvatar = 'user_avatar';
  static const String keyHashtags = 'hashtags';
  static const String keyDefaultFormat = 'default_format';
  static const String keyExportQuality = 'export_quality';
  static const String keySaveLocation = 'save_location';
  static const String keyDefaultFont = 'default_font';
  static const String keyDefaultFontSize = 'default_font_size';
  static const String keyDefaultTextColor = 'default_text_color';
  static const String keyDefaultBgColor = 'default_bg_color';
  static const String keyDefaultAccentColor = 'default_accent_color';
  static const String keyDefaultBorderWidth = 'default_border_width';
  static const String keyDefaultBorderColor = 'default_border_color';
  static const String keyDefaultBorderStyle = 'default_border_style';
  static const String keyDefaultShadowEnabled = 'default_shadow_enabled';
  static const String keyDefaultCornerStyle = 'default_corner_style';
  static const String keyDefaultCardWidth = 'default_card_width';
  static const String keyDefaultCardHeight = 'default_card_height';
  static const String keyAppThemePrimary = 'app_theme_primary';
  static const String keyAppThemeSecondary = 'app_theme_secondary';
  static const String keyShowDate = 'show_date';
  static const String keyShowTime = 'show_time';
  static const String keyShowLocation = 'show_location';
  static const String keyLogoPlacement = 'logo_placement';
  static const String keyPresets = 'presets';
  static const String keyCardsGenerated = 'cards_generated';
  static const String keyTagsUsed = 'tags_used';
  static const String keyDaysActive = 'days_active';
  static const String keyFirstOpenDate = 'first_open_date';

  // Defaults
  static const String defaultAppName = 'OULECU';
  static const String defaultUserName = 'Oulec';
  static const String defaultUserHandle = 'oulec';
  static const String defaultFont = 'JetBrainsMono';
  static const double defaultFontSize = 16.0;
  static const String defaultFormat = 'PNG';
  static const int defaultQuality = 90;
  static const int maxHashtags = 10;
  static const int maxHashtagStorage = 50;
  static const double defaultCardWidth = 1080;
  static const double defaultCardHeight = 1080;

  // Preloaded Hashtags
  static const List<String> defaultHashtags = [
    'tech', 'coding', 'ai', 'design', 'startup',
    'web', 'mobile', 'app', 'dev', 'cyber', 'security',
    'flutter', 'dart', 'ui', 'ux', 'frontend',
    'backend', 'fullstack', 'programming', 'software',
    'opensource', 'developer', 'engineer', 'cloud',
    'data', 'machinelearning', 'iot', 'blockchain',
    'api', 'database', 'server', 'client', 'framework',
    'git', 'github', 'debug', 'deploy', 'testing',
    'agile', 'scrum', 'product', 'innovation', 'creative',
    'digital', 'future', 'learning', 'tutorial', 'tips',
  ];

  // Fonts
  static const List<String> availableFonts = [
    'JetBrainsMono',
    'FiraCode',
    'SourceCodePro',
    'Hack',
    'UbuntuMono',
    'Courier New',
    'Inconsolata',
  ];

  // Icon Options
  static const List<String> iconOptions = [
    'assets/icons/icon1.png',
    'assets/icons/icon2.png',
    'assets/icons/icon3.png',
    'assets/icons/icon4.png',
    'assets/icons/icon5.png',
  ];

  // Export Formats
  static const List<String> exportFormats = ['PNG', 'JPG', 'JPEG', 'WebP'];

  // Corner Styles
  static const List<String> cornerStyles = [
    'None', 'Rounded', 'Beveled', 'Ticket', 'Cutout',
    'Notched', 'Scalloped', 'Inverted', 'Zigzag', 'Hexagon',
    'Octagon', 'Leaf', 'Torn', 'Folded', 'Wave',
  ];

  // Logo Placements
  static const List<String> logoPlacements = [
    'Top Left', 'Top Right', 'Bottom Left', 'Bottom Right',
  ];

  // Template Categories
  static const Map<String, List<String>> templateCategories = {
    'Nature': ['Forest Green', 'Ocean Blue', 'Sunset Orange', 'Desert Sand', 'Mountain Mist'],
    'Tech': ['Matrix Green', 'Cyber Neon', 'Minimal Dark', 'Hacker Terminal', 'Glitch Effect'],
    'Finance': ['Corporate Blue', 'Luxury Gold', 'Minimal White', 'Dark Executive'],
    'Creative': ['Watercolor', 'Ink Splash', 'Geometric', 'Abstract Gradient'],
    'Bible': ['Ancient Parchment', 'Divine Light', 'Cross Minimal'],
    'Luxury': ['Gold Foil', 'Marble', 'Velvet Dark'],
    'Academic': ['Old Paper', 'Chalkboard', 'Modern Scholar'],
    'Other': ['Neon Glow', 'Glassmorphism', 'Retro Vintage'],
  };

  // Motivational Messages
  static const List<String> generationMessages = [
    'Crafting your perfect cards...',
    'This won\'t take long...',
    'Adding the final touches...',
    'Rendering with precision...',
    'Almost there...',
    'Creating magic...',
    'Polishing the gold...',
    'Encrypting excellence...',
  ];
}
