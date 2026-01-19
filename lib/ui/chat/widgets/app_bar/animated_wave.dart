import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:laozi_ai/ui/chat/widgets/app_bar/wave_painter.dart';

class AnimatedWave extends StatefulWidget {
  const AnimatedWave({super.key});

  @override
  State<AnimatedWave> createState() => _AnimatedWaveState();
}

class _AnimatedWaveState extends State<AnimatedWave>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    );
    _animation =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          });
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight * 2,
      child: CustomPaint(
        painter: WavePainter(
          waveAnimationValue: _animation.value,
          colorScheme: Theme.of(context).colorScheme,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
