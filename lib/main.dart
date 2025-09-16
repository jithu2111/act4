import 'package:flutter/material.dart';
import 'dart:math';

import 'painters/party_face_painter.dart';
import 'painters/heart_painter.dart';

void main() {
  runApp(const EmojiDrawingApp());
}

class EmojiDrawingApp extends StatelessWidget {
  const EmojiDrawingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emoji Drawing - ACT4',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const EmojiHomeScreen(),
    );
  }
}

enum EmojiType { party, heart }

class EmojiHomeScreen extends StatefulWidget {
  const EmojiHomeScreen({super.key});

  @override
  State<EmojiHomeScreen> createState() => _EmojiHomeScreenState();
}

class _EmojiHomeScreenState extends State<EmojiHomeScreen> {
  EmojiType _selected = EmojiType.party;
  double _scale = 1.0;
  bool _confetti = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Emoji Drawing (ACT4)'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  const Text('Emoji:'),
                  const SizedBox(width: 8),
                  DropdownButton<EmojiType>(
                    value: _selected,
                    items: const [
                      DropdownMenuItem(value: EmojiType.party, child: Text('Party Face')),
                      DropdownMenuItem(value: EmojiType.heart, child: Text('Heart')),
                    ],
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() => _selected = v);
                    },
                  ),
                  const SizedBox(width: 18),
                  const Text('Size:'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Slider(
                      value: _scale,
                      min: 0.6,
                      max: 1.4,
                      divisions: 8,
                      label: _scale.toStringAsFixed(2),
                      onChanged: (val) => setState(() => _scale = val),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      const Text('Confetti'),
                      Switch(value: _confetti, onChanged: (v) => setState(() => _confetti = v)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Divider(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final canvasWidth = constraints.maxWidth * 0.9;
                  final canvasHeight = min(constraints.maxHeight * 0.9, 520.0);
                  final size = Size(canvasWidth, canvasHeight);
                  return Center(
                    child: Container(
                      width: size.width,
                      height: size.height,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12, offset: Offset(0, 4))],
                      ),
                      child: CustomPaint(
                        size: size,
                        painter: _selected == EmojiType.party
                            ? PartyFacePainter(scale: _scale, showConfetti: _confetti)
                            : HeartPainter(scale: _scale),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                'Tip: Move the Size slider and toggle Confetti.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}