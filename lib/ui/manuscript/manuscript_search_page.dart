import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/entities/manuscript_reader_arguments.dart';
import 'package:laozi_ai/entities/manuscript_search_result.dart';
import 'package:laozi_ai/infrastructure/manuscript_search_service.dart';
import 'package:laozi_ai/router/app_route.dart';
import 'package:laozi_ai/ui/manuscript/widgets/manuscript_search_bar.dart';
import 'package:laozi_ai/ui/manuscript/widgets/manuscript_search_empty_view.dart';
import 'package:laozi_ai/ui/manuscript/widgets/manuscript_search_result_item.dart';

class ManuscriptSearchPage extends StatefulWidget {
  const ManuscriptSearchPage({super.key});

  @override
  State<ManuscriptSearchPage> createState() => _ManuscriptSearchPageState();
}

class _ManuscriptSearchPageState extends State<ManuscriptSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ManuscriptSearchService _searchService =
      const ManuscriptSearchService();
  List<ManuscriptSearchResult> _results = <ManuscriptSearchResult>[];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    setState(() {
      _results = _searchService.search(query: query);
    });
  }

  void _onClearSearch() {
    _searchController.clear();
    setState(() {
      _results = <ManuscriptSearchResult>[];
    });
  }

  void _onResultSelected(ManuscriptSearchResult result) {
    Navigator.of(context).pushReplacementNamed(
      AppRoute.manuscript.path,
      arguments: ManuscriptReaderArguments(
        pageNumber: result.pageNumber,
        highlightQuery: result.query,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String query = _searchController.text.trim();
    final bool isQueryEmpty = query.isEmpty;
    final Widget contentBody;

    if (isQueryEmpty || _results.isEmpty) {
      contentBody = ManuscriptSearchEmptyView(isQueryEmpty: isQueryEmpty);
    } else {
      contentBody = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              translate(
                'manuscript.search_results',
                args: <String, Object?>{'count': _results.length},
              ),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (BuildContext context, int index) {
                final ManuscriptSearchResult result = _results[index];

                return ManuscriptSearchResultItem(
                  result: result,
                  onTap: () => _onResultSelected(result),
                );
              },
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(translate('manuscript.search_manuscript'))),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ManuscriptSearchBar(
              controller: _searchController,
              onChanged: _onQueryChanged,
              onClear: _onClearSearch,
            ),
            Expanded(child: contentBody),
          ],
        ),
      ),
    );
  }
}
