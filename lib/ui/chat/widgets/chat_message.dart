import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:laozi_ai/application_services/blocs/chat/chat_bloc.dart';
import 'package:laozi_ai/entities/message.dart';
import 'package:laozi_ai/res/constants.dart' as constants;

class ChatMessage extends StatelessWidget {
  const ChatMessage({required this.message, super.key});

  final Message message;

  @override
  Widget build(BuildContext context) {
    const double laoziAvatarSize = 52.0;
    // Accessing the color scheme from the theme.
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color contentColor = message.isAi
        ? colorScheme.onSecondaryContainer
        : colorScheme.onPrimary;
    final TextTheme textTheme = Theme.of(context).textTheme.apply(
      bodyColor: contentColor,
      displayColor: contentColor,
      decorationColor: contentColor,
    );

    return Row(
      mainAxisAlignment: message.isAi
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: <Widget>[
        if (message.isAi)
          Image.asset(
            // Path to the image asset.
            constants.laoziAvatarPath,
            width: laoziAvatarSize,
            height: laoziAvatarSize,
          ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
            decoration: BoxDecoration(
              color: message.isAi
                  ? colorScheme.secondaryContainer
                  : colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: MarkdownBody(
              data: message.content
                  .toString()
                  // Replace escaped newlines with actual newlines.
                  .replaceAll(r'\n', '\n')
                  // Replace escaped quotes with actual quotes.
                  .replaceAll(r'\"', '"'),
              styleSheet:
                  MarkdownStyleSheet.fromTheme(
                    Theme.of(context).copyWith(textTheme: textTheme),
                  ).copyWith(
                    strong: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    em: textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                    listBullet: textTheme.bodyMedium,
                  ),
              selectable: true,
              onTapLink: (String _, String? href, String _) {
                context.read<ChatBloc>().add(LaunchUrlEvent(href ?? ''));
              },
            ),
          ),
        ),
      ],
    );
  }
}
