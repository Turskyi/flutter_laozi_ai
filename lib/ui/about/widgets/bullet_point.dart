import 'package:flutter/material.dart';

class BulletPoint extends StatelessWidget {
  const BulletPoint({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '• ',
            style: TextStyle(fontSize: textTheme.headlineSmall?.fontSize),
          ),
          Expanded(child: Text(text, style: textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
