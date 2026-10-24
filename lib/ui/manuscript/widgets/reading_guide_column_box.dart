import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ReadingGuideColumnBox extends StatelessWidget {
  const ReadingGuideColumnBox({
    required this.number,
    required this.isPrimary,
    super.key,
  });

  final String number;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final Color bgColor = isPrimary
        ? colorScheme.primaryContainer
        : colorScheme.surface;
    final Color textColor = isPrimary
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurfaceVariant;
    final Color borderColor = isPrimary
        ? colorScheme.primary
        : colorScheme.outlineVariant;
    final Color numberBgColor = isPrimary
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;
    final Color numberTextColor = isPrimary
        ? colorScheme.onPrimary
        : colorScheme.onSurface;

    return Container(
      width: _kColumnBoxWidth,
      padding: const EdgeInsets.symmetric(
        vertical: _kColumnBoxVerticalPadding,
        horizontal: _kColumnBoxHorizontalPadding,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(_kColumnBoxRadius),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: _kColumnNumberBoxSize,
            height: _kColumnNumberBoxSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: numberBgColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: numberTextColor,
              ),
            ),
          ),
          const SizedBox(height: _kColumnSpacingMedium),
          Text(
            translate(_kGuideColKey),
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: _kColumnSpacingSmall),
          Text(
            _kVerticalLineSymbol,
            style: textTheme.labelSmall?.copyWith(color: textColor),
          ),
          Text(
            _kVerticalLineSymbol,
            style: textTheme.labelSmall?.copyWith(color: textColor),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            size: _kDownArrowIconSize,
            color: textColor,
          ),
        ],
      ),
    );
  }
}

const double _kColumnBoxWidth = 64.0;
const double _kColumnBoxRadius = 10.0;
const double _kColumnBoxVerticalPadding = 10.0;
const double _kColumnBoxHorizontalPadding = 6.0;
const double _kColumnNumberBoxSize = 22.0;
const double _kColumnSpacingSmall = 2.0;
const double _kColumnSpacingMedium = 6.0;
const double _kDownArrowIconSize = 14.0;
const String _kGuideColKey = 'manuscript.guide.col';
const String _kVerticalLineSymbol = '│';
