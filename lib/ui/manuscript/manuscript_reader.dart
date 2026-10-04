import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/domain_services/settings_repository.dart';
import 'package:laozi_ai/router/app_route.dart';
import 'package:laozi_ai/ui/manuscript/manuscript_data.dart';
import 'package:laozi_ai/ui/manuscript/manuscript_text_panel.dart';
import 'package:laozi_ai/ui/manuscript/reading_guide_dialog.dart';
import 'package:laozi_ai/ui/manuscript/widgets/manuscript_bottom_footer.dart';
import 'package:laozi_ai/ui/manuscript/widgets/manuscript_top_nav_bar.dart';
import 'package:laozi_ai/ui/manuscript/zoomable_image_card.dart';

class ManuscriptReader extends StatefulWidget {
  const ManuscriptReader({
    required this.settingsRepository,
    this.initialPage = 1,
    this.highlightQuery,
    super.key,
  });

  final SettingsRepository settingsRepository;
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
  late List<int> _bookmarkedPages;
  String _fullscreenMode = 'none'; // 'none', 'manuscript', 'text'
  int _fullscreenPieceIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentPageNumber = widget.initialPage.clamp(
      kMinManuscriptPage,
      kMaxManuscriptPage,
    );
    widget.settingsRepository.saveLastManuscriptPage(_currentPageNumber);
    _bookmarkedPages = widget.settingsRepository.getManuscriptBookmarks();
  }

  void _navigateToPage(int page) {
    final int clampedPage = page.clamp(kMinManuscriptPage, kMaxManuscriptPage);
    widget.settingsRepository.saveLastManuscriptPage(clampedPage);
    setState(() {
      _currentPageNumber = clampedPage;
    });
  }

  void _toggleBookmark() {
    setState(() {
      if (_bookmarkedPages.contains(_currentPageNumber)) {
        _bookmarkedPages.remove(_currentPageNumber);
      } else {
        _bookmarkedPages.add(_currentPageNumber);
        _bookmarkedPages.sort();
      }
      widget.settingsRepository.saveManuscriptBookmarks(_bookmarkedPages);
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
            icon: Icon(
              _bookmarkedPages.contains(_currentPageNumber)
                  ? Icons.bookmark
                  : Icons.bookmark_border,
            ),
            tooltip: _bookmarkedPages.contains(_currentPageNumber)
                ? translate('manuscript.remove_bookmark')
                : translate('manuscript.bookmark'),
            onPressed: _toggleBookmark,
          ),
          IconButton(
            icon: const Icon(Icons.bookmarks_outlined),
            tooltip: translate('manuscript.saved_pages'),
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamed(AppRoute.manuscriptSaved.path).then((Object? _) {
                if (mounted) {
                  setState(() {
                    _bookmarkedPages = widget.settingsRepository
                        .getManuscriptBookmarks();
                  });
                }
              });
            },
          ),
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
                ManuscriptTopNavBar(
                  currentPageNumber: _currentPageNumber,
                  totalPages: manuscriptPagesData.length,
                  pagesData: manuscriptPagesData,
                  onPageSelected: _navigateToPage,
                ),

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
                      } else {
                        const int kManuscriptVerticalFlex = 1;
                        const int kTextVerticalFlex = 2;
                        return Column(
                          children: <Widget>[
                            Expanded(
                              flex: kManuscriptVerticalFlex,
                              child: manuscriptColumn,
                            ),
                            Expanded(
                              flex: kTextVerticalFlex,
                              child: textColumn,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),

                // Bottom Navigation Footer Bar
                ManuscriptBottomFooter(
                  currentPageNumber: _currentPageNumber,
                  onPageSelected: _navigateToPage,
                ),
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
}
