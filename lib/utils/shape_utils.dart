import 'package:flutter/material.dart';
import 'dart:math';

class ShapeUtils {
  static Path getCardShape(String style, double radius, Rect rect) {
    final path = Path();
    
    switch (style) {
      case 'None':
        path.addRect(rect);
        break;
      case 'Rounded':
        path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
        break;
      case 'Beveled':
        path.moveTo(rect.left + radius, rect.top);
        path.lineTo(rect.right - radius, rect.top);
        path.lineTo(rect.right, rect.top + radius);
        path.lineTo(rect.right, rect.bottom - radius);
        path.lineTo(rect.right - radius, rect.bottom);
        path.lineTo(rect.left + radius, rect.bottom);
        path.lineTo(rect.left, rect.bottom - radius);
        path.lineTo(rect.left, rect.top + radius);
        path.close();
        break;
      case 'Ticket':
        path.moveTo(rect.left + radius, rect.top);
        path.lineTo(rect.right - radius, rect.top);
        path.arcToPoint(Offset(rect.right, rect.top + radius), radius: Radius.circular(radius), clockwise: false);
        path.lineTo(rect.right, rect.bottom - radius);
        path.arcToPoint(Offset(rect.right - radius, rect.bottom), radius: Radius.circular(radius), clockwise: false);
        path.lineTo(rect.left + radius, rect.bottom);
        path.arcToPoint(Offset(rect.left, rect.bottom - radius), radius: Radius.circular(radius), clockwise: false);
        path.lineTo(rect.left, rect.top + radius);
        path.arcToPoint(Offset(rect.left + radius, rect.top), radius: Radius.circular(radius), clockwise: false);
        path.close();
        break;
      case 'Cutout':
        path.addRect(rect);
        path.addOval(Rect.fromCircle(center: rect.topLeft, radius: radius));
        path.addOval(Rect.fromCircle(center: rect.topRight, radius: radius));
        path.addOval(Rect.fromCircle(center: rect.bottomLeft, radius: radius));
        path.addOval(Rect.fromCircle(center: rect.bottomRight, radius: radius));
        path.fillType = PathFillType.evenOdd;
        break;
      case 'Notched':
        path.moveTo(rect.left + radius, rect.top);
        path.lineTo(rect.right - radius, rect.top);
        path.lineTo(rect.right - radius, rect.top + radius);
        path.lineTo(rect.right, rect.top + radius);
        path.lineTo(rect.right, rect.bottom - radius);
        path.lineTo(rect.right - radius, rect.bottom - radius);
        path.lineTo(rect.right - radius, rect.bottom);
        path.lineTo(rect.left + radius, rect.bottom);
        path.lineTo(rect.left + radius, rect.bottom - radius);
        path.lineTo(rect.left, rect.bottom - radius);
        path.lineTo(rect.left, rect.top + radius);
        path.lineTo(rect.left + radius, rect.top + radius);
        path.close();
        break;
      case 'Scalloped':
        path.moveTo(rect.left + radius, rect.top);
        for(double i = rect.left + radius; i < rect.right - radius; i += radius * 2) {
          path.arcToPoint(Offset(min(i + radius * 2, rect.right - radius), rect.top), radius: Radius.circular(radius), clockwise: true);
        }
        path.lineTo(rect.right, rect.top + radius);
        for(double i = rect.top + radius; i < rect.bottom - radius; i += radius * 2) {
          path.arcToPoint(Offset(rect.right, min(i + radius * 2, rect.bottom - radius)), radius: Radius.circular(radius), clockwise: true);
        }
        path.lineTo(rect.right - radius, rect.bottom);
        for(double i = rect.right - radius; i > rect.left + radius; i -= radius * 2) {
          path.arcToPoint(Offset(max(i - radius * 2, rect.left + radius), rect.bottom), radius: Radius.circular(radius), clockwise: true);
        }
        path.lineTo(rect.left, rect.bottom - radius);
        for(double i = rect.bottom - radius; i > rect.top + radius; i -= radius * 2) {
          path.arcToPoint(Offset(rect.left, max(i - radius * 2, rect.top + radius)), radius: Radius.circular(radius), clockwise: true);
        }
        path.close();
        break;
      case 'Inverted':
        path.moveTo(rect.left + radius, rect.top);
        path.lineTo(rect.right - radius, rect.top);
        path.arcToPoint(Offset(rect.right, rect.top + radius), radius: Radius.circular(radius), clockwise: true);
        path.lineTo(rect.right, rect.bottom - radius);
        path.arcToPoint(Offset(rect.right - radius, rect.bottom), radius: Radius.circular(radius), clockwise: true);
        path.lineTo(rect.left + radius, rect.bottom);
        path.arcToPoint(Offset(rect.left, rect.bottom - radius), radius: Radius.circular(radius), clockwise: true);
        path.lineTo(rect.left, rect.top + radius);
        path.arcToPoint(Offset(rect.left + radius, rect.top), radius: Radius.circular(radius), clockwise: true);
        path.close();
        break;
      case 'Zigzag':
        path.moveTo(rect.left, rect.top);
        for(double i = rect.left; i < rect.right; i += radius) {
          path.lineTo(i + radius/2, rect.top + radius/2);
          path.lineTo(min(i + radius, rect.right), rect.top);
        }
        for(double i = rect.top; i < rect.bottom; i += radius) {
          path.lineTo(rect.right - radius/2, i + radius/2);
          path.lineTo(rect.right, min(i + radius, rect.bottom));
        }
        for(double i = rect.right; i > rect.left; i -= radius) {
          path.lineTo(i - radius/2, rect.bottom - radius/2);
          path.lineTo(max(i - radius, rect.left), rect.bottom);
        }
        for(double i = rect.bottom; i > rect.top; i -= radius) {
          path.lineTo(rect.left + radius/2, i - radius/2);
          path.lineTo(rect.left, max(i - radius, rect.top));
        }
        path.close();
        break;
      case 'Hexagon':
        final double h = radius;
        path.moveTo(rect.left + h, rect.top);
        path.lineTo(rect.right - h, rect.top);
        path.lineTo(rect.right, rect.top + rect.height/2);
        path.lineTo(rect.right - h, rect.bottom);
        path.lineTo(rect.left + h, rect.bottom);
        path.lineTo(rect.left, rect.top + rect.height/2);
        path.close();
        break;
      case 'Octagon':
        final double o = radius * 2;
        path.moveTo(rect.left + o, rect.top);
        path.lineTo(rect.right - o, rect.top);
        path.lineTo(rect.right, rect.top + o);
        path.lineTo(rect.right, rect.bottom - o);
        path.lineTo(rect.right - o, rect.bottom);
        path.lineTo(rect.left + o, rect.bottom);
        path.lineTo(rect.left, rect.bottom - o);
        path.lineTo(rect.left, rect.top + o);
        path.close();
        break;
      case 'Leaf':
        path.moveTo(rect.left, rect.top);
        path.lineTo(rect.right - radius*2, rect.top);
        path.arcToPoint(Offset(rect.right, rect.top + radius*2), radius: Radius.circular(radius*2), clockwise: true);
        path.lineTo(rect.right, rect.bottom);
        path.lineTo(rect.left + radius*2, rect.bottom);
        path.arcToPoint(Offset(rect.left, rect.bottom - radius*2), radius: Radius.circular(radius*2), clockwise: true);
        path.close();
        break;
      case 'Torn':
        path.moveTo(rect.left, rect.top);
        path.lineTo(rect.right, rect.top);
        path.lineTo(rect.right, rect.bottom);
        for(double i = rect.right; i > rect.left; i -= radius) {
           path.lineTo(i - radius/2, rect.bottom - (Random(i.toInt()).nextDouble() * radius));
           path.lineTo(max(i - radius, rect.left), rect.bottom);
        }
        path.lineTo(rect.left, rect.top);
        path.close();
        break;
      case 'Folded':
        path.moveTo(rect.left, rect.top);
        path.lineTo(rect.right - radius * 2, rect.top);
        path.lineTo(rect.right, rect.top + radius * 2);
        path.lineTo(rect.right, rect.bottom);
        path.lineTo(rect.left, rect.bottom);
        path.close();
        break;
      case 'Wave':
        path.moveTo(rect.left, rect.top);
        path.lineTo(rect.right, rect.top);
        path.lineTo(rect.right, rect.bottom);
        for(double i = rect.right; i > rect.left; i -= radius * 2) {
          path.quadraticBezierTo(i - radius, rect.bottom - radius, max(i - radius * 2, rect.left), rect.bottom);
        }
        path.lineTo(rect.left, rect.top);
        path.close();
        break;
      case 'Bite':
        path.addRect(rect);
        path.addOval(Rect.fromCircle(center: Offset(rect.left, rect.top + rect.height/2), radius: radius * 1.5));
        path.addOval(Rect.fromCircle(center: Offset(rect.right, rect.top + rect.height/2), radius: radius * 1.5));
        path.fillType = PathFillType.evenOdd;
        break;
      default:
        path.addRect(rect);
    }
    return path;
  }
}

