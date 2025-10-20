import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/ui/faq/faq_item.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('faq_page.title')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const <Widget>[
          FaqItem(
            titleKey: 'faq_page.why_laozi_ai_title',
            paragraphKeys: <String>[
              'faq_page.why_laozi_ai_p1',
              'faq_page.why_laozi_ai_p2',
              'faq_page.why_laozi_ai_p3',
              'faq_page.why_laozi_ai_p4',
            ],
          ),
          FaqItem(
            titleKey: 'faq_page.inconsistent_chapters_title',
            paragraphKeys: <String>[
              'faq_page.inconsistent_chapters_p1',
              'faq_page.inconsistent_chapters_p2',
              'faq_page.inconsistent_chapters_p3',
            ],
          ),
          FaqItem(
            titleKey: 'faq_page.more_languages_title',
            paragraphKeys: <String>[
              'faq_page.more_languages_p1',
              'faq_page.more_languages_p2',
              'faq_page.more_languages_p3',
            ],
          ),
          FaqItem(
            titleKey: 'faq_page.short_answers_title',
            paragraphKeys: <String>[
              'faq_page.short_answers_p1',
              'faq_page.short_answers_p2',
              'faq_page.short_answers_p3',
            ],
          ),
          FaqItem(
            titleKey: 'faq_page.different_answers_title',
            paragraphKeys: <String>[
              'faq_page.different_answers_p1',
              'faq_page.different_answers_p2',
              'faq_page.different_answers_p3',
            ],
          ),
          FaqItem(
            titleKey: 'faq_page.gateway_timeout_title',
            paragraphKeys: <String>[
              'faq_page.gateway_timeout_p1',
              'faq_page.gateway_timeout_p2',
            ],
          ),
        ],
      ),
    );
  }
}
