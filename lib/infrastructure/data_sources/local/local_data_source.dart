import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:laozi_ai/res/enums/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  const LocalDataSource(this._preferences);

  final SharedPreferences _preferences;

  Future<bool> saveLanguageIsoCode(String languageIsoCode) {
    final bool isSupported = Language.values.any(
      (Language lang) => lang.isoLanguageCode == languageIsoCode,
    );

    final String safeLanguageCode =
        isSupported ? languageIsoCode : Language.en.isoLanguageCode;

    return _preferences.setString(
      Settings.languageIsoCode.key,
      safeLanguageCode,
    );
  }

  String getLanguageIsoCode() {
    final String? savedLanguageIsoCode = _preferences.getString(
      Settings.languageIsoCode.key,
    );

    final bool isSavedLanguageSupported = savedLanguageIsoCode != null &&
        Language.values.any(
          (Language lang) => lang.isoLanguageCode == savedLanguageIsoCode,
        );

    final String systemLanguageCode =
        PlatformDispatcher.instance.locale.languageCode;

    String defaultLanguageCode = Language.values.any(
      (Language lang) => lang.isoLanguageCode == systemLanguageCode,
    )
        ? systemLanguageCode
        : Language.en.isoLanguageCode;

    final String host = Uri.base.host;
    if (host.startsWith('${Language.uk.isoLanguageCode}.')) {
      try {
        Intl.defaultLocale = Language.uk.isoLanguageCode;
      } catch (e, stackTrace) {
        debugPrint(
          'Failed to set Intl.defaultLocale to '
          '"${Language.uk.isoLanguageCode}".\n'
          'Error: $e\n'
          'StackTrace: $stackTrace\n'
          'Proceeding with previously set default locale or system default.',
        );
      }
      defaultLanguageCode = Language.uk.isoLanguageCode;
    }

    return isSavedLanguageSupported
        ? savedLanguageIsoCode
        : defaultLanguageCode;
  }
}
