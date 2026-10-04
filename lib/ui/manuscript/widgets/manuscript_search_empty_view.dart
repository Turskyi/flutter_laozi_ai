import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ManuscriptSearchEmptyView extends StatelessWidget {
  const ManuscriptSearchEmptyView({required this.isQueryEmpty, super.key});

  final bool isQueryEmpty;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final IconData iconData;
    final String message;

    if (isQueryEmpty) {
      iconData = Icons.search;
      message = translate('manuscript.search_hint');
    } else {
      iconData = Icons.search_off;
      message = translate('manuscript.no_results');
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              size: 48,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
