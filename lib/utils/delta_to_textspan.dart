import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart' as quill_delta;

TextSpan convertDeltaToTextSpan(String jsonString, TextStyle baseStyle) {
  if (jsonString.isEmpty) {
    return TextSpan(text: '', style: baseStyle);
  }

  try {
    final List<dynamic> operations = jsonDecode(jsonString);
    final delta = quill_delta.Delta.fromJson(operations);
    
    List<TextSpan> spans = [];
    
    for (var op in delta.toList()) {
      if (op.isInsert) {
        String text = op.data is String ? op.data as String : '';
        if (text.isEmpty) continue;
        
        TextStyle style = baseStyle;
        if (op.attributes != null) {
          if (op.attributes!['bold'] == true) {
            style = style.copyWith(fontWeight: FontWeight.bold);
          }
          if (op.attributes!['italic'] == true) {
            style = style.copyWith(fontStyle: FontStyle.italic);
          }
          if (op.attributes!['underline'] == true) {
            style = style.copyWith(decoration: TextDecoration.underline);
          }
          if (op.attributes!['strike'] == true) {
            style = style.copyWith(decoration: TextDecoration.lineThrough);
          }
          if (op.attributes!['color'] != null) {
            // Assume color is hex string like #RRGGBB
            String colorStr = op.attributes!['color'].toString();
            if (colorStr.startsWith('#')) {
              style = style.copyWith(
                color: Color(int.parse(colorStr.substring(1), radix: 16) + 0xFF000000),
              );
            }
          }
        }
        spans.add(TextSpan(text: text, style: style));
      }
    }
    
    return TextSpan(children: spans, style: baseStyle);
  } catch (e) {
    return TextSpan(text: 'Error parsing rich text', style: baseStyle);
  }
}
