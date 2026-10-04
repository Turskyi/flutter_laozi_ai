class ManuscriptReaderArguments {
  const ManuscriptReaderArguments({
    required this.pageNumber,
    this.highlightQuery,
  });

  final int pageNumber;
  final String? highlightQuery;
}
