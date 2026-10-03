import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/entities/manuscript_search_result.dart';

class ManuscriptSearchResultItem extends StatelessWidget {
  const ManuscriptSearchResultItem({
    required this.result,
    required this.onTap,
    super.key,
  });

  final ManuscriptSearchResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String pageLabel =
        '${result.chapterTitle} • ${translate('manuscript.page')} '
        '${result.pageNumber}';

    final Widget snippetWidget = _buildSnippet(colorScheme);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              pageLabel,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            snippetWidget,
          ],
        ),
      ),
    );
  }

  Widget _buildSnippet(ColorScheme colorScheme) {
    final List<InlineSpan> spans = <InlineSpan>[];
    final String snippet = result.snippet;
    final int start = result.matchedRangeStart;
    final int end = result.matchedRangeEnd;

    if (start > 0 && start <= snippet.length) {
      spans.add(TextSpan(text: snippet.substring(0, start)));
    } else {
      // No prefix span needed
    }

    if (start < end && end <= snippet.length) {
      spans.add(
        TextSpan(
          text: snippet.substring(start, end),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            backgroundColor: colorScheme.primaryContainer,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      );
    } else {
      // No match span needed
    }

    if (end < snippet.length) {
      spans.add(TextSpan(text: snippet.substring(end)));
    } else {
      // No suffix span needed
    }

    return Text.rich(
      TextSpan(children: spans),
      style: TextStyle(fontSize: 14, height: 1.4, color: colorScheme.onSurface),
    );
  }
}
