import 'package:flutter/material.dart';
import 'dart:math';

class HeartPainter extends CustomPainter {
  final double scale;

  const HeartPainter({this.scale = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final base = min(size.width, size.height) * 0.6 * scale;

    final path = Path();

    path.moveTo(cx, cy + base * 0.25);


    path.cubicTo(
      cx + base * 0.6, cy - base * 0.35,
      cx + base * 0.95, cy + base * 0.15,
      cx, cy + base * 0.6,
    );


    path.cubicTo(
      cx - base * 0.95, cy + base * 0.15,
      cx - base * 0.6, cy - base * 0.35,
      cx, cy + base * 0.25,
    );
    path.close();

    final bounds = Rect.fromCenter(center: Offset(cx, cy), width: base, height: base);
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.pink.shade200, Colors.red.shade700],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 0.95],
      ).createShader(bounds)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);


    final highlight = Paint()..color = Colors.white.withValues(alpha: 0.12);
    final highlightPath = Path()
      ..moveTo(cx, cy - base * 0.05)
      ..cubicTo(cx + base * 0.18, cy - base * 0.18, cx + base * 0.45, cy - base * 0.05, cx + base * 0.15, cy + base * 0.05)
      ..close();
    canvas.drawPath(highlightPath, highlight);
  }

  @override
  bool shouldRepaint(covariant HeartPainter oldDelegate) {
    return oldDelegate.scale != scale;
  }
}