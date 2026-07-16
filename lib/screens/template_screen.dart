import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../services/template_service.dart';
import '../theme/app_theme.dart';
import '../widgets/template_card.dart';
import '../widgets/custom_button.dart';

class TemplateScreen extends StatefulWidget {
  const TemplateScreen({super.key});

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  final TemplateService _templateService = TemplateService();
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final allTemplates = _templateService.getAllTemplates();
        final categories = ['All', ..._templateService.getCategories()];
        final filteredTemplates = _selectedCategory == 'All'
            ? allTemplates
            : _templateService.getTemplatesByCategory(_selectedCategory);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => appState.goBack(),
            ),
            title: const Text('Choose Templates'),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Category filter
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return TemplateCategoryChip(
                        label: category,
                        isSelected: _selectedCategory == category,
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      );
                    },
                  ),
                ),
                // Selection info
                if (appState.selectedTemplates.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: AppColors.primaryGold.withOpacity(0.05),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColors.primaryGold,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${appState.selectedTemplates.length} template(s) selected',
                          style: TextStyle(
                            color: AppColors.primaryGold,
                            fontSize: 12,
                            fontFamily: 'JetBrainsMono',
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            appState.setSelectedTemplates([]);
                          },
                          child: const Text(
                            'CLEAR',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Template grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredTemplates.length,
                    itemBuilder: (context, index) {
                      final template = filteredTemplates[index];
                      final isSelected = appState.selectedTemplates.any((t) => t.id == template.id);
                      return TemplateCard(
                        template: template,
                        isSelected: isSelected,
                        onTap: () => appState.toggleTemplate(template),
                      );
                    },
                  ),
                ),
                // Bottom actions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: const Border(top: BorderSide(color: AppColors.borderMuted)),
                  ),
                  child: ActionButtons(
                    onBack: () => appState.goBack(),
                    onNext: appState.selectedTemplates.isNotEmpty
                        ? () => appState.goNext()
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select at least one template'),
                              ),
                            );
                          },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
