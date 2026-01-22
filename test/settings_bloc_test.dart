import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laozi_ai/application_services/blocs/settings_bloc.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_settings_repository.dart';

void main() {
  late MockSettingsRepository mockSettingsRepository;

  setUpAll(() {
    registerFallbackValue(ThemeMode.dark);
    registerFallbackValue(Language.en);
  });

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
  });

  group('SettingsBloc', () {
    blocTest<SettingsBloc, SettingsState>(
      'initial state is correct',
      build: () {
        when(
          () => mockSettingsRepository.getLanguage(),
        ).thenReturn(Language.en);
        when(
          () => mockSettingsRepository.getThemeMode(),
        ).thenReturn(ThemeMode.dark);
        return SettingsBloc(mockSettingsRepository);
      },
      verify: (SettingsBloc bloc) {
        expect(bloc.state.language, Language.en);
        expect(bloc.state.themeMode, ThemeMode.dark);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'emits updated state when ChangeLanguageSettingsEvent is added',
      build: () {
        when(
          () => mockSettingsRepository.getLanguage(),
        ).thenReturn(Language.en);
        when(
          () => mockSettingsRepository.getThemeMode(),
        ).thenReturn(ThemeMode.dark);
        when(
          () => mockSettingsRepository.saveLanguageIsoCode(any()),
        ).thenAnswer((_) async => true);
        return SettingsBloc(mockSettingsRepository);
      },
      act: (SettingsBloc bloc) =>
          bloc.add(const ChangeLanguageSettingsEvent(Language.uk)),
      expect: () => <TypeMatcher<SettingsState>>[
        isA<SettingsState>().having(
          (SettingsState s) => s.language,
          'language',
          Language.uk,
        ),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'emits updated state when ChangeThemeModeSettingsEvent is added',
      build: () {
        when(
          () => mockSettingsRepository.getLanguage(),
        ).thenReturn(Language.en);
        when(
          () => mockSettingsRepository.getThemeMode(),
        ).thenReturn(ThemeMode.dark);
        when(
          () => mockSettingsRepository.saveThemeMode(any()),
        ).thenAnswer((_) async => true);
        return SettingsBloc(mockSettingsRepository);
      },
      act: (SettingsBloc bloc) =>
          bloc.add(const ChangeThemeModeSettingsEvent(ThemeMode.light)),
      expect: () => <TypeMatcher<SettingsState>>[
        isA<SettingsState>().having(
          (SettingsState s) => s.themeMode,
          'themeMode',
          ThemeMode.light,
        ),
      ],
    );
  });
}
