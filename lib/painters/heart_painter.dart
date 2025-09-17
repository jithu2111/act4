import 'package:flutter/material.dart';
import 'dart:math';

class HeartPainter extends CustomPainter {
  final double scale;

  const HeartPainter({this.scale = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final base = min(size.width, size.height) * 0.5 * scale;
    
    // Add pulsing animation
    final now = DateTime.now().millisecondsSinceEpoch / 1000.0;
    final pulse = sin(now * 3) * 0.03 + 1.0; // Subtle pulse between 0.97 and 1.03
    final animatedBase = base * pulse;

    // Create heart path with smoother curves
    final path = Path();
    path.moveTo(cx, cy + animatedBase * 0.7);

    // Left curve with better control points
    path.cubicTo(
      cx + animatedBase * 1.6, cy - animatedBase * 0.6,
      cx + animatedBase * 0.8, cy - animatedBase * 1.3,
      cx, cy - animatedBase * 0.5
    );

    // Right curve with better control points
    path.cubicTo(
      cx - animatedBase * 0.8, cy - animatedBase * 1.3,
      cx - animatedBase * 1.6, cy - animatedBase * 0.6,
      cx, cy + animatedBase * 0.7
    );
    path.close();

    // Draw shadow
    final shadowPath = Path.from(path);
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(shadowPath..shift(const Offset(0, 4)), shadowPaint);

    // Draw outline with gradient
    final outlinePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withOpacity(0.8),
          Colors.white.withOpacity(0.4),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(path.getBounds())
      ..style = PaintingStyle.stroke
      ..strokeWidth = animatedBase * 0.08
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, outlinePaint);

    // Draw main fill with multiple gradients
    // Base gradient with vibrant colors
    final mainPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFF3366), // Vibrant pink
          const Color(0xFFFF0844), // Strong pink-red
          const Color(0xFFFF0527), // Deep red
          const Color(0xFFD70026), // Rich dark red
        ],
        stops: const [0.0, 0.4, 0.7, 1.0],
        center: const Alignment(-0.3, -0.5),
        radius: 1.4,
        focal: const Alignment(-0.4, -0.3),
        focalRadius: 0.1,
      ).createShader(path.getBounds())
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, mainPaint);

    // Add depth gradient
    final depthPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFF99AA).withOpacity(0.6), // Light pink
          const Color(0xFFFF3366).withOpacity(0.3), // Mid pink
          const Color(0xFF800020).withOpacity(0.4), // Deep burgundy
        ],
        stops: const [0.0, 0.5, 1.0],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(path.getBounds());
    canvas.drawPath(path, depthPaint);

    // Add metallic sheen
    final sheenPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.white.withOpacity(0.0),
          Colors.white.withOpacity(0.3),
          Colors.white.withOpacity(0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
        center: const Alignment(-0.3, -0.3),
        startAngle: 0,
        endAngle: pi * 2,
      ).createShader(path.getBounds());
    canvas.drawPath(path, sheenPaint);

    // Add highlight with better curve
    final highlightPath = Path();
    highlightPath.moveTo(cx - animatedBase * 0.6, cy - animatedBase * 0.7);
    highlightPath.quadraticBezierTo(
      cx - animatedBase * 0.1, cy - animatedBase * 0.9,
      cx + animatedBase * 0.4, cy - animatedBase * 0.5
    );
    highlightPath.quadraticBezierTo(
      cx + animatedBase * 0.1, cy - animatedBase * 0.2,
      cx - animatedBase * 0.6, cy - animatedBase * 0.7
    );

    final highlightPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withOpacity(0.8),
          Colors.white.withOpacity(0.0),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(highlightPath.getBounds());
    canvas.drawPath(highlightPath, highlightPaint);

    // Add sparkle effects
    final sparkleRand = Random((now * 1000).toInt());
    for (int i = 0; i < 3; i++) {
      if (sparkleRand.nextDouble() < 0.7) {
        final angle = sparkleRand.nextDouble() * pi * 2;
        final distance = animatedBase * (0.3 + sparkleRand.nextDouble() * 0.3);
        final sparklePos = Offset(
          cx + cos(angle) * distance,
          cy + sin(angle) * distance - animatedBase * 0.2,
        );
        
        final sparklePaint = Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.white.withOpacity(0.8),
              Colors.white.withOpacity(0.0),
            ],
          ).createShader(Rect.fromCircle(
            center: sparklePos,
            radius: animatedBase * 0.08,
          ));
        canvas.drawCircle(sparklePos, animatedBase * 0.08, sparklePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant HeartPainter oldDelegate) {
    // Always repaint to ensure smooth animations
    return true;
  }
}