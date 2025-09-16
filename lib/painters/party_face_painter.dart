// lib/painters/party_face_painter.dart
// PartyFacePainter
import 'package:flutter/material.dart';
import 'dart:math';

class PartyFacePainter extends CustomPainter {
  final double scale;
  final bool showConfetti;

  PartyFacePainter({this.scale = 1.0, this.showConfetti = true});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final faceRadius = min(size.width, size.height) * 0.35 * scale;
    final center = Offset(cx, cy);

    // Face with radial gradient
    final faceRect = Rect.fromCircle(center: center, radius: faceRadius);
    final facePaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.yellow.shade300, Colors.orange.shade200],
        center: Alignment(-0.2, -0.2),
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
      ..strokeWidth = faceRadius * 0.12
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(mouthRect, pi * 0.15, pi * 0.7, false, mouthPaint);

    // Party hat (triangle)
    final hatTop = Offset(cx, cy - faceRadius * 1.55);
    final hatLeft = Offset(cx - faceRadius * 0.65, cy - faceRadius * 0.85);
    final hatRight = Offset(cx + faceRadius * 0.65, cy - faceRadius * 0.85);
    final hatPath = Path()..moveTo(hatLeft.dx, hatLeft.dy);
    hatPath.lineTo(hatRight.dx, hatRight.dy);
    hatPath.lineTo(hatTop.dx, hatTop.dy);
    hatPath.close();
    final hatRect = Rect.fromPoints(hatLeft, hatRight).inflate(faceRadius * 0.4);
    final hatPaint = Paint()
      ..shader = LinearGradient(colors: [Colors.red, Colors.deepPurple]).createShader(hatRect);
    canvas.drawPath(hatPath, hatPaint);

    // pompom on hat
    canvas.drawCircle(Offset(hatTop.dx, hatTop.dy + faceRadius * 0.06), faceRadius * 0.10, Paint()..color = Colors.white);

    // Confetti - placeholder simple shapes
    if (showConfetti) {
      final confettiColors = [Colors.blue, Colors.pink, Colors.green, Colors.orange, Colors.indigo];
      final confettiCenters = <Offset>[
        Offset(cx - faceRadius * 1.1, cy - faceRadius * 0.9),
        Offset(cx - faceRadius * 0.6, cy - faceRadius * 1.2),
        Offset(cx - faceRadius * 0.05, cy - faceRadius * 1.35),
        Offset(cx + faceRadius * 0.4, cy - faceRadius * 1.2),
        Offset(cx + faceRadius * 0.95, cy - faceRadius * 0.9),
      ];
      for (var i = 0; i < confettiCenters.length; i++) {
        final c = confettiColors[i % confettiColors.length];
        final p = confettiCenters[i];
        final rect = Rect.fromCenter(center: p, width: faceRadius * 0.14, height: faceRadius * 0.08);
        final paint = Paint()..color = c;
        if (i % 2 == 0) {
          canvas.drawRect(rect, paint);
        } else {
          canvas.drawCircle(p, faceRadius * 0.06, paint);
        }
      }
    }

    // cheek blush
    final blushPaint = Paint()..color = Colors.pink.withOpacity(0.25);
    canvas.drawCircle(Offset(cx - faceRadius * 0.55, cy + faceRadius * 0.1), faceRadius * 0.18, blushPaint);
    canvas.drawCircle(Offset(cx + faceRadius * 0.55, cy + faceRadius * 0.1), faceRadius * 0.18, blushPaint);
  }

  @override
  bool shouldRepaint(covariant PartyFacePainter oldDelegate) {
    return oldDelegate.scale != scale || oldDelegate.showConfetti != showConfetti;
  }
}
