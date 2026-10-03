import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:laozi_ai/application_services/blocs/chat/chat_bloc.dart';
import 'package:laozi_ai/entities/message.dart';
import 'package:laozi_ai/res/constants.dart' as constants;
import 'package:laozi_ai/router/app_route.dart';
import 'package:laozi_ai/ui/manuscript/manuscript_data.dart';

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MarkdownBody(
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
                    final Uri? uri = Uri.tryParse(href ?? '');
                    final String? host = uri?.host.toLowerCase();
                    final String domain = constants.primaryDomain;
                    final bool isAllowedDomain =
                        host == domain ||
                        (host != null && host.endsWith('.$domain'));
                    final bool isManuscriptRoute =
                        uri?.pathSegments.length == 2 &&
                        uri?.pathSegments.firstOrNull ==
                            AppRoute.manuscript.name;
                    final bool isManuscript =
                        isAllowedDomain && isManuscriptRoute;

                    final String? pageSegment = uri?.pathSegments.lastOrNull;
                    if (pageSegment != null) {
                      final int? page = isManuscript
                          ? int.tryParse(pageSegment)
                          : null;

                      if (page != null &&
                          page >= kMinManuscriptPage &&
                          page <= kMaxManuscriptPage) {
                        Navigator.of(
                          context,
                        ).pushNamed(AppRoute.manuscript.path, arguments: page);
                      } else {
                        context.read<ChatBloc>().add(
                          LaunchUrlEvent(href ?? ''),
                        );
                      }
                    } else {
                      context.read<ChatBloc>().add(LaunchUrlEvent(href ?? ''));
                    }
                  },
                ),
                if (message.isAi && message.aiModel != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      message.aiModel ?? '',
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: contentColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
