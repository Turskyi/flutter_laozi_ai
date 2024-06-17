import 'dart:math' as math;

import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  const WavePainter({
    required this.waveAnimationValue,
    required this.colorScheme,
  });

  final double waveAnimationValue;
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final Gradient gradient = LinearGradient(
      colors: <Color>[
        // Lighter shade.
        colorScheme.inversePrimary,
        // Medium shade.
        colorScheme.onPrimaryFixedVariant,
        // Darker shade.
        colorScheme.onSecondaryContainer.withAlpha(244),
      ],
      stops: const <double>[0.0, 0.5, 1.0],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Shader shader = gradient.createShader(rect);

    final Paint paint = Paint()
      ..shader = shader
      ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(0, size.height);
    for (double i = 0.0; i < size.width; i++) {
      path.lineTo(
        i,
        size.height -
            10 * math.sin(waveAnimationValue + i / size.width * 2 * math.pi),
      );
    }
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
