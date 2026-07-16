import 'package:flutter/material.dart';

class Template {
  final String id;
  final String name;
  final String category;
  final String? thumbnailPath;
  final Color backgroundColor;
  final Color? gradientEndColor;
  final Color textColor;
  final Color accentColor;
  final String? backgroundImagePath;
  final String fontFamily;
  final Map<String, dynamic>? extraStyles;
  bool isSelected;

  Template({
    required this.id,
    required this.name,
    required this.category,
    this.thumbnailPath,
    required this.backgroundColor,
    this.gradientEndColor,
    required this.textColor,
    required this.accentColor,
    this.backgroundImagePath,
    this.fontFamily = 'JetBrainsMono',
    this.extraStyles,
    this.isSelected = false,
  });

  Template copyWith({
    String? id,
    String? name,
    String? category,
    String? thumbnailPath,
    Color? backgroundColor,
    Color? gradientEndColor,
    Color? textColor,
    Color? accentColor,
    String? backgroundImagePath,
    String? fontFamily,
    Map<String, dynamic>? extraStyles,
    bool? isSelected,
  }) {
    return Template(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      gradientEndColor: gradientEndColor ?? this.gradientEndColor,
      textColor: textColor ?? this.textColor,
      accentColor: accentColor ?? this.accentColor,
      backgroundImagePath: backgroundImagePath ?? this.backgroundImagePath,
      fontFamily: fontFamily ?? this.fontFamily,
      extraStyles: extraStyles ?? this.extraStyles,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'thumbnailPath': thumbnailPath,
      'backgroundColor': backgroundColor.value,
      'gradientEndColor': gradientEndColor?.value,
      'textColor': textColor.value,
      'accentColor': accentColor.value,
      'backgroundImagePath': backgroundImagePath,
      'fontFamily': fontFamily,
      'extraStyles': extraStyles,
      'isSelected': isSelected,
    };
  }

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      thumbnailPath: json['thumbnailPath'],
      backgroundColor: Color(json['backgroundColor'] ?? 0xFF000000),
      gradientEndColor: json['gradientEndColor'] != null ? Color(json['gradientEndColor']) : null,
      textColor: Color(json['textColor'] ?? 0xFFFFFFFF),
      accentColor: Color(json['accentColor'] ?? 0xFFFFD700),
      backgroundImagePath: json['backgroundImagePath'],
      fontFamily: json['fontFamily'] ?? 'JetBrainsMono',
      extraStyles: json['extraStyles'],
      isSelected: json['isSelected'] ?? false,
    );
  }
}
