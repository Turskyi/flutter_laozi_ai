import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class FaqItem extends StatelessWidget {
  const FaqItem({
    required this.titleKey,
    required this.paragraphKeys,
    this.customContent,
    super.key,
  });

  final String titleKey;
  final List<String> paragraphKeys;
  final Widget? customContent;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ExpansionTile(
      title: Text(
        translate(titleKey),
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      children: <Widget>[
        ...paragraphKeys.map((String key) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            child: Text(translate(key), style: theme.textTheme.bodyLarge),
          );
        }),
        if (customContent != null) customContent!,
      ],
    );
  }
}
