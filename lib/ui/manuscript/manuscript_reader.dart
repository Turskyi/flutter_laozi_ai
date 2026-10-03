import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/router/app_route.dart';
import 'package:laozi_ai/ui/manuscript/manuscript_data.dart';
import 'package:laozi_ai/ui/manuscript/manuscript_text_panel.dart';
import 'package:laozi_ai/ui/manuscript/reading_guide_dialog.dart';
import 'package:laozi_ai/ui/manuscript/zoomable_image_card.dart';

class ManuscriptReader extends StatefulWidget {
  const ManuscriptReader({
    this.initialPage = 1,
    this.highlightQuery,
    super.key,
  });

  final int initialPage;
  final String? highlightQuery;

  @override
  State<ManuscriptReader> createState() => _ManuscriptReaderState();
}

class _ManuscriptReaderState extends State<ManuscriptReader> {
  late int _currentPageNumber = widget.initialPage.clamp(
    kMinManuscriptPage,
    kMaxManuscriptPage,
  );
  String _fullscreenMode = 'none'; // 'none', 'manuscript', 'text'
  int _fullscreenPieceIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentPageNumber = widget.initialPage.clamp(
      kMinManuscriptPage,
      kMaxManuscriptPage,
    );
  }

  void _navigateToPage(int page) {
    setState(() {
      _currentPageNumber = page.clamp(kMinManuscriptPage, kMaxManuscriptPage);
    });
  }

  void _toggleFullscreen(String mode, {int pieceIndex = 0}) {
    setState(() {
      if (_fullscreenMode == mode && _fullscreenPieceIndex == pieceIndex) {
        _fullscreenMode = 'none';
      } else {
        _fullscreenMode = mode;
        _fullscreenPieceIndex = pieceIndex;
      }
    });
  }

  String _headerSubtitle(ManuscriptPageData data) {
    if (data.pageNumber >= 7 && data.pageNumber <= 10) {
      return translate('manuscript.header_dual');
    }
    if (data.pageNumber >= 11) {
      return translate('manuscript.header_2255');
    }
    return translate('manuscript.header_2584');
  }

  @override
  Widget build(BuildContext context) {
    final ManuscriptPageData pageData = getManuscriptPageData(
      _currentPageNumber,
    );
    final List<ManuscriptPieceData> pieces = pageData.resolvedPieces;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _headerSubtitle(pageData),
              style: TextStyle(
                fontSize: 10,
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              pageData.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: translate('manuscript.search'),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoute.manuscriptSearch.path);
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: translate('manuscript.reading_guide'),
            onPressed: () => ReadingGuideDialog.show(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // Normal Split Screen Content
            Column(
              children: <Widget>[
                // Top Navigation Selector Bar
                _buildTopNavBar(context, colorScheme),

                // Main Split Screen Body
                Expanded(
                  child: LayoutBuilder(
                    builder: (BuildContext ctx, BoxConstraints constraints) {
                      final bool isWide = constraints.maxWidth >= 800;

                      final Widget manuscriptColumn = Column(
                        children: pieces.asMap().entries.map((
                          MapEntry<int, ManuscriptPieceData> entry,
                        ) {
                          final int pieceIdx = entry.key;
                          final ManuscriptPieceData piece = entry.value;

                          return Expanded(
                            child: ZoomableImageCard(
                              imageSrc: piece.imageSrc,
                              caption: piece.caption(),
                              pageNumber: _currentPageNumber,
                              totalPages: manuscriptPagesData.length,
                              onPageSelected: _navigateToPage,
                              isFullscreen: false,
                              onToggleFullscreen: () => _toggleFullscreen(
                                'manuscript',
                                pieceIndex: pieceIdx,
                              ),
                            ),
                          );
                        }).toList(),
                      );

                      final Widget textColumn = ManuscriptTextPanel(
                        pageData: pageData,
                        totalPages: manuscriptPagesData.length,
                        onNextPage: () =>
                            _navigateToPage(_currentPageNumber + 1),
                        onSelectPage: _navigateToPage,
                        isFullscreen: false,
                        onToggleFullscreen: () => _toggleFullscreen('text'),
                        highlightQuery: widget.highlightQuery,
                      );

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(child: manuscriptColumn),
                            Expanded(child: textColumn),
                          ],
                        );
                      }

                      return Column(
                        children: <Widget>[
                          Expanded(flex: 5, child: manuscriptColumn),
                          Expanded(flex: 5, child: textColumn),
                        ],
                      );
                    },
                  ),
                ),

                // Bottom Navigation Footer Bar
                _buildBottomFooter(context, colorScheme),
              ],
            ),

            // Fullscreen Manuscript Overlay
            if (_fullscreenMode == 'manuscript')
              Positioned.fill(
                child: ZoomableImageCard(
                  imageSrc: pieces[_fullscreenPieceIndex].imageSrc,
                  caption: pieces[_fullscreenPieceIndex].caption(),
                  pageNumber: _currentPageNumber,
                  totalPages: manuscriptPagesData.length,
                  onPageSelected: _navigateToPage,
                  isFullscreen: true,
                  onToggleFullscreen: () => _toggleFullscreen('none'),
                ),
              ),

            // Fullscreen Text Overlay
            if (_fullscreenMode == 'text')
              Positioned.fill(
                child: ManuscriptTextPanel(
                  pageData: pageData,
                  totalPages: manuscriptPagesData.length,
                  onNextPage: () => _navigateToPage(_currentPageNumber + 1),
                  onSelectPage: _navigateToPage,
                  isFullscreen: true,
                  onToggleFullscreen: () => _toggleFullscreen('none'),
                  highlightQuery: widget.highlightQuery,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Page Indicator and Direct Picker
          Row(
            children: <Widget>[
              Icon(Icons.layers_outlined, size: 18, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                '${translate('manuscript.page')} $_currentPageNumber '
                '${translate('manuscript.of')} '
                '${manuscriptPagesData.length}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: _currentPageNumber,
                isDense: true,
                underline: const SizedBox.shrink(),
                items: manuscriptPagesData.map((ManuscriptPageData p) {
                  return DropdownMenuItem<int>(
                    value: p.pageNumber,
                    child: Text(
                      '${p.pageNumber}: ${p.shortTitle}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }).toList(),
                onChanged: (int? newPage) {
                  if (newPage != null) {
                    _navigateToPage(newPage);
                  }
                },
              ),
            ],
          ),

          // Quick Prev/Next Buttons
          Row(
            children: <Widget>[
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                ),
                onPressed: _currentPageNumber > kMinManuscriptPage
                    ? () => _navigateToPage(_currentPageNumber - 1)
                    : null,
                icon: const Icon(Icons.chevron_left, size: 16),
                label: Text(
                  translate('manuscript.prev'),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                ),
                iconAlignment: IconAlignment.end,
                onPressed: _currentPageNumber < kMaxManuscriptPage
                    ? () => _navigateToPage(_currentPageNumber + 1)
                    : null,
                icon: const Icon(Icons.chevron_right, size: 16),
                label: Text(
                  translate('manuscript.next'),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomFooter(BuildContext context, ColorScheme colorScheme) {
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
          if (_currentPageNumber > kMinManuscriptPage)
            TextButton.icon(
              onPressed: () => _navigateToPage(_currentPageNumber - 1),
              icon: const Icon(Icons.chevron_left),
              label: Text(translate('manuscript.prev')),
            )
          else
            const SizedBox.shrink(),

          if (_currentPageNumber < kMaxManuscriptPage)
            FilledButton.icon(
              iconAlignment: IconAlignment.end,
              onPressed: () => _navigateToPage(_currentPageNumber + 1),
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
