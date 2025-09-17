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


    final path = Path();
    path.moveTo(cx, cy + base * 0.7);


    path.cubicTo(
        cx + base * 1.5, cy - base * 0.5,
        cx + base * 0.7, cy - base * 1.2,
        cx, cy - base * 0.4
    );

    path.cubicTo(
        cx - base * 0.7, cy - base * 1.2,
        cx - base * 1.5, cy - base * 0.5,
        cx, cy + base * 0.7
    );
    path.close();


    final outlinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = base * 0.1
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, outlinePaint);


    final fillPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.red.shade400,
          Colors.red.shade800,
        ],
        center: const Alignment(-0.3, -0.5),
        radius: 1.2,
      ).createShader(path.getBounds())
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);



    final highlightPath = Path();
    highlightPath.moveTo(cx - base * 0.55, cy - base * 0.7);
    highlightPath.quadraticBezierTo(
        cx - base * 0.1, cy - base * 0.9,
        cx + base * 0.35, cy - base * 0.5
    );
    highlightPath.quadraticBezierTo(
        cx + base * 0.1, cy - base * 0.2,
        cx - base * 0.55, cy - base * 0.7
    );

    final highlightPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.9),
          Colors.white.withValues(alpha: 0.1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(highlightPath.getBounds());
    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant HeartPainter oldDelegate) {
    return oldDelegate.scale != scale;
  }
}