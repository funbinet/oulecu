import 'package:flutter/material.dart';
import '../models/template.dart';

class TemplateService {
  static final TemplateService _instance = TemplateService._internal();
  factory TemplateService() => _instance;
  TemplateService._internal();

  List<Template>? _templates;

  List<Template> getAllTemplates() {
    _templates ??= _initializeTemplates();
    return _templates!;
  }

  List<Template> getTemplatesByCategory(String category) {
    return getAllTemplates().where((t) => t.category == category).toList();
  }

  List<String> getCategories() {
    return getAllTemplates().map((t) => t.category).toSet().toList();
  }

  Template? getTemplateById(String id) {
    try {
      return getAllTemplates().firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Template> _initializeTemplates() {
    return [
      // Nature (5)
      Template(
        id: 'nature_1',
        name: 'Forest Green',
        category: 'Nature',
        backgroundColor: const Color(0xFF0B2813),
        gradientEndColor: const Color(0xFF1A4A2A),
        textColor: const Color(0xFFE8F5E9),
        accentColor: const Color(0xFF66BB6A),
        fontFamily: 'JetBrainsMono',
      ),
      Template(
        id: 'nature_2',
        name: 'Ocean Blue',
        category: 'Nature',
        backgroundColor: const Color(0xFF0A1929),
        gradientEndColor: const Color(0xFF0D3B5C),
        textColor: const Color(0xFFE3F2FD),
        accentColor: const Color(0xFF42A5F5),
        fontFamily: 'JetBrainsMono',
      ),
      Template(
        id: 'nature_3',
        name: 'Sunset Orange',
        category: 'Nature',
        backgroundColor: const Color(0xFF2D1407),
        gradientEndColor: const Color(0xFF5C2A10),
        textColor: const Color(0xFFFFF3E0),
        accentColor: const Color(0xFFFF8F00),
        fontFamily: 'JetBrainsMono',
      ),
      Template(
        id: 'nature_4',
        name: 'Desert Sand',
        category: 'Nature',
        backgroundColor: const Color(0xFF2A2318),
        gradientEndColor: const Color(0xFF4A3F2E),
        textColor: const Color(0xFFFFF8E1),
        accentColor: const Color(0xFFD4A855),
        fontFamily: 'JetBrainsMono',
      ),
      Template(
        id: 'nature_5',
        name: 'Mountain Mist',
        category: 'Nature',
        backgroundColor: const Color(0xFF1A1F2E),
        gradientEndColor: const Color(0xFF2D3548),
        textColor: const Color(0xFFECEFF1),
        accentColor: const Color(0xFF90A4AE),
        fontFamily: 'JetBrainsMono',
      ),

      // Tech (5)
      Template(
        id: 'tech_1',
        name: 'Matrix Green',
        category: 'Tech',
        backgroundColor: const Color(0xFF000000),
        gradientEndColor: const Color(0xFF001100),
        textColor: const Color(0xFF00FF00),
        accentColor: const Color(0xFF00CC00),
        fontFamily: 'JetBrainsMono',
        extraStyles: {'glowEffect': true},
      ),
      Template(
        id: 'tech_2',
        name: 'Cyber Neon',
        category: 'Tech',
        backgroundColor: const Color(0xFF0A0A1A),
        gradientEndColor: const Color(0xFF1A0A2E),
        textColor: const Color(0xFF00FFFF),
        accentColor: const Color(0xFFFF00FF),
        fontFamily: 'FiraCode',
        extraStyles: {'neonGlow': true},
      ),
      Template(
        id: 'tech_3',
        name: 'Minimal Dark',
        category: 'Tech',
        backgroundColor: const Color(0xFF111111),
        gradientEndColor: const Color(0xFF1A1A1A),
        textColor: const Color(0xFFFFFFFF),
        accentColor: const Color(0xFF888888),
        fontFamily: 'JetBrainsMono',
      ),
      Template(
        id: 'tech_4',
        name: 'Hacker Terminal',
        category: 'Tech',
        backgroundColor: const Color(0xFF000000),
        gradientEndColor: const Color(0xFF0D1117),
        textColor: const Color(0xFF33FF00),
        accentColor: const Color(0xFF33FF00),
        fontFamily: 'SourceCodePro',
        extraStyles: {'terminalCursor': true},
      ),
      Template(
        id: 'tech_5',
        name: 'Glitch Effect',
        category: 'Tech',
        backgroundColor: const Color(0xFF080808),
        gradientEndColor: const Color(0xFF120816),
        textColor: const Color(0xFFFFFFFF),
        accentColor: const Color(0xFFFF0055),
        fontFamily: 'Hack',
        extraStyles: {'glitchEffect': true},
      ),

      // Finance (4)
      Template(
        id: 'finance_1',
        name: 'Corporate Blue',
        category: 'Finance',
        backgroundColor: const Color(0xFF0A1628),
        gradientEndColor: const Color(0xFF0F2240),
        textColor: const Color(0xFFE3F2FD),
        accentColor: const Color(0xFF1976D2),
        fontFamily: 'JetBrainsMono',
      ),
      Template(
        id: 'finance_2',
        name: 'Luxury Gold',
        category: 'Finance',
        backgroundColor: const Color(0xFF0A0A00),
        gradientEndColor: const Color(0xFF1A1A05),
        textColor: const Color(0xFFFFFDE7),
        accentColor: const Color(0xFFFFD700),
        fontFamily: 'JetBrainsMono',
      ),
      Template(
        id: 'finance_3',
        name: 'Minimal White',
        category: 'Finance',
        backgroundColor: const Color(0xFFF5F5F5),
        gradientEndColor: const Color(0xFFFFFFFF),
        textColor: const Color(0xFF212121),
        accentColor: const Color(0xFF424242),
        fontFamily: 'JetBrainsMono',
      ),
      Template(
        id: 'finance_4',
        name: 'Dark Executive',
        category: 'Finance',
        backgroundColor: const Color(0xFF0D0D0D),
        gradientEndColor: const Color(0xFF1A1A1A),
        textColor: const Color(0xFFD4AF37),
        accentColor: const Color(0xFFD4AF37),
        fontFamily: 'UbuntuMono',
      ),

      // Creative (4)
      Template(
        id: 'creative_1',
        name: 'Watercolor',
        category: 'Creative',
        backgroundColor: const Color(0xFF1A1025),
        gradientEndColor: const Color(0xFF2D1B4E),
        textColor: const Color(0xFFF3E5F5),
        accentColor: const Color(0xFFAB47BC),
        fontFamily: 'JetBrainsMono',
      ),
      Template(
        id: 'creative_2',
        name: 'Ink Splash',
        category: 'Creative',
        backgroundColor: const Color(0xFF0A0A0A),
        gradientEndColor: const Color(0xFF151515),
        textColor: const Color(0xFFFFFFFF),
        accentColor: const Color(0xFF333333),
        fontFamily: 'Hack',
      ),
      Template(
        id: 'creative_3',
        name: 'Geometric',
        category: 'Creative',
        backgroundColor: const Color(0xFF121220),
        gradientEndColor: const Color(0xFF1E1E3A),
        textColor: const Color(0xFFE8EAF6),
        accentColor: const Color(0xFF5C6BC0),
        fontFamily: 'FiraCode',
      ),
      Template(
        id: 'creative_4',
        name: 'Abstract Gradient',
        category: 'Creative',
        backgroundColor: const Color(0xFF1A0A2E),
        gradientEndColor: const Color(0xFF0E2A47),
        textColor: const Color(0xFFFCE4EC),
        accentColor: const Color(0xFFEC407A),
        fontFamily: 'SourceCodePro',
      ),

      // Bible (3)
      Template(
        id: 'bible_1',
        name: 'Ancient Parchment',
        category: 'Bible',
        backgroundColor: const Color(0xFF2A2318),
        gradientEndColor: const Color(0xFF3A3220),
        textColor: const Color(0xFFFFF8E1),
        accentColor: const Color(0xFF8D6E63),
        fontFamily: 'UbuntuMono',
      ),
      Template(
        id: 'bible_2',
        name: 'Divine Light',
        category: 'Bible',
        backgroundColor: const Color(0xFF0D1B2A),
        gradientEndColor: const Color(0xFF1B2838),
        textColor: const Color(0xFFFFFDE7),
        accentColor: const Color(0xFFFFD54F),
        fontFamily: 'JetBrainsMono',
      ),
      Template(
        id: 'bible_3',
        name: 'Cross Minimal',
        category: 'Bible',
        backgroundColor: const Color(0xFF0A0A0A),
        gradientEndColor: const Color(0xFF111111),
        textColor: const Color(0xFFFFFFFF),
        accentColor: const Color(0xFFB0B0B0),
        fontFamily: 'Hack',
      ),

      // Luxury (3)
      Template(
        id: 'luxury_1',
        name: 'Gold Foil',
        category: 'Luxury',
        backgroundColor: const Color(0xFF0A0900),
        gradientEndColor: const Color(0xFF1A1605),
        textColor: const Color(0xFFFFF8E1),
        accentColor: const Color(0xFFD4AF37),
        fontFamily: 'JetBrainsMono',
      ),
      Template(
        id: 'luxury_2',
        name: 'Marble',
        category: 'Luxury',
        backgroundColor: const Color(0xFF1A1A1E),
        gradientEndColor: const Color(0xFF2A2A30),
        textColor: const Color(0xFFF5F5F5),
        accentColor: const Color(0xFFB0B0B0),
        fontFamily: 'FiraCode',
      ),
      Template(
        id: 'luxury_3',
        name: 'Velvet Dark',
        category: 'Luxury',
        backgroundColor: const Color(0xFF0D0612),
        gradientEndColor: const Color(0xFF1A0D24),
        textColor: const Color(0xFFF3E5F5),
        accentColor: const Color(0xFF7B1FA2),
        fontFamily: 'SourceCodePro',
      ),

      // Academic (3)
      Template(
        id: 'academic_1',
        name: 'Old Paper',
        category: 'Academic',
        backgroundColor: const Color(0xFF2A2518),
        gradientEndColor: const Color(0xFF3A3522),
        textColor: const Color(0xFFFFF8E1),
        accentColor: const Color(0xFFA1887F),
        fontFamily: 'UbuntuMono',
      ),
      Template(
        id: 'academic_2',
        name: 'Chalkboard',
        category: 'Academic',
        backgroundColor: const Color(0xFF1B5E20),
        gradientEndColor: const Color(0xFF2E7D32),
        textColor: const Color(0xFFFFFFFF),
        accentColor: const Color(0xFFFFFFFF),
        fontFamily: 'Hack',
      ),
      Template(
        id: 'academic_3',
        name: 'Modern Scholar',
        category: 'Academic',
        backgroundColor: const Color(0xFF0D1117),
        gradientEndColor: const Color(0xFF161B22),
        textColor: const Color(0xFFC9D1D9),
        accentColor: const Color(0xFF58A6FF),
        fontFamily: 'JetBrainsMono',
      ),

      // Other (3)
      Template(
        id: 'other_1',
        name: 'Neon Glow',
        category: 'Other',
        backgroundColor: const Color(0xFF050510),
        gradientEndColor: const Color(0xFF0A0A24),
        textColor: const Color(0xFF00FF88),
        accentColor: const Color(0xFF00FF88),
        fontFamily: 'FiraCode',
        extraStyles: {'neonGlow': true},
      ),
      Template(
        id: 'other_2',
        name: 'Glassmorphism',
        category: 'Other',
        backgroundColor: const Color(0xFF0A0A0A).withOpacity(0.8),
        gradientEndColor: const Color(0xFF1A1A2E).withOpacity(0.6),
        textColor: const Color(0xFFFFFFFF),
        accentColor: const Color(0x88FFFFFF),
        fontFamily: 'JetBrainsMono',
      ),
      Template(
        id: 'other_3',
        name: 'Retro Vintage',
        category: 'Other',
        backgroundColor: const Color(0xFF2D1F1F),
        gradientEndColor: const Color(0xFF3E2C2C),
        textColor: const Color(0xFFFFECB3),
        accentColor: const Color(0xFFFF6F00),
        fontFamily: 'UbuntuMono',
      ),
    ];
  }
}
