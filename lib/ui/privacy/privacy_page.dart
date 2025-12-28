import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:laozi_ai/res/constants.dart' as constants;
import 'package:laozi_ai/ui/privacy/widgets/privacy_section.dart';
import 'package:laozi_ai/ui/widgets/home_app_bar_button.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({required this.initialLanguage, super.key});

  final Language initialLanguage;

  @override
  Widget build(BuildContext context) {
    final bool isAndroid =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    final String privacyKey = isAndroid
        ? 'privacy_page_android'
        : 'privacy_page';
    final String appName = constants.appName;
    const String date = 'June 2024';
    const String email = 'support@${constants.primaryDomain}';

    return Scaffold(
      appBar: AppBar(
        leading: kIsWeb ? HomeAppBarButton(language: initialLanguage) : null,
        title: Text(
          translate(
            isAndroid ? 'privacy_page_android.title' : 'privacy_page.title',
            args: <String, Object?>{'appName': appName},
          ),
          maxLines: 2,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              translate(
                '$privacyKey.last_updated',
                args: <String, Object?>{'date': date},
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            PrivacySection(
              pageKey: privacyKey,
              sectionKey: 'introduction',
              appName: appName,
            ),
            PrivacySection(
              pageKey: privacyKey,
              sectionKey: 'information_we_collect',
              aiModelName: constants.googleAiModelName,
            ),
            if (!isAndroid) ...<Widget>[
              PrivacySection(pageKey: privacyKey, sectionKey: 'log_files'),
              PrivacySection(
                pageKey: privacyKey,
                sectionKey: 'contact_information',
              ),
              PrivacySection(
                pageKey: privacyKey,
                sectionKey: 'mobile_app_usage_data',
              ),
            ],
            PrivacySection(
              pageKey: privacyKey,
              sectionKey: 'use_of_information',
            ),
            if (!isAndroid)
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '• ${translate('$privacyKey.'
                      'use_of_information_list_item_1')}',
                    ),
                    Text(
                      '• ${translate('$privacyKey.'
                      'use_of_information_list_item_2')}',
                    ),
                    Text(
                      '• ${translate('$privacyKey.'
                      'use_of_information_list_item_3')}',
                    ),
                  ],
                ),
              ),
            PrivacySection(
              pageKey: privacyKey,
              sectionKey: 'information_sharing_and_disclosure',
            ),
            PrivacySection(pageKey: privacyKey, sectionKey: 'security'),
            PrivacySection(
              pageKey: privacyKey,
              sectionKey: 'changes_to_this_privacy_policy',
              date: date,
            ),
            PrivacySection(
              pageKey: privacyKey,
              sectionKey: 'contact_us',
              email: email,
            ),
          ],
        ),
      ),
    );
  }
}
