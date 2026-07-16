import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import 'home_screen.dart';
import 'content_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import 'hashtag_screen.dart';
import 'edit_screen.dart';
import 'design_screen.dart';
import 'template_screen.dart';
import 'preview_screen.dart';
import 'generation_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentTab = 0;

  final List<Widget> _tabs = [
    const HomeScreen(),
    const ContentScreen(),
    const SettingsScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Register tab switching callback in provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = context.read<AppStateProvider>();
      appState.onNavigateToMyContent = () {
        setState(() {
          _currentTab = 1; // Switch to "My Content" tab
        });
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        // If in creation flow, show the appropriate screen
        if (appState.currentStep != CreationStep.home) {
          return PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              if (didPop) return;
              appState.goBack();
            },
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: _buildCreationScreen(appState),
            ),
          );
        }

        // Normal tab view
        return Scaffold(
          backgroundColor: AppColors.background,
          body: IndexedStack(
            index: _currentTab,
            children: _tabs,
          ),
          bottomNavigationBar: BottomNav(
            currentIndex: _currentTab,
            onTap: (index) {
              setState(() {
                _currentTab = index;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildCreationScreen(AppStateProvider appState) {
    switch (appState.currentStep) {
      case CreationStep.home:
        return const HomeScreen();
      case CreationStep.hashtag:
        return const HashtagScreen();
      case CreationStep.edit:
        return const EditScreen();
      case CreationStep.design:
        return const DesignScreen();
      case CreationStep.template:
        return const TemplateScreen();
      case CreationStep.preview:
        return const PreviewScreen();
      case CreationStep.generating:
        return const GenerationScreen();
      case CreationStep.export:
        // Return to home after export
        WidgetsBinding.instance.addPostFrameCallback((_) {
          appState.setStep(CreationStep.home);
        });
        return const HomeScreen();
    }
  }
}
