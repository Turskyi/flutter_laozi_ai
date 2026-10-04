import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ManuscriptSearchBar extends StatelessWidget {
  const ManuscriptSearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        autofocus: true,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: translate('manuscript.search_hint'),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: translate('manuscript.clear_search'),
                  onPressed: onClear,
                )
              : null,
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
