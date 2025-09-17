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
    
    // Base face gradient
    final baseFacePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFE082), // Lighter Yellow
          const Color(0xFFFFC107), // Mid Yellow
          const Color(0xFFFFB300), // Darker Yellow
        ],
        stops: const [0.0, 0.7, 1.0],
        center: const Alignment(-0.2, -0.2),
        radius: 1.2,
      ).createShader(faceRect);
    canvas.drawCircle(center, faceRadius, baseFacePaint);
    
    // Overlay gradient for depth
    final overlayPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withOpacity(0.4),
          Colors.white.withOpacity(0.1),
          Colors.black.withOpacity(0.05),
        ],
        stops: const [0.0, 0.6, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(faceRect);
    canvas.drawCircle(center, faceRadius, overlayPaint);
    
    // Highlight
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.4),
          Colors.white.withOpacity(0.0),
        ],
        center: const Alignment(-0.5, -0.5),
        radius: 0.8,
      ).createShader(faceRect);
    canvas.drawCircle(center, faceRadius, highlightPaint);


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

    // Add a slight curve to the cone sides for a more natural look
    final curvedConePath = Path()
      ..moveTo(coneLeft.dx, coneLeft.dy)
      ..quadraticBezierTo(
        center.dx - faceRadius * 0.1,
        coneBaseY - faceRadius * 0.4,
        coneTop.dx,
        coneTop.dy,
      )
      ..quadraticBezierTo(
        center.dx + faceRadius * 0.1,
        coneBaseY - faceRadius * 0.4,
        coneRight.dx,
        coneRight.dy,
      )
      ..close();

    final coneRect = curvedConePath.getBounds();
    
    // Base gradient for the cone
    final conePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF6366F1), // Indigo 500
          const Color(0xFF4F46E5), // Indigo 600
          const Color(0xFF4338CA), // Indigo 700
        ],
        stops: const [0.0, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(coneRect);
      
    // Add metallic effect with a sweep gradient
    final metallicPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.white.withOpacity(0.3),
          Colors.white.withOpacity(0.0),
          Colors.white.withOpacity(0.3),
        ],
        stops: const [0.0, 0.5, 1.0],
        center: Alignment.center,
        startAngle: 0,
        endAngle: pi * 2,
      ).createShader(coneRect);
    // Draw base cone with curved path
    canvas.drawPath(curvedConePath, conePaint);
    canvas.drawPath(curvedConePath, metallicPaint);

    // Add stripes with gradient
    canvas.save();
    canvas.clipPath(curvedConePath);
    final stripeHeight = faceRadius * 0.22;
    final stripePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFF472B6), // Pink 400
          const Color(0xFFEC4899), // Pink 500
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(coneRect);

    for (int i = 0; i < 3; i++) {
      final stripePath = Path();
      final y = coneLeft.dy - (i * stripeHeight);
      final angle = -pi * 0.05; // Slight tilt for dynamic look
      
      stripePath.moveTo(
        coneLeft.dx - 20 * cos(angle),
        y - 20 * sin(angle),
      );
      stripePath.lineTo(
        coneRight.dx + 20 * cos(angle),
        y - 20 * sin(angle),
      );
      stripePath.lineTo(
        coneRight.dx + 20 * cos(angle),
        y - stripeHeight * 0.5 - 20 * sin(angle),
      );
      stripePath.lineTo(
        coneLeft.dx - 20 * cos(angle),
        y - stripeHeight * 0.5 - 20 * sin(angle),
      );
      stripePath.close();
      
      canvas.drawPath(stripePath, stripePaint);
    }
    canvas.restore();

    // Draw pom-pom with gradient and highlight
    final pomPomPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF818CF8), // Indigo 400
          const Color(0xFF6366F1), // Indigo 500
        ],
        center: const Alignment(-0.2, -0.2),
        radius: 1.0,
      ).createShader(Rect.fromCircle(center: coneTop, radius: faceRadius * 0.09));
    canvas.drawCircle(coneTop, faceRadius * 0.09, pomPomPaint);

    // Add highlight to pom-pom
    final pomPomHighlight = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.6),
          Colors.white.withOpacity(0.0),
        ],
        center: const Alignment(-0.5, -0.5),
        radius: 0.8,
      ).createShader(Rect.fromCircle(
        center: Offset(coneTop.dx - faceRadius * 0.02, coneTop.dy - faceRadius * 0.02),
        radius: faceRadius * 0.05,
      ));
    canvas.drawCircle(
      Offset(coneTop.dx - faceRadius * 0.02, coneTop.dy - faceRadius * 0.02),
      faceRadius * 0.05,
      pomPomHighlight,
    );
  }


  void _drawConfetti(Canvas canvas, Offset center, double faceRadius) {
    final confettiColors = [
      const Color(0xFF60A5FA), // Blue 400
      const Color(0xFFF472B6), // Pink 400
      const Color(0xFF34D399), // Emerald 400
      const Color(0xFFFBBF24), // Amber 400
      const Color(0xFFF87171), // Red 400
    ];
    
    final rand = Random(42);
    final now = DateTime.now().millisecondsSinceEpoch / 1000.0;
    
    for (int i = 0; i < 25; i++) {
      // Add some wave motion to the confetti
      final wave = sin(now + i) * faceRadius * 0.1;
      final p = Offset(
        center.dx + (rand.nextDouble() - 0.5) * faceRadius * 3.5 + wave,
        center.dy + (rand.nextDouble() - 0.8) * faceRadius * 3,
      );
      
      if ((p - center).distance < faceRadius * 1.2) continue;

      final baseColor = confettiColors[rand.nextInt(confettiColors.length)];
      final confettiSize = faceRadius * 0.08;
      
      // Create gradient paint for each confetti piece
      final paint = Paint()
        ..shader = LinearGradient(
          colors: [
            baseColor,
            Color.lerp(baseColor, Colors.white, 0.6)!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromCenter(
          center: Offset.zero,
          width: confettiSize,
          height: confettiSize,
        ));

      canvas.save();
      canvas.translate(p.dx, p.dy);
      
      // Add rotation animation
      final rotation = (now * 2 + i) % (pi * 2);
      canvas.rotate(rotation);
      
      // Draw confetti with rounded corners
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: confettiSize,
            height: confettiSize,
          ),
          Radius.circular(confettiSize * 0.2),
        ),
        paint,
      );
      
      // Add sparkle effect
      if (rand.nextDouble() < 0.3) {
        final sparkleSize = confettiSize * 0.4;
        final sparklePaint = Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.white.withOpacity(0.8),
              Colors.white.withOpacity(0.0),
            ],
          ).createShader(Rect.fromCircle(
            center: Offset.zero,
            radius: sparkleSize,
          ));
        canvas.drawCircle(Offset.zero, sparkleSize, sparklePaint);
      }
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant PartyFacePainter oldDelegate) {
    return oldDelegate.scale != scale || oldDelegate.showConfetti != showConfetti;
  }
}