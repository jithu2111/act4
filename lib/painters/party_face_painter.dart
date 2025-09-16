// lib/painters/party_face_painter.dart
// PartyFacePainter - polished version
// Implemented by Partner B: <PartnerB Name> (GitHub: <partnerB-username>)
// Minor polish: const constructors, helper extraction, gradient tweaks.

import 'package:flutter/material.dart';
import 'dart:math';

class PartyFacePainter extends CustomPainter {
  final double scale;
  final bool showConfetti;

  /// [scale] adjusts the overall size of the drawing (1.0 = normal).
  /// [showConfetti] toggles confetti rendering.
  const PartyFacePainter({this.scale = 1.0, this.showConfetti = true});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final faceRadius = min(size.width, size.height) * 0.35 * scale;
    final center = Offset(cx, cy);

    // Face radial gradient (slightly warmer)
    final faceRect = Rect.fromCircle(center: center, radius: faceRadius);
    final facePaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.yellow.shade300, Colors.orange.shade300],
        center: const Alignment(-0.15, -0.15),
        radius: 0.9,
      ).createShader(faceRect);
    canvas.drawCircle(center, faceRadius, facePaint);

    // Eyes
    final eyePaint = Paint()..color = Colors.brown.shade900;
    final eyeRadius = faceRadius * 0.12;
    final eyeOffsetX = faceRadius * 0.45;
    final eyeOffsetY = faceRadius * -0.15;
    canvas.drawCircle(Offset(cx - eyeOffsetX, cy + eyeOffsetY), eyeRadius, eyePaint);
    canvas.drawCircle(Offset(cx + eyeOffsetX, cy + eyeOffsetY), eyeRadius, eyePaint);

    // Smile (arc)
    final mouthRect = Rect.fromCircle(
      center: Offset(cx, cy + faceRadius * 0.15),
      radius: faceRadius * 0.6,
    );
    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = faceRadius * 0.11
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(mouthRect, pi * 0.15, pi * 0.7, false, mouthPaint);

    // Party hat (triangle) with improved gradient
    final hatTop = Offset(cx, cy - faceRadius * 1.55);
    final hatLeft = Offset(cx - faceRadius * 0.65, cy - faceRadius * 0.85);
    final hatRight = Offset(cx + faceRadius * 0.65, cy - faceRadius * 0.85);
    final hatPath = Path()..moveTo(hatLeft.dx, hatLeft.dy);
    hatPath.lineTo(hatRight.dx, hatRight.dy);
    hatPath.lineTo(hatTop.dx, hatTop.dy);
    hatPath.close();
    final hatRect = Rect.fromPoints(hatLeft, hatRight).inflate(faceRadius * 0.35);
    final hatPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.deepPurple, Colors.redAccent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(hatRect);
    canvas.drawPath(hatPath, hatPaint);

    // pompom on hat
    canvas.drawCircle(Offset(hatTop.dx, hatTop.dy + faceRadius * 0.06), faceRadius * 0.092, Paint()..color = Colors.white);

    // Confetti (draw via helper)
    if (showConfetti) {
      _drawConfetti(canvas, center, faceRadius);
    }

    // cheek blush (softer)
    final blushPaint = Paint()..color = Colors.pink.withOpacity(0.22);
    canvas.drawCircle(Offset(cx - faceRadius * 0.55, cy + faceRadius * 0.1), faceRadius * 0.17, blushPaint);
    canvas.drawCircle(Offset(cx + faceRadius * 0.55, cy + faceRadius * 0.1), faceRadius * 0.17, blushPaint);
  }

  // Helper: draw confetti shapes around the hat area for visual flair.
  void _drawConfetti(Canvas canvas, Offset center, double faceRadius) {
    final cx = center.dx;
    final cy = center.dy;
    final confettiColors = [Colors.blue, Colors.pink, Colors.green, Colors.orange, Colors.indigo];
    final confettiCenters = <Offset>[
      Offset(cx - faceRadius * 1.05, cy - faceRadius * 0.95),
      Offset(cx - faceRadius * 0.55, cy - faceRadius * 1.22),
      Offset(cx - faceRadius * 0.03, cy - faceRadius * 1.36),
      Offset(cx + faceRadius * 0.45, cy - faceRadius * 1.16),
      Offset(cx + faceRadius * 0.95, cy - faceRadius * 0.88),
    ];

    for (var i = 0; i < confettiCenters.length; i++) {
      final c = confettiColors[i % confettiColors.length];
      final p = confettiCenters[i];
      final w = faceRadius * 0.12;
      final h = faceRadius * 0.06;
      final paint = Paint()..color = c;
      // slight rotation for rectangles
      if (i % 2 == 0) {
        final rect = Rect.fromCenter(center: p, width: w, height: h);
        canvas.save();
        canvas.translate(p.dx, p.dy);
        canvas.rotate((i - 2) * 0.25);
        canvas.translate(-p.dx, -p.dy);
        canvas.drawRect(rect, paint);
        canvas.restore();
      } else {
        canvas.drawCircle(p, faceRadius * 0.055, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PartyFacePainter oldDelegate) {
    return oldDelegate.scale != scale || oldDelegate.showConfetti != showConfetti;
  }
}
