import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class CardConfig {
  // Content
  String topic;
  String subtopic;
  String content;
  String? contentImagePath;
  Uint8List? contentImageBytes;
  List<String> hashtags;
  String? link;

  // User Profile
  String name;
  String handle;
  String? avatarPath;
  Uint8List? avatarBytes;

  // Display Toggles
  bool showDate;
  bool showTime;
  bool showLocation;
  String logoPlacement;

  // Design
  Color backgroundColor;
  Color? gradientEndColor;
  String? backgroundImagePath;
  Color textColor;
  String fontFamily;
  double fontSize;
  FontWeight fontWeight;
  FontStyle fontStyle;
  TextAlign textAlign;
  Color accentColor;

  // Border
  double borderWidth;
  Color borderColor;
  String borderStyle;

  // Shadow
  bool shadowEnabled;
  double shadowOffsetX;
  double shadowOffsetY;
  double shadowBlur;
  double shadowSpread;
  Color shadowColor;

  // Corners
  String cornerStyle;
  double cornerRadius;

  // Dimensions
  double cardWidth;
  double cardHeight;

  // Export
  List<String> exportFormats;
  int quality;

  CardConfig({
    this.topic = '',
    this.subtopic = '',
    this.content = '',
    this.contentImagePath,
    this.contentImageBytes,
    this.hashtags = const [],
    this.link,
    this.name = 'OULEC Creator',
    this.handle = '@oulegu',
    this.avatarPath,
    this.avatarBytes,
    this.showDate = true,
    this.showTime = true,
    this.showLocation = false,
    this.logoPlacement = 'Bottom Right',
    this.backgroundColor = const Color(0xFF000000),
    this.gradientEndColor,
    this.backgroundImagePath,
    this.textColor = const Color(0xFFFFFFFF),
    this.fontFamily = 'JetBrainsMono',
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.textAlign = TextAlign.left,
    this.accentColor = const Color(0xFFFFD700),
    this.borderWidth = 2,
    this.borderColor = const Color(0xFFFFD700),
    this.borderStyle = 'Solid',
    this.shadowEnabled = true,
    this.shadowOffsetX = 4,
    this.shadowOffsetY = 4,
    this.shadowBlur = 12,
    this.shadowSpread = 2,
    this.shadowColor = const Color(0x66FFD700),
    this.cornerStyle = 'Rounded',
    this.cornerRadius = 12,
    this.cardWidth = 1080,
    this.cardHeight = 1080,
    this.exportFormats = const ['PNG'],
    this.quality = 90,
  });

  CardConfig copyWith({
    String? topic,
    String? subtopic,
    String? content,
    String? contentImagePath,
    Uint8List? contentImageBytes,
    List<String>? hashtags,
    String? link,
    String? name,
    String? handle,
    String? avatarPath,
    Uint8List? avatarBytes,
    bool? showDate,
    bool? showTime,
    bool? showLocation,
    String? logoPlacement,
    Color? backgroundColor,
    Color? gradientEndColor,
    String? backgroundImagePath,
    Color? textColor,
    String? fontFamily,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    TextAlign? textAlign,
    Color? accentColor,
    double? borderWidth,
    Color? borderColor,
    String? borderStyle,
    bool? shadowEnabled,
    double? shadowOffsetX,
    double? shadowOffsetY,
    double? shadowBlur,
    double? shadowSpread,
    Color? shadowColor,
    String? cornerStyle,
    double? cornerRadius,
    double? cardWidth,
    double? cardHeight,
    List<String>? exportFormats,
    int? quality,
  }) {
    return CardConfig(
      topic: topic ?? this.topic,
      subtopic: subtopic ?? this.subtopic,
      content: content ?? this.content,
      contentImagePath: contentImagePath ?? this.contentImagePath,
      contentImageBytes: contentImageBytes ?? this.contentImageBytes,
      hashtags: hashtags ?? this.hashtags,
      link: link ?? this.link,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      avatarPath: avatarPath ?? this.avatarPath,
      avatarBytes: avatarBytes ?? this.avatarBytes,
      showDate: showDate ?? this.showDate,
      showTime: showTime ?? this.showTime,
      showLocation: showLocation ?? this.showLocation,
      logoPlacement: logoPlacement ?? this.logoPlacement,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      gradientEndColor: gradientEndColor ?? this.gradientEndColor,
      backgroundImagePath: backgroundImagePath ?? this.backgroundImagePath,
      textColor: textColor ?? this.textColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      fontStyle: fontStyle ?? this.fontStyle,
      textAlign: textAlign ?? this.textAlign,
      accentColor: accentColor ?? this.accentColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      borderStyle: borderStyle ?? this.borderStyle,
      shadowEnabled: shadowEnabled ?? this.shadowEnabled,
      shadowOffsetX: shadowOffsetX ?? this.shadowOffsetX,
      shadowOffsetY: shadowOffsetY ?? this.shadowOffsetY,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowSpread: shadowSpread ?? this.shadowSpread,
      shadowColor: shadowColor ?? this.shadowColor,
      cornerStyle: cornerStyle ?? this.cornerStyle,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      cardWidth: cardWidth ?? this.cardWidth,
      cardHeight: cardHeight ?? this.cardHeight,
      exportFormats: exportFormats ?? this.exportFormats,
      quality: quality ?? this.quality,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'subtopic': subtopic,
      'content': content,
      'contentImagePath': contentImagePath,
      'hashtags': hashtags,
      'link': link,
      'name': name,
      'handle': handle,
      'avatarPath': avatarPath,
      'showDate': showDate,
      'showTime': showTime,
      'showLocation': showLocation,
      'logoPlacement': logoPlacement,
      'backgroundColor': backgroundColor.value,
      'gradientEndColor': gradientEndColor?.value,
      'backgroundImagePath': backgroundImagePath,
      'textColor': textColor.value,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'fontWeight': fontWeight.index,
      'fontStyle': fontStyle.index,
      'textAlign': textAlign.index,
      'accentColor': accentColor.value,
      'borderWidth': borderWidth,
      'borderColor': borderColor.value,
      'borderStyle': borderStyle,
      'shadowEnabled': shadowEnabled,
      'shadowOffsetX': shadowOffsetX,
      'shadowOffsetY': shadowOffsetY,
      'shadowBlur': shadowBlur,
      'shadowSpread': shadowSpread,
      'shadowColor': shadowColor.value,
      'cornerStyle': cornerStyle,
      'cornerRadius': cornerRadius,
      'cardWidth': cardWidth,
      'cardHeight': cardHeight,
      'exportFormats': exportFormats,
      'quality': quality,
    };
  }

  factory CardConfig.fromJson(Map<String, dynamic> json) {
    return CardConfig(
      topic: json['topic'] ?? '',
      subtopic: json['subtopic'] ?? '',
      content: json['content'] ?? '',
      contentImagePath: json['contentImagePath'],
      hashtags: List<String>.from(json['hashtags'] ?? []),
      link: json['link'],
      name: json['name'] ?? 'OULEC Creator',
      handle: json['handle'] ?? '@oulegu',
      avatarPath: json['avatarPath'],
      showDate: json['showDate'] ?? true,
      showTime: json['showTime'] ?? true,
      showLocation: json['showLocation'] ?? false,
      logoPlacement: json['logoPlacement'] ?? 'Bottom Right',
      backgroundColor: Color(json['backgroundColor'] ?? 0xFF000000),
      gradientEndColor: json['gradientEndColor'] != null ? Color(json['gradientEndColor']) : null,
      backgroundImagePath: json['backgroundImagePath'],
      textColor: Color(json['textColor'] ?? 0xFFFFFFFF),
      fontFamily: json['fontFamily'] ?? 'JetBrainsMono',
      fontSize: json['fontSize'] ?? 16.0,
      fontWeight: FontWeight.values[json['fontWeight'] ?? 3],
      fontStyle: FontStyle.values[json['fontStyle'] ?? 0],
      textAlign: TextAlign.values[json['textAlign'] ?? 0],
      accentColor: Color(json['accentColor'] ?? 0xFFFFD700),
      borderWidth: json['borderWidth'] ?? 2.0,
      borderColor: Color(json['borderColor'] ?? 0xFFFFD700),
      borderStyle: json['borderStyle'] ?? 'Solid',
      shadowEnabled: json['shadowEnabled'] ?? true,
      shadowOffsetX: json['shadowOffsetX'] ?? 4.0,
      shadowOffsetY: json['shadowOffsetY'] ?? 4.0,
      shadowBlur: json['shadowBlur'] ?? 12.0,
      shadowSpread: json['shadowSpread'] ?? 2.0,
      shadowColor: Color(json['shadowColor'] ?? 0x66FFD700),
      cornerStyle: json['cornerStyle'] ?? 'Rounded',
      cornerRadius: json['cornerRadius'] ?? 12.0,
      cardWidth: json['cardWidth'] ?? 1080.0,
      cardHeight: json['cardHeight'] ?? 1080.0,
      exportFormats: List<String>.from(json['exportFormats'] ?? ['PNG']),
      quality: json['quality'] ?? 90,
    );
  }
}
