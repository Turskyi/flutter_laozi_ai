class ManuscriptSearchResult {
  const ManuscriptSearchResult({
    required this.pageNumber,
    required this.chapterTitle,
    required this.pageTitle,
    required this.snippet,
    required this.matchedRangeStart,
    required this.matchedRangeEnd,
    required this.query,
  });

  final int pageNumber;
  final String chapterTitle;
  final String pageTitle;
  final String snippet;
  final int matchedRangeStart;
  final int matchedRangeEnd;
  final String query;
}
