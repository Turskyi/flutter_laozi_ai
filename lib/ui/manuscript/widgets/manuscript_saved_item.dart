import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/ui/manuscript/manuscript_data.dart';

class ManuscriptSavedItem extends StatelessWidget {
  const ManuscriptSavedItem({
    required this.pageNumber,
    required this.onTap,
    required this.onRemove,
    super.key,
  });

  final int pageNumber;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final ManuscriptPageData pageData = getManuscriptPageData(pageNumber);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Text(
            '$pageNumber',
            style: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          pageData.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          '${translate('manuscript.page')} '
          '$pageNumber - '
          '${pageData.shortTitle}',
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: translate('manuscript.remove_bookmark'),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
