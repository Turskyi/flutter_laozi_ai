import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/ui/manuscript/manuscript_data.dart';

class ManuscriptTextPanel extends StatefulWidget {
  const ManuscriptTextPanel({
    required this.pageData,
    required this.totalPages,
    required this.onNextPage,
    required this.onSelectPage,
    this.isFullscreen = false,
    this.onToggleFullscreen,
    this.highlightQuery,
    super.key,
  });

  final ManuscriptPageData pageData;
  final int totalPages;
  final VoidCallback onNextPage;
  final ValueChanged<int> onSelectPage;
  final bool isFullscreen;
  final VoidCallback? onToggleFullscreen;
  final String? highlightQuery;

  @override
  State<ManuscriptTextPanel> createState() => _ManuscriptTextPanelState();
}

class _ManuscriptTextPanelState extends State<ManuscriptTextPanel> {
  double _fontScale = 1.0;
  late final ScrollController _scrollController = ScrollController();
  late final ScrollController _fullscreenScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollToMatchIfNeeded();
  }

  @override
  void didUpdateWidget(ManuscriptTextPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.highlightQuery != oldWidget.highlightQuery ||
        widget.pageData != oldWidget.pageData) {
      _scrollToMatchIfNeeded();
    } else {
      // No scroll needed
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fullscreenScrollController.dispose();
    super.dispose();
  }

  void _scrollToMatchIfNeeded() {
    final String? query = widget.highlightQuery;
    final String trimmedQuery = query?.trim() ?? '';

    if (trimmedQuery.isNotEmpty) {
      final String content = widget.pageData.content;
      final int matchIndex = content.toLowerCase().indexOf(
        trimmedQuery.toLowerCase(),
      );

      if (matchIndex != -1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final ScrollController controller = widget.isFullscreen
              ? _fullscreenScrollController
              : _scrollController;

          if (controller.hasClients) {
            final double ratio = matchIndex / content.length;
            final double maxScroll = controller.position.maxScrollExtent;
            final double targetOffset = (ratio * maxScroll).clamp(
              0.0,
              maxScroll,
            );

            controller.animateTo(
              targetOffset,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          } else {
            // Controller not attached
          }
        });
      } else {
        // Query match not found in page content
      }
    } else {
      // Query is empty
    }
  }

  void _increaseFont() {
    setState(() {
      _fontScale = (_fontScale + 0.15).clamp(0.85, 1.45);
    });
  }

  void _decreaseFont() {
    setState(() {
      _fontScale = (_fontScale - 0.15).clamp(0.85, 1.45);
    });
  }

  void _resetFont() {
    setState(() {
      _fontScale = 1.0;
    });
  }

  String get _continueText {
    final int nextPage = widget.pageData.pageNumber + 1;
    final String nextTitle = getManuscriptPageData(nextPage).shortTitle;
    return translate(
      'manuscript.continue_to_page',
      args: <String, Object?>{'page': nextPage, 'title': nextTitle},
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Widget bodyWidget;

    if (widget.isFullscreen) {
      bodyWidget = _buildFullscreenOverlay(context, colorScheme);
    } else {
      bodyWidget = Card(
        margin: const EdgeInsets.all(6),
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Header Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildHeaderBar(context, colorScheme),
              ),
              const SizedBox(height: 12),

              // Inline orientation note if applicable
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildInlineNote(colorScheme),
              ),

              // Main Text Content
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  interactive: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildFormattedText(context, colorScheme),
                    ),
                  ),
                ),
              ),

              // Footer (Continue / End)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildFooter(context, colorScheme),
              ),
            ],
          ),
        ),
      );
    }

    return bodyWidget;
  }

  Widget _buildHeaderBar(BuildContext context, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              translate('manuscript.translation_and_notes').toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Page ${widget.pageData.pageNumber} of ${widget.totalPages}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            // Font Scale Controls
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                    onTap: _fontScale > 0.85 ? _decreaseFont : null,
                    borderRadius: BorderRadius.circular(6),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        'A-',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _fontScale < 1.45 ? _increaseFont : null,
                    borderRadius: BorderRadius.circular(6),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        'A+',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            if (widget.onToggleFullscreen != null)
              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: widget.onToggleFullscreen,
                icon: const Icon(Icons.fullscreen, size: 14),
                label: Text(
                  translate('manuscript.fullscreen'),
                  style: const TextStyle(fontSize: 11),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildInlineNote(ColorScheme colorScheme) {
    final String? note = widget.pageData.note;
    final Widget noteWidget;
    if (note == null) {
      noteWidget = const SizedBox.shrink();
    } else {
      noteWidget = Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.amber.withValues(alpha: 0.35)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Icon(Icons.note_alt_outlined, size: 16, color: Colors.amber),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                note,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return noteWidget;
  }

  Widget _buildFormattedText(BuildContext context, ColorScheme colorScheme) {
    final String content = widget.pageData.content;
    final List<String> paragraphs = content.split('\n\n');
    final double baseFontSize = 15.0 * _fontScale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((String paragraph) {
        final String trimmed = paragraph.trim();
        final bool isChapterHeading = RegExp(
          r'^(Chapter\s+\d+|Chapters\s+\d+|Closing colophon|Розділ\s+\d+|Розділи\s+\d+|Заключний колофон|\d+\.\s*nodaļa|Noslēguma kolofons)$',
          caseSensitive: false,
        ).hasMatch(trimmed);

        final Widget itemWidget;
        if (isChapterHeading) {
          itemWidget = Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 8),
            child: SelectableText(
              trimmed,
              style: TextStyle(
                fontSize: baseFontSize * 1.15,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                fontFamily: 'serif',
              ),
            ),
          );
        } else {
          itemWidget = _buildParagraphText(
            paragraph: paragraph,
            baseFontSize: baseFontSize,
            colorScheme: colorScheme,
            highlightQuery: widget.highlightQuery,
          );
        }

        return itemWidget;
      }).toList(),
    );
  }

  Widget _buildParagraphText({
    required String paragraph,
    required double baseFontSize,
    required ColorScheme colorScheme,
    required String? highlightQuery,
  }) {
    final String query = highlightQuery?.trim() ?? '';
    final Widget textWidget;

    if (query.isNotEmpty) {
      final String lowerParagraph = paragraph.toLowerCase();
      final String lowerQuery = query.toLowerCase();
      final List<InlineSpan> spans = <InlineSpan>[];
      int startIndex = 0;

      while (startIndex < paragraph.length) {
        final int matchIndex = lowerParagraph.indexOf(lowerQuery, startIndex);

        if (matchIndex != -1) {
          if (matchIndex > startIndex) {
            spans.add(
              TextSpan(text: paragraph.substring(startIndex, matchIndex)),
            );
          } else {
            // No preceding text
          }

          spans.add(
            TextSpan(
              text: paragraph.substring(matchIndex, matchIndex + query.length),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                backgroundColor: colorScheme.primaryContainer,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          );

          startIndex = matchIndex + query.length;
        } else {
          spans.add(TextSpan(text: paragraph.substring(startIndex)));
          startIndex = paragraph.length;
        }
      }

      textWidget = SelectableText.rich(
        TextSpan(children: spans),
        style: TextStyle(
          fontSize: baseFontSize,
          height: 1.6,
          fontFamily: 'serif',
          color: colorScheme.onSurface,
        ),
      );
    } else {
      textWidget = SelectableText(
        paragraph,
        style: TextStyle(
          fontSize: baseFontSize,
          height: 1.6,
          fontFamily: 'serif',
          color: colorScheme.onSurface,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: textWidget,
    );
  }

  Widget _buildFooter(BuildContext context, ColorScheme colorScheme) {
    final Widget footerWidget;

    if (widget.pageData.isLastPage) {
      footerWidget = Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              translate('manuscript.end_of_reader'),
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    } else {
      footerWidget = Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: widget.onNextPage,
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.chevron_right, size: 16),
            label: Text(_continueText, style: const TextStyle(fontSize: 12)),
          ),
        ),
      );
    }

    return footerWidget;
  }

  Widget _buildFullscreenOverlay(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        automaticallyImplyLeading: false,
        titleSpacing: 8,
        title: Row(
          children: <Widget>[
            // Page Navigation (Prev)
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: widget.pageData.pageNumber > kMinManuscriptPage
                  ? () => widget.onSelectPage(widget.pageData.pageNumber - 1)
                  : null,
              tooltip: translate('manuscript.prev'),
            ),
            Text(
              '${translate('manuscript.page')} ${widget.pageData.pageNumber} '
              '${translate('manuscript.of')} ${widget.totalPages}',
              style: const TextStyle(fontSize: 13),
            ),
            // Page Navigation (Next)
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: widget.pageData.pageNumber < kMaxManuscriptPage
                  ? () => widget.onSelectPage(widget.pageData.pageNumber + 1)
                  : null,
              tooltip: translate('manuscript.next'),
            ),

            const Spacer(),

            // Font Size Controls
            IconButton(
              icon: const Icon(Icons.zoom_out),
              onPressed: _fontScale > 0.85 ? _decreaseFont : null,
            ),
            Text(
              '${(_fontScale * 100).round()}%',
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
            IconButton(
              icon: const Icon(Icons.zoom_in),
              onPressed: _fontScale < 1.45 ? _increaseFont : null,
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _fontScale != 1.0 ? _resetFont : null,
            ),

            const Spacer(),

            // Exit Fullscreen Button
            FilledButton.tonalIcon(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: widget.onToggleFullscreen,
              icon: const Icon(Icons.fullscreen_exit, size: 16),
              label: Text(
                translate('manuscript.exit'),
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
      body: Scrollbar(
        controller: _fullscreenScrollController,
        interactive: true,
        child: SingleChildScrollView(
          controller: _fullscreenScrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildInlineNote(colorScheme),
                    _buildFormattedText(context, colorScheme),
                    _buildFooter(context, colorScheme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
