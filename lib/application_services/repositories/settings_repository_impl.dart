import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:laozi_ai/domain_services/settings_repository.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:laozi_ai/res/enums/settings.dart';
import 'package:laozi_ai/router/app_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._preferences);

  final SharedPreferences _preferences;

  @override
  Language getLanguage() {
    final String? savedLanguageIsoCode = _preferences.getString(
      Settings.languageIsoCode.key,
    );

    final bool isSavedLanguageSupported =
        savedLanguageIsoCode != null &&
        Language.values.any(
          (Language lang) => lang.isoLanguageCode == savedLanguageIsoCode,
        );

    final String systemLanguageCode =
        PlatformDispatcher.instance.locale.languageCode;

    String defaultLanguageCode =
        Language.values.any(
          (Language lang) => lang.isoLanguageCode == systemLanguageCode,
        )
        ? systemLanguageCode
        : Language.en.isoLanguageCode;

    // Retrieves the host name (e.g., "localhost" or "uk.daoizm.online").
    final String host = Uri.base.host;
    // Retrieves the fragment (e.g., "/en" or "/uk").
    final String fragment = Uri.base.fragment;
    for (final Language language in Language.values) {
      final String currentLanguageCode = language.isoLanguageCode;

      if (host.startsWith('$currentLanguageCode.') ||
          fragment.contains('${AppRoute.home.path}$currentLanguageCode')) {
        try {
          Intl.defaultLocale = currentLanguageCode;
        } catch (e, stackTrace) {
          debugPrint(
            'Failed to set Intl.defaultLocale to "$currentLanguageCode".\n'
            'Error: $e\n'
            'StackTrace: $stackTrace\n'
            'Proceeding with previously set default locale or system default.',
          );
        }
        defaultLanguageCode = currentLanguageCode;
        // Exit the loop once a match is found and processed.
        break;
      }
    }

    final String finalIsoCode = isSavedLanguageSupported
        ? savedLanguageIsoCode
        : defaultLanguageCode;

    return Language.fromIsoLanguageCode(finalIsoCode);
  }

  @override
  Future<bool> saveLanguageIsoCode(String languageIsoCode) {
    return _preferences.setString(
      Settings.languageIsoCode.key,
      languageIsoCode,
    );
  }

  @override
  ThemeMode getThemeMode() {
    final String? savedThemeMode = _preferences.getString(
      Settings.themeMode.key,
    );

    if (savedThemeMode == null) {
      return ThemeMode.dark;
    }

    return ThemeMode.values.firstWhere(
      (ThemeMode mode) => mode.name == savedThemeMode,
      orElse: () => ThemeMode.dark,
    );
  }

  @override
  Future<bool> saveThemeMode(ThemeMode themeMode) {
    return _preferences.setString(Settings.themeMode.key, themeMode.name);
  }
}
