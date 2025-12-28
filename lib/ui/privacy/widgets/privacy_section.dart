import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class PrivacySection extends StatelessWidget {
  const PrivacySection({
    required this.pageKey,
    required this.sectionKey,
    this.appName,
    this.date,
    this.email,
    this.aiModelName,
    super.key,
  });

  final String pageKey;
  final String sectionKey;
  final String? appName;
  final String? date;
  final String? email;
  final String? aiModelName;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            translate('$pageKey.${sectionKey}_title'),
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            translate(
              '$pageKey.${sectionKey}_body',
              args: <String, Object?>{
                if (appName != null) 'appName': appName,
                if (date != null) 'date': date,
                if (email != null) 'email': email,
                if (aiModelName != null) 'ai_model_name': aiModelName,
              },
            ),
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
