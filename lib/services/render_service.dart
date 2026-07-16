import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import '../models/card_config.dart';
import '../models/template.dart';
import '../utils/shape_utils.dart';
import '../utils/markdown_parser.dart';
import '../utils/shape_utils.dart';

import 'storage_service.dart';

class RenderService {
  static final RenderService _instance = RenderService._internal();
  factory RenderService() => _instance;
  RenderService._internal();

  final StorageService _storage = StorageService();

  // Cached logo image
  ui.Image? _cachedLogo;

  Future<ui.Image?> _loadLogo() async {
    if (_cachedLogo != null) return _cachedLogo;
    try {
      final data = await rootBundle.load('assets/images/logo.png');
      final bytes = data.buffer.asUint8List();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      _cachedLogo = frame.image;
      return _cachedLogo;
    } catch (e) {
      debugPrint('Error loading logo: $e');
      return null;
    }
  }

  Future<List<String>> renderCards(
    CardConfig config,
    List<Template> templates,
    List<String> formats,
  ) async {
    final List<String> generatedFiles = [];

    for (int i = 0; i < templates.length; i++) {
      final template = templates[i];
      for (final format in formats) {
        try {
          final bytes = await _renderCardImage(config, template);
          if (bytes != null) {
            final fileName = 'oulecu_${template.id}_${DateTime.now().millisecondsSinceEpoch}.$format'.toLowerCase();
            final filePath = await _storage.saveImage(bytes, fileName);
            generatedFiles.add(filePath);
          }
        } catch (e) {
          debugPrint('Error rendering card: $e');
        }
      }
    }

    return generatedFiles;
  }

  Future<Uint8List?> _renderCardImage(CardConfig config, Template template) async {
    final width = config.cardWidth.toInt();
    final height = config.cardHeight.toInt();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // === OUTER CARD: Template background ===
    _drawOuterBackground(canvas, config, template, width, height);

    // === INNER CONTENT BOX: Substack-style card ===
    await _drawInnerContentBox(canvas, config, template, width, height);

    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) return null;

