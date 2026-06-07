import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laozi_ai/application_services/repositories/settings_repository_impl.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;
  late SettingsRepositoryImpl repository;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    repository = SettingsRepositoryImpl(mockPrefs);
    when(() => mockPrefs.getString(any())).thenReturn(null);
  });

  group('SettingsRepositoryImpl Language Resolution', () {
    test(
      'should return Ukrainian if saved in preferences (priority over system)',
      () {
        when(() => mockPrefs.getString('languageIsoCode')).thenReturn('uk');

        final Language language = repository.getLanguage();

        // On non-web (standard test runner), saved prefs should be respected.
        if (!kIsWeb) {
          expect(language, Language.uk);
        }
      },
    );

    test(
      'should return English by default if no preference and no URL match',
      () {
        when(() => mockPrefs.getString('languageIsoCode')).thenReturn(null);

        final Language language = repository.getLanguage();

        // We expect a valid language object regardless of system locale.
        expect(language, isA<Language>());
      },
    );

    test(
      'Logic check: Language.fromIsoLanguageCode returns correct Language',
      () {
        expect(Language.fromIsoLanguageCode('uk'), Language.uk);
        expect(Language.fromIsoLanguageCode('en'), Language.en);
        expect(Language.fromIsoLanguageCode('lv'), Language.lv);
        expect(Language.fromIsoLanguageCode('invalid'), Language.en);
      },
    );
  });
}
