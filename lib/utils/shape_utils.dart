import 'dart:ui';
import 'package:flutter/material.dart';

Path getCornerPath(Rect rect, String style, double radius) {
  final path = Path();
  final w = rect.width;
  final h = rect.height;
  final l = rect.left;
  final t = rect.top;
  final r = rect.right;
  final b = rect.bottom;

  // Ensure radius is not larger than half the smallest side
  final safeRadius = radius.clamp(0.0, (w > h ? h : w) / 2);

  switch (style) {
    case 'Rounded':
      return Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(safeRadius)));
    case 'Beveled':
      path.moveTo(l + safeRadius, t);
      path.lineTo(r - safeRadius, t);
      path.lineTo(r, t + safeRadius);
      path.lineTo(r, b - safeRadius);
      path.lineTo(r - safeRadius, b);
      path.lineTo(l + safeRadius, b);
      path.lineTo(l, b - safeRadius);
      path.lineTo(l, t + safeRadius);
      path.close();
      return path;
    case 'Inverted':
      // Cut out inverted corners
      path.moveTo(l, t + safeRadius);
      path.arcToPoint(Offset(l + safeRadius, t), radius: Radius.circular(safeRadius), clockwise: false);
      path.lineTo(r - safeRadius, t);
      path.arcToPoint(Offset(r, t + safeRadius), radius: Radius.circular(safeRadius), clockwise: false);
      path.lineTo(r, b - safeRadius);
      path.arcToPoint(Offset(r - safeRadius, b), radius: Radius.circular(safeRadius), clockwise: false);
      path.lineTo(l + safeRadius, b);
      path.arcToPoint(Offset(l, b - safeRadius), radius: Radius.circular(safeRadius), clockwise: false);
      path.close();
      return path;
    case 'Scalloped':
      // Wavy corners (simplified)
      path.moveTo(l, t + safeRadius);
      path.quadraticBezierTo(l + safeRadius/2, t + safeRadius/2, l + safeRadius, t);
      path.lineTo(r - safeRadius, t);
      path.quadraticBezierTo(r - safeRadius/2, t + safeRadius/2, r, t + safeRadius);
      path.lineTo(r, b - safeRadius);
      path.quadraticBezierTo(r - safeRadius/2, b - safeRadius/2, r - safeRadius, b);
      path.lineTo(l + safeRadius, b);
      path.quadraticBezierTo(l + safeRadius/2, b - safeRadius/2, l, b - safeRadius);
      path.close();
      return path;
    case 'None':
    default:
      return Path()..addRect(rect);
  }
}

ShapeBorder getShapeBorder(String style, double radius, BorderSide side) {
  final safeRadius = radius.clamp(0.0, 100.0);
  switch (style) {
    case 'Rounded':
      return RoundedRectangleBorder(borderRadius: BorderRadius.circular(safeRadius), side: side);
    case 'Beveled':
      return BeveledRectangleBorder(borderRadius: BorderRadius.circular(safeRadius), side: side);
    default:
      return RoundedRectangleBorder(borderRadius: BorderRadius.circular(style == 'None' ? 0 : safeRadius), side: side);
  }
}
