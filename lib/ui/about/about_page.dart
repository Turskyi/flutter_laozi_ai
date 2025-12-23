import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:laozi_ai/res/constants.dart' as constants;
import 'package:laozi_ai/ui/about/widgets/bullet_point.dart';
import 'package:laozi_ai/ui/widgets/home_app_bar_button.dart';

const double _kYinYangImageSize = 180.0;

class AboutPage extends StatefulWidget {
  const AboutPage({required this.initialLanguage, super.key});

  final Language initialLanguage;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
    final Language currentLanguage = Language.fromIsoLanguageCode(
      LocalizedApp.of(context).delegate.currentLocale.languageCode,
    );
    final Language savedLanguage = widget.initialLanguage;
    if (currentLanguage != savedLanguage) {
      changeLocale(context, savedLanguage.isoLanguageCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: kIsWeb
            ? HomeAppBarButton(language: widget.initialLanguage)
            : null,
        title: Text(translate('about_page.title')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              translate(
                'about_page.welcome',
                args: <String, Object?>{'domain': constants.primaryDomain},
              ),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              translate(
                'about_page.platform_description',
                args: <String, Object?>{'domain': constants.primaryDomain},
              ),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Text(
              translate('about_page.laozi_description'),
              style: theme.textTheme.bodyLarge,
            ),
            const Divider(height: 32),
            Text(
              translate('about_page.philosophy_title'),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              translate('about_page.daoism_description'),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Text(
              translate('about_page.laozi_quote'),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              translate('about_page.tao_te_ching_warning'),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              translate('about_page.core_principles_title'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            BulletPoint(text: translate('about_page.wu_wei')),
            BulletPoint(text: translate('about_page.ziran')),
            BulletPoint(text: translate('about_page.three_treasures')),
            BulletPoint(text: translate('about_page.yin_yang')),
            BulletPoint(text: translate('about_page.practices')),
            const SizedBox(height: 16),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(120),
                child: Image.asset(
                  '${constants.imageAssetsPath}yinyang.png',
                  width: _kYinYangImageSize,
                  height: _kYinYangImageSize,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              translate('about_page.paradox_humor'),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              translate('about_page.influence'),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text(
              translate('about_page.chatbot_title'),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              translate('about_page.chatbot_description'),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              translate('about_page.digital_garden'),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                translate('about_page.eternal_dao_quote'),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.hintColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
