import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/res/constants.dart' as constants;
import 'package:laozi_ai/ui/faq/faq_item.dart';
import 'package:laozi_ai/ui/widgets/app_bar/wave_app_bar.dart';
import 'package:laozi_ai/ui/widgets/home_app_bar_button.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: WaveAppBar(
        leading: kIsWeb ? const HomeAppBarButton() : null,
        title: translate('faq_page.title'),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16.0,
          kToolbarHeight + MediaQuery.of(context).padding.top,
          16.0,
          16.0,
        ),
        children: <Widget>[
          const FaqItem(
            titleKey: 'faq_page.why_laozi_ai_title',
            paragraphKeys: <String>[
              'faq_page.why_laozi_ai_p1',
              'faq_page.why_laozi_ai_p2',
              'faq_page.why_laozi_ai_p3',
              'faq_page.why_laozi_ai_p4',
            ],
          ),
          const FaqItem(
            titleKey: 'faq_page.inconsistent_chapters_title',
            paragraphKeys: <String>[
              'faq_page.inconsistent_chapters_p1',
              'faq_page.inconsistent_chapters_p2',
              'faq_page.inconsistent_chapters_p3',
            ],
          ),
          const FaqItem(
            titleKey: 'faq_page.more_languages_title',
            paragraphKeys: <String>[
              'faq_page.more_languages_p1',
              'faq_page.more_languages_p2',
              'faq_page.more_languages_p3',
            ],
          ),
          const FaqItem(
            titleKey: 'faq_page.short_answers_title',
            paragraphKeys: <String>[
              'faq_page.short_answers_p1',
              'faq_page.short_answers_p2',
              'faq_page.short_answers_p3',
            ],
          ),
          const FaqItem(
            titleKey: 'faq_page.clarify_rephrase_title',
            paragraphKeys: <String>[
              'faq_page.clarify_rephrase_p1',
              'faq_page.clarify_rephrase_p2',
            ],
          ),
          const FaqItem(
            titleKey: 'faq_page.different_answers_title',
            paragraphKeys: <String>[
              'faq_page.different_answers_p1',
              'faq_page.different_answers_p2',
              'faq_page.different_answers_p3',
            ],
          ),
          const FaqItem(
            titleKey: 'faq_page.gateway_timeout_title',
            paragraphKeys: <String>[
              'faq_page.gateway_timeout_p1',
              'faq_page.gateway_timeout_p2',
            ],
          ),
          const FaqItem(
            titleKey: 'faq_page.chat_history_title',
            paragraphKeys: <String>[
              'faq_page.chat_history_p1',
              'faq_page.chat_history_p2',
            ],
          ),
          FaqItem(
            titleKey: 'faq_page.slow_responses_title',
            paragraphKeys: const <String>['faq_page.slow_responses_p1'],
            // The second paragraph contains an email address that should be
            // clickable, so we need to handle it separately.
            customContent: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Builder(
                builder: (BuildContext context) {
                  final String text = translate('faq_page.slow_responses_p2');
                  // We expect the text to contain the email address.
                  // For simplicity, we'll split by the email or just find it.
                  // Since the text is known:
                  // "... email to dmytro@turskyi.com."
                  const String email = constants.kDeveloperEmail;
                  final List<String> parts = text.split(email);
                  final ThemeData theme = Theme.of(context);
                  final TextStyle? textStyle = theme.textTheme.bodyLarge;
                  if (parts.length < 2) {
                    return Text(text, style: textStyle);
                  }

                  return RichText(
                    text: TextSpan(
                      style: textStyle,
                      children: <InlineSpan>[
                        TextSpan(text: parts.first),
                        TextSpan(
                          text: email,
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final Uri emailLaunchUri = Uri(
                                scheme: constants.kMailToScheme,
                                path: email,
                              );
                              if (await canLaunchUrl(emailLaunchUri)) {
                                await launchUrl(emailLaunchUri);
                              }
                            },
                        ),
                        if (parts.length > 1) TextSpan(text: parts[1]),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
