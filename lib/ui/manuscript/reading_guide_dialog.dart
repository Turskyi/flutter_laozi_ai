import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ReadingGuideDialog extends StatelessWidget {
  const ReadingGuideDialog({super.key});

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => const ReadingGuideDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Flat Header Row
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      translate('manuscript.guide.title'),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Diagram box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      translate('manuscript.guide.direction').toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildColumnBox(
                          context: context,
                          number: '3',
                          isPrimary: false,
                          colorScheme: colorScheme,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.arrow_back,
                            size: 18,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        _buildColumnBox(
                          context: context,
                          number: '2',
                          isPrimary: false,
                          colorScheme: colorScheme,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.arrow_back,
                            size: 18,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        _buildColumnBox(
                          context: context,
                          number: '1',
                          isPrimary: true,
                          colorScheme: colorScheme,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text(
                translate('manuscript.guide.p1'),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 12),
              Text(
                translate('manuscript.guide.p2'),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(translate('manuscript.guide.got_it')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumnBox({
    required BuildContext context,
    required String number,
    required bool isPrimary,
    required ColorScheme colorScheme,
  }) {
    final Color bgColor = isPrimary
        ? colorScheme.primaryContainer
        : colorScheme.surface;
    final Color textColor = isPrimary
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurfaceVariant;
    final Color borderColor = isPrimary
        ? colorScheme.primary
        : colorScheme.outlineVariant;

    return Container(
      width: 64,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isPrimary
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isPrimary
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            translate('manuscript.guide.col'),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text('│', style: TextStyle(fontSize: 10, color: textColor)),
          Text('│', style: TextStyle(fontSize: 10, color: textColor)),
          Icon(Icons.keyboard_arrow_down, size: 14, color: textColor),
        ],
      ),
    );
  }
}
