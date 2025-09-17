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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Indigo primary color
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: Color(0xFF6366F1),
          thumbColor: Color(0xFF6366F1),
          overlayColor: Color(0x1A6366F1),
        ),
      ),
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

class _EmojiHomeScreenState extends State<EmojiHomeScreen> with SingleTickerProviderStateMixin {
  EmojiType _selected = EmojiType.party;
  double _scale = 1.0;
  bool _confetti = true;
  
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _updateEmoji(EmojiType? type) {
    if (type == null || type == _selected) return;
    setState(() {
      _controller.forward(from: 0);
      _selected = type;
    });
  }
  
  void _updateScale(double value) {
    setState(() {
      _controller.forward(from: 0.5);
      _scale = value;
    });
  }

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
            colors: [
              const Color(0xFFEEF2FF), // Indigo 50
              Colors.white,
              const Color(0xFFF8FAFF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 4,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Choose Emoji',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                                  ),
                                ),
                                child: DropdownButton<EmojiType>(
                                  value: _selected,
                                  items: const [
                                    DropdownMenuItem(
                                      value: EmojiType.party,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                                        child: Text('Party Face'),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: EmojiType.heart,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                                        child: Text('Heart'),
                                      ),
                                    ),
                                  ],
                                  onChanged: _updateEmoji,
                                  underline: const SizedBox(),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Size: ${_scale.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 8),
                                Slider(
                                  value: _scale,
                                  min: 0.6,
                                  max: 1.4,
                                  divisions: 8,
                                  label: _scale.toStringAsFixed(2),
                                  onChanged: _updateScale,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Confetti',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              Switch(
                                value: _confetti,
                                onChanged: (v) => setState(() => _confetti = v),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFE0E7FF).withOpacity(0.6),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.04),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                            spreadRadius: -1,
                          ),
                        ],
                      ),
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Opacity(
                              opacity: _opacityAnimation.value,
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
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFC7D2FE),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Tip: Adjust the size or toggle confetti for effects!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}