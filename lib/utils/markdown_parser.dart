import 'package:flutter/material.dart';

class MarkdownParser {
  static TextSpan parse(
    String text,
    TextStyle baseStyle, {
    FontWeight boldWeight = FontWeight.bold,
    FontStyle italicStyle = FontStyle.italic,
  }) {
    final List<TextSpan> spans = [];
    int i = 0;

    bool isBold = false;
    bool isItalic = false;

    int chunkStart = 0;

    void addSpan(int end) {
      if (end > chunkStart) {
        spans.add(TextSpan(
          text: text.substring(chunkStart, end),
          style: baseStyle.copyWith(
            fontWeight: isBold ? boldWeight : baseStyle.fontWeight,
            fontStyle: isItalic ? italicStyle : baseStyle.fontStyle,
          ),
        ));
      }
    }

    while (i < text.length) {
      if (text.startsWith('**', i)) {
        addSpan(i);
        isBold = !isBold;
        i += 2;
        chunkStart = i;
      } else if (text.startsWith('*', i)) {
        addSpan(i);
        isItalic = !isItalic;
        i += 1;
        chunkStart = i;
      } else {
        i++;
      }
    }

    addSpan(text.length);

    return TextSpan(children: spans);
  }
}