class CardShapeClipper extends CustomClipper<Path> {
  final String style;
  final double radius;

  CardShapeClipper(this.style, this.radius);

  @override
  Path getClip(Size size) {
    return ShapeUtils.getCardShape(style, radius, Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  bool shouldReclip(CardShapeClipper oldClipper) => oldClipper.style != style || oldClipper.radius != radius;
}

class CardShapeBorder extends OutlinedBorder {
  final String style;
  final double radius;
  final BorderSide borderSide;

  const CardShapeBorder({
    required this.style,
    required this.radius,
    this.borderSide = BorderSide.none,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(borderSide.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return ShapeUtils.getCardShape(style, radius, rect.deflate(borderSide.width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return ShapeUtils.getCardShape(style, radius, rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (borderSide.style != BorderStyle.none) {
      final paint = borderSide.toPaint();
      canvas.drawPath(getOuterPath(rect), paint);
    }
  }

  @override
  ShapeBorder scale(double t) {
    return CardShapeBorder(
      style: style,
      radius: radius * t,
      borderSide: borderSide.scale(t),
    );
  }

  @override
  OutlinedBorder copyWith({BorderSide? side}) {
    return CardShapeBorder(
      style: style,
      radius: radius,
      borderSide: side ?? borderSide,
    );
  }
}
