import 'package:flutter/material.dart';
import 'dart:math';

class PartyFacePainter extends CustomPainter {
  final double scale;
  final bool showConfetti;

  const PartyFacePainter({this.scale = 1.0, this.showConfetti = true});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final faceRadius = min(size.width, size.height) * 0.35 * scale;
    final center = Offset(cx, cy);

    final faceRect = Rect.fromCircle(center: center, radius: faceRadius);
    final facePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFFE082), // Lighter Yellow
          const Color(0xFFFFC107), // Mid Yellow
          const Color(0xFFE65100), // Dark Orange/Brown shadow
        ],
        stops: const [0.0, 0.7, 1.0],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(faceRect);
    canvas.drawCircle(center, faceRadius, facePaint);


    _drawEyesAndBrows(canvas, center, faceRadius);

    final mouthCenter = Offset(cx + faceRadius * 0.1, cy + faceRadius * 0.25);
    final mouthPaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawArc(
      Rect.fromCenter(
          center: mouthCenter,
          width: faceRadius * 0.25,
          height: faceRadius * 0.25),
      pi * 0.1,
      pi * 0.8,
      false,
      mouthPaint..style = PaintingStyle.stroke..strokeWidth = faceRadius * 0.05,
    );


    _drawConeHat(canvas, center, faceRadius);
    _drawPartyBlower(canvas, mouthCenter, faceRadius);

    if (showConfetti) {
      _drawConfetti(canvas, center, faceRadius);
    }
  }


  void _drawEyesAndBrows(Canvas canvas, Offset center, double faceRadius) {
    final cx = center.dx;
    final cy = center.dy;

    final eyePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = faceRadius * 0.08
      ..strokeCap = StrokeCap.round;

    final leftEyePath = Path();
    leftEyePath.moveTo(cx - faceRadius * 0.55, cy - faceRadius * 0.1);
    leftEyePath.quadraticBezierTo(
        cx - faceRadius * 0.35, cy + faceRadius * 0.05,
        cx - faceRadius * 0.15, cy - faceRadius * 0.1
    );
    canvas.drawPath(leftEyePath, eyePaint);

    final rightEyePath = Path();
    rightEyePath.moveTo(cx + faceRadius * 0.15, cy - faceRadius * 0.1);
    rightEyePath.quadraticBezierTo(
        cx + faceRadius * 0.35, cy + faceRadius * 0.05,
        cx + faceRadius * 0.55, cy - faceRadius * 0.1
    );
    canvas.drawPath(rightEyePath, eyePaint);
  }



  void _drawPartyBlower(Canvas canvas, Offset blowerOrigin, double faceRadius) {
    canvas.save();
    canvas.translate(blowerOrigin.dx, blowerOrigin.dy);
    canvas.rotate(0.1);

    final tubeLength = faceRadius * 0.55;
    final tubeWidth = faceRadius * 0.18;

    final tubeRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(tubeLength / 2, 0),
        width: tubeLength,
        height: tubeWidth,
      ),
      Radius.circular(tubeWidth / 2),
    );
    final tubePaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFF64B5F6), const Color(0xFF1976D2)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(tubeRect.outerRect);
    canvas.drawRRect(tubeRect, tubePaint);

    final spotPaint = Paint()..color = const Color(0xFFEC407A);
    for (int i = 0; i < 4; i++) {
      canvas.drawCircle(
        Offset((i * 0.15 + 0.1) * faceRadius, 0),
        faceRadius * 0.04,
        spotPaint,
      );
    }


    final spiralCenter = Offset(tubeLength + faceRadius * 0.02, 0);
    final spiralRect = Rect.fromCircle(center: spiralCenter, radius: faceRadius * 0.15);
    final spiralPaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFBA68C8), const Color(0xFF6A1B9A)],
      ).createShader(spiralRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = faceRadius * 0.12
      ..strokeCap = StrokeCap.round;

    final spiralPath = Path();
    double startAngle = -pi / 2;
    spiralPath.moveTo(
      spiralCenter.dx + faceRadius * 0.1 * cos(startAngle),
      spiralCenter.dy + faceRadius * 0.1 * sin(startAngle),
    );
    for (double i = 0; i < 3 * pi; i += 0.1) {
      final r = faceRadius * 0.1 - (i * faceRadius * 0.008);
      if (r < 0) break;
      final angle = startAngle + i;
      spiralPath.lineTo(spiralCenter.dx + r * cos(angle), spiralCenter.dy + r * sin(angle));
    }
    canvas.drawPath(spiralPath, spiralPaint);

    canvas.restore();
  }

  void _drawConeHat(Canvas canvas, Offset center, double faceRadius) {
    final coneTop = Offset(center.dx, center.dy - faceRadius * 1.4);
    final coneBaseY = center.dy - faceRadius * 0.7;
    final coneBaseWidth = faceRadius * 0.9;
    final coneLeft = Offset(center.dx - coneBaseWidth / 2, coneBaseY);
    final coneRight = Offset(center.dx + coneBaseWidth / 2, coneBaseY);

    final conePath = Path()
      ..moveTo(coneLeft.dx, coneLeft.dy)
      ..lineTo(coneRight.dx, coneRight.dy)
      ..lineTo(coneTop.dx, coneTop.dy)
      ..close();


    final coneRect = conePath.getBounds();
    final conePaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFF5C6BC0), const Color(0xFF3F51B5)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(coneRect);
    canvas.drawPath(conePath, conePaint);


    canvas.save();
    canvas.clipPath(conePath);
    final stripePaint = Paint()..color = const Color(0xFFEC407A);
    final stripeHeight = faceRadius * 0.22;
    for (int i = 0; i < 3; i++) {
      final stripePath = Path()
        ..moveTo(coneLeft.dx - 20, coneLeft.dy - (i * stripeHeight))
        ..lineTo(coneRight.dx + 20, coneLeft.dy - (i * stripeHeight))
        ..lineTo(coneRight.dx + 20, coneLeft.dy - (i * stripeHeight) - stripeHeight * 0.5)
        ..lineTo(coneLeft.dx - 20, coneLeft.dy - (i * stripeHeight) - stripeHeight * 0.5)
        ..close();
      canvas.drawPath(stripePath, stripePaint);
    }
    canvas.restore();

    canvas.drawCircle(coneTop, faceRadius * 0.09, Paint()..color = const Color(0xFF3F51B5));
    canvas.drawCircle(
      Offset(coneTop.dx - faceRadius * 0.02, coneTop.dy - faceRadius * 0.02),
      faceRadius * 0.05,
      Paint()..color = const Color(0xFF9FA8DA),
    );
  }


  void _drawConfetti(Canvas canvas, Offset center, double faceRadius) {
    final confettiColors = [
      Colors.blue, Colors.pink, Colors.green, Colors.orange, Colors.red
    ];
    final rand = Random(42);
    for (int i = 0; i < 20; i++) {
      final p = Offset(
        center.dx + (rand.nextDouble() - 0.5) * faceRadius * 3.5,
        center.dy + (rand.nextDouble() - 0.8) * faceRadius * 3,
      );
      if ((p - center).distance < faceRadius * 1.2) continue;

      final paint = Paint()..color = confettiColors[rand.nextInt(confettiColors.length)];
      final confettiSize = faceRadius * 0.08;

      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(rand.nextDouble() * pi);
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: confettiSize, height: confettiSize), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant PartyFacePainter oldDelegate) {
    return oldDelegate.scale != scale || oldDelegate.showConfetti != showConfetti;
  }
}