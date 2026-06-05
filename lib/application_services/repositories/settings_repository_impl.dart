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
    // 1. Check for URL-based language first (priority for Web).
    Language? languageFromUrl;
    if (kIsWeb) {
      // Retrieves the host name (e.g., "localhost" or "uk.daoismonline.com").
      final String host = Uri.base.host;
      // Retrieves the fragment (e.g., "/en" or "/uk").
      final String fragment = Uri.base.fragment;
      for (final Language language in Language.values) {
        final String currentLanguageCode = language.isoLanguageCode;

        if (host.startsWith('$currentLanguageCode.') ||
            fragment.contains('${AppRoute.home.path}$currentLanguageCode')) {
          languageFromUrl = language;
          try {
            Intl.defaultLocale = currentLanguageCode;
          } catch (e) {
            // Silently ignore or log as needed.
          }
          break;
        }
      }
    }

    if (languageFromUrl != null) {
      return languageFromUrl;
    }

    // 2. Check for saved language in preferences.
    final String? savedLanguageIsoCode = _preferences.getString(
      Settings.languageIsoCode.key,
    );

    if (savedLanguageIsoCode != null) {
      final Language savedLanguage = Language.values.firstWhere(
        (Language lang) => lang.isoLanguageCode == savedLanguageIsoCode,
        orElse: () => Language.en,
      );
      return savedLanguage;
    }

    // 3. Fallback to system language or default to English.
    final String systemLanguageCode =
        PlatformDispatcher.instance.locale.languageCode;

    return Language.fromIsoLanguageCode(systemLanguageCode);
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
