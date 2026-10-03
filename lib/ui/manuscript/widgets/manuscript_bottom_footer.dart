import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/ui/manuscript/manuscript_data.dart';

class ManuscriptBottomFooter extends StatelessWidget {
  const ManuscriptBottomFooter({
    required this.currentPageNumber,
    required this.onPageSelected,
    super.key,
  });

  final int currentPageNumber;
  final ValueChanged<int> onPageSelected;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (currentPageNumber > kMinManuscriptPage)
            TextButton.icon(
              onPressed: () {
                onPageSelected(currentPageNumber - 1);
              },
              icon: const Icon(Icons.chevron_left),
              label: Text(translate('manuscript.prev')),
            )
          else
            const SizedBox.shrink(),
          if (currentPageNumber < kMaxManuscriptPage)
            FilledButton.icon(
              iconAlignment: IconAlignment.end,
              onPressed: () {
                onPageSelected(currentPageNumber + 1);
              },
              icon: const Icon(Icons.chevron_right),
              label: Text(translate('manuscript.next')),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
