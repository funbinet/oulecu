import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HackerLoadingAnimation extends StatefulWidget {
  final String message;

  const HackerLoadingAnimation({
    super.key,
    this.message = 'Processing...',
  });

  @override
  State<HackerLoadingAnimation> createState() => _HackerLoadingAnimationState();
}

class _HackerLoadingAnimationState extends State<HackerLoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Matrix rain effect
        SizedBox(
          width: 120,
          height: 80,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _MatrixRainPainter(
                  progress: _controller.value,
                  color: AppColors.primaryGold,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        // Title
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Opacity(
              opacity: 0.5 + (_pulseController.value * 0.5),
              child: Text(
                'Creating Magic',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.primaryGold,
                      fontFamily: 'JetBrainsMono',
                      letterSpacing: 3,
                    ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        // Message
        Text(
          widget.message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontFamily: 'JetBrainsMono',
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        // Progress bar
        SizedBox(
          width: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              backgroundColor: AppColors.surfaceLight,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
              minHeight: 4,
            ),
          ),
        ),
      ],
    );
  }
}

class _MatrixRainPainter extends CustomPainter {
  final double progress;
  final Color color;

  _MatrixRainPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;

    final columns = (size.width / 8).floor();

    for (int i = 0; i < columns; i++) {
      final x = i * 8.0 + 4;
      final speed = 0.3 + random.nextDouble() * 0.7;
      final length = 3 + random.nextInt(8);
      final startY = ((progress * speed * size.height * 2) % (size.height + length * 12)) - length * 12;

      for (int j = 0; j < length; j++) {
        final y = startY + j * 12;
        if (y >= 0 && y <= size.height) {
          final opacity = j == 0 ? 1.0 : 0.3 + (1 - j / length) * 0.5;
          final charPaint = Paint()
            ..color = color.withOpacity(opacity)
            ..strokeWidth = 1.5;

          canvas.drawCircle(Offset(x, y), 1.5, charPaint);
        }
      }
    }

    // Center icon
    final centerPaint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw hexagon
    final hexPath = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * pi / 180;
      final px = centerX + 18 * cos(angle);
      final py = centerY + 18 * sin(angle);
      if (i == 0) {
        hexPath.moveTo(px, py);
      } else {
        hexPath.lineTo(px, py);
      }
    }
    hexPath.close();
    canvas.drawPath(hexPath, centerPaint);

    // Inner dot
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
