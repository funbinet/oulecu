import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  AppColors._();

  // Core Colors
  static bool isAmoled = true;

  static Color get background => isAmoled ? Color(0xFF000000) : Color(0xFF161616);
  static Color get surface => isAmoled ? Color(0xFF0A0A0A) : Color(0xFF222222);
  static Color get surfaceLight => isAmoled ? Color(0xFF141414) : Color(0xFF2A2A2A);
  
  static Color getBackground(bool isAmoled) => isAmoled ? Color(0xFF000000) : Color(0xFF161616);
  static Color getSurface(bool isAmoled) => isAmoled ? Color(0xFF0A0A0A) : Color(0xFF222222);
  static Color getSurfaceLight(bool isAmoled) => isAmoled ? Color(0xFF141414) : Color(0xFF2A2A2A);
  
  static Color primaryGold = Color(0xFFFFD700);
  static Color secondaryGold = Color(0xFFC9A800);
  static Color goldGlow = Color(0x33FFD700);
  static Color goldLight = Color(0xFFFFE44D);
  static Color goldDark = Color(0xFF998200);

  // Text Colors
  static Color textPrimary = Color(0xFFFFFFFF);
  static Color textSecondary = Color(0xFFB0B0B0);
  static Color textMuted = Color(0xFF666666);
  static Color textGold = Color(0xFFFFD700);

  // Status Colors
  static Color error = Color(0xFFFF4444);
  static Color success = Color(0xFF44FF44);
  static Color warning = Color(0xFFFFAA00);
  static Color info = Color(0xFF4499FF);

  // Border & Divider
  static Color border = Color(0xFFFFD700);
  static Color borderMuted = Color(0x33FFD700);
  static const Color divider = Color(0xFF1A1A1A);

  // Gradients
  static LinearGradient goldGradient = LinearGradient(
    colors: [primaryGold, secondaryGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient goldGradientHorizontal = LinearGradient(
    colors: [primaryGold, secondaryGold],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static LinearGradient get surfaceGradient => LinearGradient(
    colors: [surface, surfaceLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient brandGradient = LinearGradient(
    colors: [primaryGold, secondaryGold],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  
  static final List<Color> presetColors = [
    const Color(0xFFFFD700), // Gold
    const Color(0xFF6200EE), // Purple
    const Color(0xFF03DAC6), // Teal
    const Color(0xFFF44336), // Red
    const Color(0xFFE91E63), // Pink
    const Color(0xFF9C27B0), // Deep Purple
    const Color(0xFF673AB7), // Indigo
    const Color(0xFF3F51B5), // Blue
    const Color(0xFF2196F3), // Light Blue
    const Color(0xFF00BCD4), // Cyan
    const Color(0xFF009688), // Teal Dark
    const Color(0xFF4CAF50), // Green
    const Color(0xFF8BC34A), // Light Green
    const Color(0xFFCDDC39), // Lime
    const Color(0xFFFFEB3B), // Yellow
    const Color(0xFFFFC107), // Amber
    const Color(0xFFFF9800), // Orange
    const Color(0xFFFF5722), // Deep Orange
    const Color(0xFF795548), // Brown
    const Color(0xFF9E9E9E), // Grey
    const Color(0xFF607D8B), // Blue Grey
  ];

  static final List<List<Color>> presetGradients = [
    [const Color(0xFFFFD700), const Color(0xFFF39C12)], // Gold to Orange
    [const Color(0xFF6200EE), const Color(0xFFB00020)], // Purple to Red
    [const Color(0xFF2196F3), const Color(0xFF00BCD4)], // Blue to Cyan
    [const Color(0xFF4CAF50), const Color(0xFF8BC34A)], // Green to Light Green
    [const Color(0xFFE91E63), const Color(0xFFFF9800)], // Pink to Orange
    [const Color(0xFF9C27B0), const Color(0xFF3F51B5)], // Deep Purple to Indigo
    [const Color(0xFF009688), const Color(0xFF4CAF50)], // Teal to Green
    [const Color(0xFFFF5722), const Color(0xFFF44336)], // Deep Orange to Red
    [const Color(0xFF3F51B5), const Color(0xFF2196F3)], // Indigo to Blue
    [const Color(0xFFCDDC39), const Color(0xFFFFEB3B)], // Lime to Yellow
    [const Color(0xFFFFC107), const Color(0xFFFF9800)], // Amber to Orange
    [const Color(0xFF795548), const Color(0xFFFF5722)], // Brown to Deep Orange
    [const Color(0xFF607D8B), const Color(0xFF9E9E9E)], // Blue Grey to Grey
    [const Color(0xFF000000), const Color(0xFF434343)], // Black to Dark Grey
    [const Color(0xFFFFFFFF), const Color(0xFFE0E0E0)], // White to Light Grey
  ];

  static void setAccentColor(Color primary, [Color? secondary]) {
    primaryGold = primary;
    if (secondary != null) {
      secondaryGold = secondary;
      goldLight = secondary.withOpacity(0.8);
      goldDark = primary.withOpacity(0.8);
    } else {
      // Auto-calculate derivative colors based on HSL
      final hsl = HSLColor.fromColor(primary);
      secondaryGold = hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();
      goldLight = hsl.withLightness((hsl.lightness + 0.15).clamp(0.0, 1.0)).toColor();
      goldDark = hsl.withLightness((hsl.lightness - 0.25).clamp(0.0, 1.0)).toColor();
    }
    
    goldGlow = primary.withValues(alpha: 0.2);
    textGold = primary;
    border = primary;
    borderMuted = primary.withValues(alpha: 0.2);
    
    goldGradient = LinearGradient(
      colors: [primaryGold, secondaryGold],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    goldGradientHorizontal = LinearGradient(
      colors: [primaryGold, secondaryGold],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
    brandGradient = LinearGradient(
      colors: [primaryGold, secondaryGold],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  static LinearGradient get shimmerGradient => LinearGradient(
    colors: [surface, surfaceLight],
    stops: const [0.1, 0.3],
    begin: const Alignment(-1.0, -0.3),
    end: const Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData getTheme({bool isAmoled = true}) {
    final background = AppColors.getBackground(isAmoled);
    final surface = AppColors.getSurface(isAmoled);
    final surfaceLight = AppColors.getSurfaceLight(isAmoled);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryGold,
        secondary: AppColors.secondaryGold,
        surface: surface,
        background: background,
        onPrimary: background,
        onSecondary: background,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        error: AppColors.error,
      ),
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: AppColors.primaryGold,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.primaryGold,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
        iconTheme: IconThemeData(color: AppColors.primaryGold),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: surface,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: AppColors.primaryGold,
        unselectedItemColor: AppColors.textMuted,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.normal,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryGold, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryGold, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryGold, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.error, width: 2.5),
        ),
        labelStyle: TextStyle(color: AppColors.textSecondary),
        hintStyle: TextStyle(color: AppColors.textMuted),
        prefixIconColor: AppColors.primaryGold,
        suffixIconColor: AppColors.primaryGold,
      ),
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: background,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
          elevation: 4,
          shadowColor: AppColors.goldGlow,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryGold,
          side: BorderSide(color: AppColors.primaryGold, width: 1.5),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryGold,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // Cards
      cardTheme: CardThemeData(
        color: surface,
        elevation: 4,
        shadowColor: AppColors.goldGlow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.borderMuted, width: 1),
        ),
      ),
      // Dividers
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      // Switches
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryGold;
          }
          return AppColors.textMuted;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.goldGlow;
          }
          return surfaceLight;
        }),
      ),
      // Checkboxes
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryGold;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(background),
        side: BorderSide(color: AppColors.primaryGold, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      // Radio
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryGold;
          }
          return AppColors.textMuted;
        }),
      ),
      // Sliders
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primaryGold,
        inactiveTrackColor: surfaceLight,
        thumbColor: AppColors.primaryGold,
        overlayColor: AppColors.goldGlow,
        trackHeight: 4,
      ),
      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.borderMuted, width: 1),
        ),
      ),
      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceLight,
        contentTextStyle: TextStyle(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.borderMuted, width: 1),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      // Text
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
        displayMedium: TextStyle(
          color: AppColors.primaryGold,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        displaySmall: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
        headlineMedium: TextStyle(
          color: AppColors.primaryGold,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
        headlineSmall: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: AppColors.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          color: AppColors.primaryGold,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
