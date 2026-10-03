import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:laozi_ai/domain_services/settings_repository.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:laozi_ai/res/constants.dart';
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
      final String host = Uri.base.host.toLowerCase();
      final String fragment = Uri.base.fragment.toLowerCase();
      final String path = Uri.base.path.toLowerCase();
      final String? langParam =
          Uri.base.queryParameters[langParameter]?.toLowerCase() ??
          Uri.base.queryParameters[localeParameter]?.toLowerCase() ??
          Uri.base.queryParameters[hlParameter]?.toLowerCase();

      for (final Language language in Language.values) {
        final String currentLanguageCode = language.isoLanguageCode;

        final bool matchesHost = host.startsWith('$currentLanguageCode.');
        final bool matchesPath =
            path.startsWith('/$currentLanguageCode') ||
            path.contains('/$currentLanguageCode/');
        final bool matchesFragment = fragment.contains(
          '${AppRoute.home.path}$currentLanguageCode',
        );
        final bool matchesQuery = langParam == currentLanguageCode;

        if (matchesHost || matchesPath || matchesFragment || matchesQuery) {
          languageFromUrl = language;
          try {
            Intl.defaultLocale = currentLanguageCode;
          } catch (e) {
            // Silently ignore or log as needed.
          }
          break;
        } else {
          // Check next language.
        }
      }
    } else {
      // Not web environment.
    }

    if (languageFromUrl != null) {
      return languageFromUrl;
    } else {
      // Continue checking saved preferences.
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

  @override
  int getLastManuscriptPage() {
    final int? page = _preferences.getInt(Settings.lastManuscriptPage.key);
    if (page == null) {
      return 1;
    } else {
      return page;
    }
  }

  @override
  Future<bool> saveLastManuscriptPage(int page) {
    return _preferences.setInt(Settings.lastManuscriptPage.key, page);
  }

  @override
  List<int> getManuscriptBookmarks() {
    final List<String>? savedList = _preferences.getStringList(
      Settings.manuscriptBookmarks.key,
    );
    if (savedList == null) {
      return <int>[];
    } else {
      final List<int> bookmarks = <int>[];
      for (final String item in savedList) {
        final int? parsed = int.tryParse(item);
        if (parsed != null) {
          bookmarks.add(parsed);
        } else {
          // Handle invalid item
        }
      }
      bookmarks.sort();
      return bookmarks;
    }
  }

  @override
  Future<bool> saveManuscriptBookmarks(List<int> bookmarks) {
    final List<String> stringList = bookmarks
        .map((int page) => page.toString())
        .toList();
    return _preferences.setStringList(
      Settings.manuscriptBookmarks.key,
      stringList,
    );
  }
}
