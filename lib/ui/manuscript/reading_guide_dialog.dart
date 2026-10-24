import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/ui/manuscript/widgets/reading_guide_column_box.dart';

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
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_kDialogBorderRadius),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: _kDialogMaxWidth),
        padding: const EdgeInsets.all(_kDialogPadding),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(_kHeaderIconPadding),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(_kHeaderIconRadius),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: _kHeaderTitleSpacing),
                  Expanded(
                    child: Text(
                      translate(_kGuideTitleKey),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: _kSectionSpacing),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(_kDiagramPadding),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: _kDiagramOpacity,
                  ),
                  borderRadius: BorderRadius.circular(_kDiagramRadius),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(
                      alpha: _kDiagramBorderOpacity,
                    ),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      translate(_kGuideDirectionKey).toUpperCase(),
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                        letterSpacing: _kDirectionLetterSpacing,
                      ),
                    ),
                    const SizedBox(height: _kDirectionSpacing),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const ReadingGuideColumnBox(
                            number: _kColumnNumber3,
                            isPrimary: false,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: _kArrowPaddingHorizontal,
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              size: _kArrowIconSize,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const ReadingGuideColumnBox(
                            number: _kColumnNumber2,
                            isPrimary: false,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: _kArrowPaddingHorizontal,
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              size: _kArrowIconSize,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const ReadingGuideColumnBox(
                            number: _kColumnNumber1,
                            isPrimary: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: _kDiagramPadding),

              Text(
                translate(_kGuideP1Key),
                style: textTheme.bodySmall?.copyWith(height: _kTextLineHeight),
              ),
              const SizedBox(height: _kParagraphSpacing),
              Text(
                translate(_kGuideP2Key),
                style: textTheme.bodySmall?.copyWith(height: _kTextLineHeight),
              ),
              const SizedBox(height: _kSectionSpacing),

              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(translate(_kGuideGotItKey)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const double _kDialogBorderRadius = 20.0;
const double _kDialogMaxWidth = 500.0;
const double _kDialogPadding = 24.0;
const double _kHeaderIconPadding = 8.0;
const double _kHeaderIconRadius = 12.0;
const double _kHeaderTitleSpacing = 12.0;
const double _kSectionSpacing = 20.0;
const double _kDiagramPadding = 16.0;
const double _kDiagramRadius = 16.0;
const double _kDiagramOpacity = 0.5;
const double _kDiagramBorderOpacity = 0.5;
const double _kDirectionSpacing = 16.0;
const double _kDirectionLetterSpacing = 0.8;
const double _kArrowIconSize = 18.0;
const double _kArrowPaddingHorizontal = 8.0;
const double _kParagraphSpacing = 12.0;
const double _kTextLineHeight = 1.5;

const String _kGuideTitleKey = 'manuscript.guide.title';
const String _kGuideDirectionKey = 'manuscript.guide.direction';
const String _kGuideP1Key = 'manuscript.guide.p1';
const String _kGuideP2Key = 'manuscript.guide.p2';
const String _kGuideGotItKey = 'manuscript.guide.got_it';
const String _kColumnNumber3 = '3';
const String _kColumnNumber2 = '2';
const String _kColumnNumber1 = '1';
