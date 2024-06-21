import 'package:flutter/material.dart';
import 'package:laozi_ai/ui/chat/app_bar/animated_wave.dart';

class WaveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WaveAppBar({
    super.key,
    this.title = '',
    this.height = kToolbarHeight * 1.2,
    this.actions = const<Widget>[],
  });

  final String title;
  final double height;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, maxLines: 2),
      scrolledUnderElevation: 0.0,
      backgroundColor: Colors.transparent,
      flexibleSpace: const AnimatedWave(),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
