import 'package:flutter/material.dart';
import 'package:laozi_ai/ui/app_bar/animated_wave.dart';

class WaveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WaveAppBar({
    super.key,
    required this.title,
    this.height = kToolbarHeight * 1.1,
  });

  final String title;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      scrolledUnderElevation: 0.0,
      backgroundColor: Colors.transparent,
      flexibleSpace: const AnimatedWave(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
