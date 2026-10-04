import 'package:laozi_ai/entities/manuscript_search_result.dart';
import 'package:laozi_ai/ui/manuscript/manuscript_data.dart';

const int kSnippetRadius = 40;

class ManuscriptSearchService {
  const ManuscriptSearchService();

  List<ManuscriptSearchResult> search({required String query}) {
    final List<ManuscriptSearchResult> results = <ManuscriptSearchResult>[];
    final String trimmedQuery = query.trim();

    if (trimmedQuery.isNotEmpty) {
      final String lowerQuery = trimmedQuery.toLowerCase();
      String currentChapterTitle = '';

      for (final ManuscriptPageData pageData in manuscriptPagesData) {
        final String pageContent = pageData.content;
        final String pageTitle = pageData.title;
        final List<String> paragraphs = pageContent.split('\n\n');

        if (pageData.pageNumber == 1) {
          currentChapterTitle = pageTitle;
        } else {
          // Keep current chapter title carried over from previous page
        }

        for (final String paragraph in paragraphs) {
          final String trimmedParagraph = paragraph.trim();
          final bool isHeading = _isChapterHeading(trimmedParagraph);

          if (isHeading) {
            currentChapterTitle = trimmedParagraph;
          } else {
            final String lowerParagraph = paragraph.toLowerCase();
            int startIndex = 0;

            while (startIndex < lowerParagraph.length) {
              final int matchIndex = lowerParagraph.indexOf(
                lowerQuery,
                startIndex,
              );

              if (matchIndex != -1) {
                final ManuscriptSearchResult result = _createSearchResult(
                  pageNumber: pageData.pageNumber,
                  chapterTitle: currentChapterTitle.isNotEmpty
                      ? currentChapterTitle
                      : pageTitle,
                  pageTitle: pageTitle,
                  content: paragraph,
                  matchIndex: matchIndex,
                  queryLength: trimmedQuery.length,
                  query: trimmedQuery,
                );
                results.add(result);
                startIndex = matchIndex + trimmedQuery.length;
              } else {
                startIndex = lowerParagraph.length;
              }
            }
          }
        }
      }
    } else {
      // Return empty results list for empty query
    }

    return results;
  }

  bool _isChapterHeading(String text) {
    return RegExp(
      r'^(Chapter\s+\d+|Chapters\s+\d+|Closing colophon|Розділ\s+\d+|Розділи\s+\d+|Заключний колофон|\d+\.\s*nodaļa|Noslēguma kolofons|Title Leaf|Титульний аркуш|Titullapa|Preface.*|Передмова.*|Priekšvārds.*)$',
      caseSensitive: false,
    ).hasMatch(text);
  }

  ManuscriptSearchResult _createSearchResult({
    required int pageNumber,
    required String chapterTitle,
    required String pageTitle,
    required String content,
    required int matchIndex,
    required int queryLength,
    required String query,
  }) {
    final int start = (matchIndex - kSnippetRadius).clamp(0, content.length);
    final int end = (matchIndex + queryLength + kSnippetRadius).clamp(
      0,
      content.length,
    );

    final String rawSnippet = content
        .substring(start, end)
        .replaceAll('\n', ' ')
        .replaceAll('\r', ' ');
    final String trimmedSnippet = rawSnippet.trimLeft();
    final int leadingSpaces = rawSnippet.length - trimmedSnippet.length;
    final String finalSnippetText = trimmedSnippet.trimRight();

    final String prefix = start > 0 ? '...' : '';
    final String suffix = end < content.length ? '...' : '';

    final String fullSnippet = '$prefix$finalSnippetText$suffix';

    final int matchInSnippetStart =
        prefix.length + (matchIndex - start) - leadingSpaces;
    final int matchInSnippetEnd = matchInSnippetStart + queryLength;

    return ManuscriptSearchResult(
      pageNumber: pageNumber,
      chapterTitle: chapterTitle,
      pageTitle: pageTitle,
      snippet: fullSnippet,
      matchedRangeStart: matchInSnippetStart.clamp(0, fullSnippet.length),
      matchedRangeEnd: matchInSnippetEnd.clamp(0, fullSnippet.length),
      query: query,
    );
  }
}
