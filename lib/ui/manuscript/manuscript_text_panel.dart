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
    super.key,
  });

  final ManuscriptPageData pageData;
  final int totalPages;
  final VoidCallback onNextPage;
  final ValueChanged<int> onSelectPage;
  final bool isFullscreen;
  final VoidCallback? onToggleFullscreen;

  @override
  State<ManuscriptTextPanel> createState() => _ManuscriptTextPanelState();
}

class _ManuscriptTextPanelState extends State<ManuscriptTextPanel> {
  double _fontScale = 1.0;
  late final ScrollController _scrollController = ScrollController();
  late final ScrollController _fullscreenScrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    _fullscreenScrollController.dispose();
    super.dispose();
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

    if (widget.isFullscreen) {
      return _buildFullscreenOverlay(context, colorScheme);
    }

    return Card(
      margin: const EdgeInsets.all(6),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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

        if (isChapterHeading) {
          return Padding(
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
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            paragraph,
            style: TextStyle(
              fontSize: baseFontSize,
              height: 1.6,
              fontFamily: 'serif',
              color: colorScheme.onSurface,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter(BuildContext context, ColorScheme colorScheme) {
    if (widget.pageData.isLastPage) {
      return Container(
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
    }

    return Padding(
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
