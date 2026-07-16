import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/app_state_provider.dart';
import 'services/settings_service.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final settingsService = SettingsService();
  await settingsService.init();

  final storageService = StorageService();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A0A0A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..init()),
        ChangeNotifierProvider(
          create: (_) => AppStateProvider()..init(),
        ),
        Provider<SettingsService>.value(value: settingsService),
        Provider<StorageService>.value(value: storageService),
      ],
      child: const OulecuApp(),
    ),
  );
}

class OulecuApp extends StatelessWidget {
  const OulecuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'OULECU',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.currentTheme,
          darkTheme: themeProvider.currentTheme,
          themeMode: ThemeMode.dark,
          home: const MainScreen(),
        );
      },
    );
  }
}
