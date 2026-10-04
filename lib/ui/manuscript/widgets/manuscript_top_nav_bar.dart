import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/ui/manuscript/manuscript_data.dart';

const EdgeInsets _kNavButtonPadding = EdgeInsets.symmetric(
  horizontal: 4,
  vertical: 6,
);

class ManuscriptTopNavBar extends StatelessWidget {
  const ManuscriptTopNavBar({
    required this.currentPageNumber,
    required this.totalPages,
    required this.pagesData,
    required this.onPageSelected,
    super.key,
  });

  final int currentPageNumber;
  final int totalPages;
  final List<ManuscriptPageData> pagesData;
  final ValueChanged<int> onPageSelected;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 4,
                children: <Widget>[
                  // Page Indicator and Direct Picker
                  Row(
                    spacing: 4,
                    children: <Widget>[
                      Icon(
                        Icons.layers_outlined,
                        size: 18,
                        color: colorScheme.primary,
                      ),

                      Text(
                        '${translate('manuscript.page')} $currentPageNumber '
                        '${translate('manuscript.of')} $totalPages',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      DropdownButton<int>(
                        value: currentPageNumber,
                        isDense: true,
                        underline: const SizedBox.shrink(),
                        items: pagesData.map((ManuscriptPageData p) {
                          return DropdownMenuItem<int>(
                            value: p.pageNumber,
                            child: Text(
                              '${p.pageNumber}: ${p.shortTitle}',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          );
                        }).toList(),
                        onChanged: (int? newPage) {
                          if (newPage != null) {
                            onPageSelected(newPage);
                          }
                        },
                      ),
                    ],
                  ),

                  // Quick Prev/Next Buttons
                  Row(
                    spacing: 4,
                    children: <Widget>[
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: _kNavButtonPadding,
                        ),
                        onPressed: currentPageNumber > kMinManuscriptPage
                            ? () {
                                onPageSelected(currentPageNumber - 1);
                              }
                            : null,
                        icon: const Icon(Icons.chevron_left, size: 16),
                        label: Text(
                          translate('manuscript.prev'),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: _kNavButtonPadding,
                        ),
                        iconAlignment: IconAlignment.end,
                        onPressed: currentPageNumber < kMaxManuscriptPage
                            ? () {
                                onPageSelected(currentPageNumber + 1);
                              }
                            : null,
                        icon: const Icon(Icons.chevron_right, size: 16),
                        label: Text(
                          translate('manuscript.next'),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
