import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/domain_services/settings_repository.dart';
import 'package:laozi_ai/router/app_route.dart';
import 'package:laozi_ai/ui/manuscript/widgets/manuscript_saved_empty_view.dart';
import 'package:laozi_ai/ui/manuscript/widgets/manuscript_saved_item.dart';

class ManuscriptSavedPage extends StatefulWidget {
  const ManuscriptSavedPage({required this.settingsRepository, super.key});

  final SettingsRepository settingsRepository;

  @override
  State<ManuscriptSavedPage> createState() => _ManuscriptSavedPageState();
}

class _ManuscriptSavedPageState extends State<ManuscriptSavedPage> {
  late List<int> _bookmarkedPages;

  @override
  void initState() {
    super.initState();
    _bookmarkedPages = widget.settingsRepository.getManuscriptBookmarks();
  }

  void _removeBookmark(int pageNumber) {
    setState(() {
      _bookmarkedPages.remove(pageNumber);
      widget.settingsRepository.saveManuscriptBookmarks(_bookmarkedPages);
    });
  }

  void _openPage(int pageNumber) {
    Navigator.of(
      context,
    ).pushNamed(AppRoute.manuscript.path, arguments: pageNumber).then((
      Object? _,
    ) {
      if (mounted) {
        setState(() {
          _bookmarkedPages = widget.settingsRepository.getManuscriptBookmarks();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget contentBody;

    if (_bookmarkedPages.isEmpty) {
      contentBody = const ManuscriptSavedEmptyView();
    } else {
      contentBody = ListView.builder(
        itemCount: _bookmarkedPages.length,
        itemBuilder: (BuildContext context, int index) {
          final int pageNumber = _bookmarkedPages[index];
          return ManuscriptSavedItem(
            pageNumber: pageNumber,
            onTap: () => _openPage(pageNumber),
            onRemove: () => _removeBookmark(pageNumber),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(translate('manuscript.saved_pages'))),
      body: SafeArea(child: contentBody),
    );
  }
}
