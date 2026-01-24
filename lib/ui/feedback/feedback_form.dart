import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/application_services/blocs/settings/settings_bloc.dart';
import 'package:laozi_ai/entities/enums/feedback_rating.dart';
import 'package:laozi_ai/entities/enums/feedback_type.dart';
import 'package:laozi_ai/entities/feedback_details.dart';
import 'package:laozi_ai/res/app_theme.dart';

/// A form that prompts the user for the type of feedback they want to give,
/// free form text feedback, and a sentiment rating.
/// The submit button is disabled until the user provides the feedback type. All
/// other fields are optional.
class FeedbackForm extends StatefulWidget {
  const FeedbackForm({
    required this.onSubmit,
    required this.scrollController,
    super.key,
  });

  final OnSubmit onSubmit;
  final ScrollController? scrollController;

  @override
  State<FeedbackForm> createState() => _CustomFeedbackFormState();
}

class _CustomFeedbackFormState extends State<FeedbackForm> {
  FeedbackDetails _customFeedback = const FeedbackDetails();

  @override
  Widget build(BuildContext context) {
    // We watch the settings bloc to get the correct theme mode, because
    // this widget is a child of BetterFeedback which is outside MaterialApp.
    final SettingsState settingsState = context.watch<SettingsBloc>().state;
    final Brightness brightness = settingsState.isDark
        ? Brightness.dark
        : Brightness.light;
    final ThemeData theme = createAppTheme(brightness);
    final ColorScheme colorScheme = theme.colorScheme;

    return Theme(
      data: theme,
      child: DefaultTextStyle(
        style: TextStyle(color: colorScheme.onSurface),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  if (widget.scrollController != null)
                    const FeedbackSheetDragHandle(),
                  ListView(
                    controller: widget.scrollController,
                    // Pad the top by 20 to match the corner radius if drag
                    // enabled.
                    padding: EdgeInsets.fromLTRB(
                      16,
                      widget.scrollController != null ? 20 : 16,
                      16,
                      0,
                    ),
                    children: <Widget>[
                      Text(
                        translate('feedback.whatKind'),
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              '*',
                              style: TextStyle(color: colorScheme.onSurface),
                            ),
                          ),
                          Flexible(
                            child: DropdownButton<FeedbackType>(
                              value: _customFeedback.feedbackType,
                              dropdownColor: colorScheme.surface,
                              style: TextStyle(color: colorScheme.onSurface),
                              items: FeedbackType.values
                                  .map(
                                    (FeedbackType type) =>
                                        DropdownMenuItem<FeedbackType>(
                                          value: type,
                                          child: Text(type.value),
                                        ),
                                  )
                                  .toList(),
                              onChanged: (FeedbackType? feedbackType) =>
                                  setState(
                                    () => _customFeedback = _customFeedback
                                        .copyWith(feedbackType: feedbackType),
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        translate('feedback.whatIsYourFeedback'),
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                      TextField(
                        style: TextStyle(color: colorScheme.onSurface),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        onChanged: (String newFeedback) => _customFeedback =
                            _customFeedback.copyWith(feedbackText: newFeedback),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        translate('feedback.howDoesThisFeel'),
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: FeedbackRating.values
                            .map(
                              (FeedbackRating rating) =>
                                  _ratingToIcon(rating, colorScheme),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            TextButton(
              // Disable this button until the user has specified a feedback
              // type.
              onPressed: _customFeedback.feedbackType != null
                  ? () => widget.onSubmit(
                      _customFeedback.feedbackText ?? '',
                      extras: _customFeedback.toMap(),
                    )
                  : null,
              child: Text(translate('submit')),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _ratingToIcon(FeedbackRating rating, ColorScheme colorScheme) {
    final bool isSelected = _customFeedback.rating == rating;
    late IconData icon;
    switch (rating) {
      case FeedbackRating.bad:
        icon = Icons.sentiment_dissatisfied;
        break;
      case FeedbackRating.neutral:
        icon = Icons.sentiment_neutral;
        break;
      case FeedbackRating.good:
        icon = Icons.sentiment_satisfied;
        break;
    }
    return IconButton(
      color: isSelected ? colorScheme.primary : colorScheme.outline,
      onPressed: () => setState(
        () => _customFeedback = _customFeedback.copyWith(rating: rating),
      ),
      icon: Icon(icon),
      iconSize: 36,
    );
  }
}