    final pngBytes = byteData.buffer.asUint8List();
    return _convertFormat(pngBytes, config);
  }

  void _drawOuterBackground(Canvas canvas, CardConfig config, Template template, int width, int height) {
    final rect = Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());

    // Use template background (gradient or solid)
    if (template.gradientEndColor != null) {
      final gradient = LinearGradient(
        colors: [template.backgroundColor, template.gradientEndColor!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.fill;
      canvas.drawRect(rect, paint);
    } else {
      final paint = Paint()
        ..color = template.backgroundColor
        ..style = PaintingStyle.fill;
      canvas.drawRect(rect, paint);
    }
  }

  Future<void> _drawInnerContentBox(Canvas canvas, CardConfig config, Template template, int width, int height) async {
    final double cardW = width.toDouble();
    final double cardH = height.toDouble();

    // Content box sizing
    final double boxPaddingH = cardW * 0.08; // Horizontal margin from card edges
    final double boxWidth = cardW - (boxPaddingH * 2);
    final double innerPadding = boxWidth * 0.06; // Padding inside the content box

    // Available width for content inside the box
    final double contentWidth = boxWidth - (innerPadding * 2);

    // === MEASURE ALL CONTENT HEIGHT FIRST ===
    double totalContentHeight = innerPadding; // Top padding

    // 1. Avatar + Name row
    final double avatarSize = 48.0;
    final double nameRowHeight = avatarSize;
    totalContentHeight += nameRowHeight;
    totalContentHeight += innerPadding * 0.6; // Spacing after name row

    // 2. Topic
    TextPainter? topicPainter;
    if (config.topic.isNotEmpty) {
      topicPainter = TextPainter(
        text: TextSpan(
          text: config.topic.toUpperCase(),
          style: TextStyle(
            color: config.accentColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: config.fontFamily,
            letterSpacing: 1.5,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      topicPainter.layout(maxWidth: contentWidth);
      totalContentHeight += topicPainter.height + 8;
    }

    // 3. Subtopic
    TextPainter? subtopicPainter;
    if (config.subtopic.isNotEmpty) {
      subtopicPainter = TextPainter(
        text: TextSpan(
          text: config.subtopic,
          style: TextStyle(
            color: template.textColor.withOpacity(0.7),
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontFamily: config.fontFamily,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      subtopicPainter.layout(maxWidth: contentWidth);
      totalContentHeight += subtopicPainter.height + 12;
    }

    // 4. Content text
    TextPainter? contentPainter;
    if (config.content.isNotEmpty) {
      final baseStyle = TextStyle(
        color: template.textColor,
        fontSize: config.fontSize,
        fontWeight: config.fontWeight,
        fontStyle: config.fontStyle,
        fontFamily: config.fontFamily,
        height: 1.5,
      );

      TextSpan textSpan = MarkdownParser.parse(config.content, baseStyle);

      contentPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: config.textAlign,
      );
      contentPainter.layout(maxWidth: contentWidth);
      totalContentHeight += contentPainter.height + 16;
    }

    // 5. Content image
    ui.Image? contentImage;
    double contentImageHeight = 0;
    if (config.contentImageBytes != null) {
      try {
        final codec = await ui.instantiateImageCodec(config.contentImageBytes!);
        final frame = await codec.getNextFrame();
        contentImage = frame.image;
        // Scale image to fit content width, cap height
        contentImageHeight = (contentWidth * contentImage.height / contentImage.width).clamp(100.0, cardH * 0.4);
        totalContentHeight += contentImageHeight + 16;
      } catch (_) {}
    }

    // 6. Hashtags
    double hashtagRowHeight = 0;
    if (config.hashtags.isNotEmpty) {
      hashtagRowHeight = 32; // approximate single row
      // Check for wrapping
      double currentX = 0;
      for (final tag in config.hashtags) {
        final tp = TextPainter(
          text: TextSpan(text: ' #$tag ', style: TextStyle(fontSize: 13, fontFamily: config.fontFamily)),
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        if (currentX + tp.width + 8 > contentWidth) {
          hashtagRowHeight += 36;
          currentX = 0;
        }
        currentX += tp.width + 8;
      }
      totalContentHeight += hashtagRowHeight + 12;
    }

    // 7. Link
    if (config.link != null && config.link!.isNotEmpty) {
      totalContentHeight += 24;
    }

    // 8. Separator + footer (date + logo)
    totalContentHeight += 4; // spacing before separator
    totalContentHeight += 1; // separator line
    totalContentHeight += 12; // spacing after separator
    totalContentHeight += 20; // footer row height

    totalContentHeight += innerPadding; // Bottom padding

    // === CALCULATE BOX POSITION (centered vertically) ===
    final double boxHeight = totalContentHeight.clamp(200.0, cardH * 0.92);
    final double boxX = boxPaddingH;
    final double boxY = (cardH - boxHeight) / 2;

    // === DRAW THE CONTENT BOX ===
    final rawRect = Rect.fromLTWH(boxX, boxY, boxWidth, boxHeight);
    final boxPath = ShapeUtils.getCardShape(config.cornerStyle, config.cornerRadius, rawRect);

    final boxBgColor = _getContentBoxColor(template);

    // Shadow for content box
    if (config.shadowEnabled) {
      final shadowPaint = Paint()
        ..color = template.accentColor.withOpacity(0.4)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, config.shadowBlur);
      
      canvas.save();
      canvas.translate(config.shadowOffsetX, config.shadowOffsetY);
      // To simulate spread, we could scale, but a simple offset + blur is what we do here
      canvas.drawPath(boxPath, shadowPaint);
      canvas.restore();
    }

    // Box background
    final boxPaint = Paint()
      ..color = boxBgColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(boxPath, boxPaint);

    // Box border
    final borderPaint = Paint()
      ..color = template.accentColor.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.borderWidth > 0 ? config.borderWidth : 2.0;
    canvas.drawPath(boxPath, borderPaint);

    // === DRAW CONTENT INSIDE THE BOX ===
    double currentY = boxY + innerPadding;
    final double contentX = boxX + innerPadding;

    // Determine text colors for content box based on box brightness
    final bool isDarkBox = boxBgColor.computeLuminance() < 0.5;
    final Color contentTextColor = isDarkBox ? template.textColor : const Color(0xFF1A1A1A);
    final Color contentSubtleColor = isDarkBox ? template.textColor.withOpacity(0.5) : const Color(0xFF999999);
    final Color contentAccentColor = template.accentColor;

    // 1. Avatar + Name row + Logo icon (top-right)
    await _drawAvatarNameRow(canvas, config, contentX, currentY, contentWidth, avatarSize, contentTextColor, contentAccentColor);
    currentY += nameRowHeight + innerPadding * 0.6;

    // 2. Topic
    if (topicPainter != null) {
      final topicStyle = TextStyle(
        color: contentAccentColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: config.fontFamily,
        letterSpacing: 1.5,
      );
      final tp = TextPainter(
        text: TextSpan(text: config.topic.toUpperCase(), style: topicStyle),
        textDirection: TextDirection.ltr,
      );
      tp.layout(maxWidth: contentWidth);
      tp.paint(canvas, Offset(contentX, currentY));
      currentY += tp.height + 8;
    }

    // 3. Subtopic
    if (subtopicPainter != null) {
      final sp = TextPainter(
        text: TextSpan(
          text: config.subtopic,
          style: TextStyle(
            color: contentSubtleColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontFamily: config.fontFamily,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      sp.layout(maxWidth: contentWidth);
      sp.paint(canvas, Offset(contentX, currentY));
      currentY += sp.height + 12;
    }

    // 4. Content text
    if (contentPainter != null) {
      final baseStyle = TextStyle(
        color: contentTextColor,
        fontSize: config.fontSize,
        fontWeight: config.fontWeight,
        fontStyle: config.fontStyle,
        fontFamily: config.fontFamily,
        height: 1.5,
      );

      TextSpan textSpan = MarkdownParser.parse(config.content, baseStyle);

      final cp = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: config.textAlign,
      );
      cp.layout(maxWidth: contentWidth);
      cp.paint(canvas, Offset(contentX, currentY));
      currentY += cp.height + 16;
    }

    // 5. Content image
    if (contentImage != null) {
      final imageRect = Rect.fromLTWH(contentX, currentY, contentWidth, contentImageHeight);

      // Clip to rounded rect for the image
      canvas.save();
      canvas.clipRRect(RRect.fromRectAndRadius(imageRect, const Radius.circular(8)));

      final imagePaint = Paint()
        ..isAntiAlias = true
        ..filterQuality = FilterQuality.high;

      canvas.drawImageRect(
        contentImage,
        Rect.fromLTWH(0, 0, contentImage.width.toDouble(), contentImage.height.toDouble()),
        imageRect,
        imagePaint,
      );
      canvas.restore();
      currentY += contentImageHeight + 16;
    }

    // 6. Hashtags
    if (config.hashtags.isNotEmpty) {
      _drawHashtagsInBox(canvas, config, contentX, currentY, contentWidth, contentAccentColor);
      currentY += hashtagRowHeight + 12;
    }

    // 7. Link
    if (config.link != null && config.link!.isNotEmpty) {
      final displayLink = config.link!.replaceAll(RegExp(r'^https?://'), '');
      final lp = TextPainter(
        text: TextSpan(
          text: displayLink,
          style: TextStyle(
            color: contentAccentColor.withOpacity(0.7),
            fontSize: 12,
            fontFamily: config.fontFamily,
            decoration: TextDecoration.underline,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      lp.layout(maxWidth: contentWidth);
      lp.paint(canvas, Offset(contentX, currentY));
      currentY += 24;
    }

    // 8. Separator line
    currentY += 4;
    final separatorPaint = Paint()
      ..color = contentSubtleColor.withOpacity(0.2)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(contentX, currentY),
      Offset(contentX + contentWidth, currentY),
      separatorPaint,
    );
    currentY += 1 + 12;

    // 9. Footer: Date/Time (left)
    await _drawFooter(canvas, config, contentX, currentY, contentWidth, contentSubtleColor);

    // 10. Logo
    final logo = await _loadLogo();
    if (logo != null) {
      final logoSize = 28.0;
      double logoX = boxX + innerPadding;
      double logoY = boxY + innerPadding;

      if (config.logoPlacement.contains('Right')) {
        logoX = boxX + boxWidth - innerPadding - logoSize;
      }
      if (config.logoPlacement.contains('Bottom')) {
        logoY = boxY + boxHeight - innerPadding - logoSize;
      }

      // Draw tinted logo
      canvas.drawImageRect(
        logo,
        Rect.fromLTWH(0, 0, logo.width.toDouble(), logo.height.toDouble()),
        Rect.fromLTWH(logoX, logoY, logoSize, logoSize),
        Paint()..colorFilter = ColorFilter.mode(template.accentColor, BlendMode.srcIn)..filterQuality = FilterQuality.high,
      );
    }
  }

  /// Determine the content box background color based on the template
  Color _getContentBoxColor(Template template) {
    return template.backgroundColor;
  }

  Future<void> _drawAvatarNameRow(Canvas canvas, CardConfig config, double x, double y, double contentWidth, double avatarSize, Color textColor, Color accentColor) async {
    // Draw avatar
    final avatarCenter = Offset(x + avatarSize / 2, y + avatarSize / 2);
    final avatarRadius = avatarSize / 2;

    if (config.avatarBytes != null) {
      try {
        final codec = await ui.instantiateImageCodec(config.avatarBytes!);
        final frame = await codec.getNextFrame();
        final image = frame.image;

        // Save state before clipping
        canvas.save();

        // Clip to circle
        final clipPath = Path()..addOval(Rect.fromCircle(center: avatarCenter, radius: avatarRadius));
        canvas.clipPath(clipPath);

        // Draw avatar image
        final avatarRect = Rect.fromCircle(center: avatarCenter, radius: avatarRadius);
        final srcSize = min(image.width, image.height).toDouble();
        final srcX = (image.width - srcSize) / 2;
        final srcY = (image.height - srcSize) / 2;

        canvas.drawImageRect(
          image,
          Rect.fromLTWH(srcX, srcY, srcSize, srcSize),
          avatarRect,
          Paint()..filterQuality = FilterQuality.high,
        );

        // Restore after clipping
        canvas.restore();

        // Border
        final borderPaint = Paint()
          ..color = accentColor.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        canvas.drawCircle(avatarCenter, avatarRadius, borderPaint);
      } catch (_) {
        _drawDefaultAvatarCircle(canvas, avatarCenter, avatarRadius, accentColor);
      }
    } else {
      _drawDefaultAvatarCircle(canvas, avatarCenter, avatarRadius, accentColor);
    }

    // Draw name
    final nameX = x + avatarSize + 12;
    final nameMaxWidth = contentWidth - avatarSize - 12 - 48; // Reserve space for logo

    final namePainter = TextPainter(
      text: TextSpan(
        text: config.name,
        style: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: config.fontFamily,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    namePainter.layout(maxWidth: nameMaxWidth);
    namePainter.paint(canvas, Offset(nameX, y + 4));

    // Draw handle
    final handlePainter = TextPainter(
      text: TextSpan(
        text: config.handle,
        style: TextStyle(
          color: accentColor.withOpacity(0.7),
          fontSize: 13,
          fontFamily: config.fontFamily,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    handlePainter.layout(maxWidth: nameMaxWidth);
    handlePainter.paint(canvas, Offset(nameX, y + 26));

    // (Logo drawing removed from here, moved to main layout step)
  }

  void _drawDefaultAvatarCircle(Canvas canvas, Offset center, double radius, Color accentColor) {
    final bgPaint = Paint()
      ..color = accentColor.withOpacity(0.15)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    final borderPaint = Paint()
      ..color = accentColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, borderPaint);

    // Person icon
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.person.codePoint),
        style: TextStyle(
          fontFamily: Icons.person.fontFamily,
          package: Icons.person.fontPackage,
          fontSize: radius,
          color: accentColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    iconPainter.paint(
      canvas,
      Offset(center.dx - iconPainter.width / 2, center.dy - iconPainter.height / 2),
    );
  }

  void _drawHashtagsInBox(Canvas canvas, CardConfig config, double x, double y, double maxWidth, Color accentColor) {
    double currentX = x;
    double currentY = y;
    const tagHeight = 28.0;
    const tagSpacing = 6.0;

    for (final tag in config.hashtags) {
      final tagText = '#$tag';
      final tp = TextPainter(
        text: TextSpan(
          text: ' $tagText ',
          style: TextStyle(
            color: accentColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            fontFamily: config.fontFamily,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();

      if (currentX + tp.width + tagSpacing > x + maxWidth) {
        currentX = x;
        currentY += tagHeight + tagSpacing;
      }

      // Tag background pill
      final tagRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(currentX, currentY, tp.width, tagHeight),
        const Radius.circular(14),
      );

      canvas.drawRRect(tagRect, Paint()..color = accentColor.withOpacity(0.1));
      canvas.drawRRect(tagRect, Paint()
        ..color = accentColor.withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1);

      tp.paint(canvas, Offset(currentX, currentY + (tagHeight - tp.height) / 2));
      currentX += tp.width + tagSpacing;
    }
  }

  Future<void> _drawFooter(Canvas canvas, CardConfig config, double x, double y, double contentWidth, Color subtleColor) async {
    // Date/Time on left
    final now = DateTime.now();
    final parts = <String>[];
    if (config.showDate) {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      parts.add('${months[now.month - 1]} ${now.day.toString().padLeft(2, '0')}, ${now.year}');
    }
    if (config.showTime) {
      parts.add('${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}');
    }

    if (parts.isNotEmpty) {
      final datePainter = TextPainter(
        text: TextSpan(
          text: parts.join('  '),
          style: TextStyle(
            color: subtleColor,
            fontSize: 13,
            fontFamily: config.fontFamily,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      datePainter.layout();
      datePainter.paint(canvas, Offset(x, y));
    }

    // (OULECU logo drawing removed from footer, now handles dynamically)
  }

  Future<Uint8List?> _convertFormat(Uint8List pngBytes, CardConfig config) async {
    if (config.exportFormats.isEmpty) return pngBytes;

    final format = config.exportFormats.first.toLowerCase();
    if (format == 'png') return pngBytes;

    try {
      final image = img.decodePng(pngBytes);
      if (image == null) return pngBytes;

      final quality = config.quality;

      switch (format) {
        case 'jpg':
        case 'jpeg':
          return Uint8List.fromList(img.encodeJpg(image, quality: quality));
        case 'webp':
          return Uint8List.fromList(img.encodePng(image));
        default:
          return pngBytes;
      }
    } catch (e) {
      debugPrint('Format conversion error: $e');
      return pngBytes;
    }
  }

  Future<Uint8List?> renderPreview(CardConfig config, Template template, {double scale = 0.3}) async {
    final previewConfig = config.copyWith(
      cardWidth: config.cardWidth * scale,
      cardHeight: config.cardHeight * scale,
      fontSize: config.fontSize * scale,
    );

    return _renderCardImage(previewConfig, template);
  }
}
