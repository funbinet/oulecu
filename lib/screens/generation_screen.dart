import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/loading_animation.dart';
import '../widgets/custom_button.dart';

class GenerationScreen extends StatefulWidget {
  const GenerationScreen({super.key});

  @override
  State<GenerationScreen> createState() => _GenerationScreenState();
}

class _GenerationScreenState extends State<GenerationScreen> {
  bool _generationComplete = false;

  @override
  void initState() {
    super.initState();
    _startGeneration();
  }

  Future<void> _startGeneration() async {
    final appState = context.read<AppStateProvider>();
    await appState.generateCards();
    if (mounted) {
      setState(() {
        _generationComplete = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Generating Images'),
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
            child: Center(
              child: !_generationComplete
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HackerLoadingAnimation(
                          message: appState.loadingMessage,
                        ),
                        const SizedBox(height: 32),
                        // Progress indicator
                        Container(
                          width: 280,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: appState.progress.clamp(0.0, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primaryGold,
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.goldGlow,
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${(appState.progress * 100).toInt()}%',
                          style: TextStyle(
                            color: AppColors.primaryGold,
                            fontSize: 14,
                            fontFamily: 'JetBrainsMono',
                          ),
                        ),
                      ],
                    )
                  : _buildCompletionView(appState),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompletionView(AppStateProvider appState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Success icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.success.withOpacity(0.1),
            border: Border.all(color: AppColors.success.withOpacity(0.3), width: 2),
          ),
          child: Icon(
            Icons.check,
            size: 40,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Generation Complete!',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppColors.primaryGold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          '${appState.generatedFiles.length} image(s) generated',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 32),
        if (appState.generatedFiles.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderMuted),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GENERATED FILES',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 12),
                ...appState.generatedFiles.take(5).map((path) {
                  final fileName = path.split('/').last;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.image,
                          size: 16,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            fileName,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontFamily: 'JetBrainsMono',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              GoldButton(
                label: 'View My Content',
                onPressed: () {
                  appState.navigateToMyContent();
                },
                icon: Icons.folder_outlined,
              ),
              const SizedBox(height: 12),
              GoldButton(
                label: 'Create Another',
                onPressed: () {
                  appState.resetToHome();
                },
                isOutlined: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
