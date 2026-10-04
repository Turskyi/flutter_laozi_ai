import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:laozi_ai/domain_services/settings_repository.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:laozi_ai/services/home_widget_service.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._settingsRepository, this._homeWidgetService)
    : super(
        SettingsState(
          language: _settingsRepository.getLanguage(),
          themeMode: _settingsRepository.getThemeMode(),
        ),
      ) {
    on<LoadSettingsEvent>(_onLoadSettingsEvent);
    on<ChangeLanguageSettingsEvent>(_onChangeLanguageSettingsEvent);
    on<ChangeThemeModeSettingsEvent>(_onChangeThemeModeSettingsEvent);
    _syncHomeWidgetLanguage(state.language);
  }

  final SettingsRepository _settingsRepository;
  final HomeWidgetService _homeWidgetService;

  int getLastManuscriptPage() {
    return _settingsRepository.getLastManuscriptPage();
  }

  void _syncHomeWidgetLanguage(Language language) {
    _homeWidgetService.updateHomeWidgetLanguage(language.isoLanguageCode);
  }

  FutureOr<void> _onLoadSettingsEvent(
    LoadSettingsEvent _,
    Emitter<SettingsState> emit,
  ) {
    final Language language = _settingsRepository.getLanguage();
    _syncHomeWidgetLanguage(language);
    emit(
      state.copyWith(
        language: language,
        themeMode: _settingsRepository.getThemeMode(),
      ),
    );
  }

  FutureOr<void> _onChangeLanguageSettingsEvent(
    ChangeLanguageSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final bool isSaved = await _settingsRepository.saveLanguageIsoCode(
      event.language.isoLanguageCode,
    );
    if (isSaved) {
      _syncHomeWidgetLanguage(event.language);
      emit(state.copyWith(language: event.language));
    } else {
      // Preference save failed.
    }
  }

  FutureOr<void> _onChangeThemeModeSettingsEvent(
    ChangeThemeModeSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final bool isSaved = await _settingsRepository.saveThemeMode(
      event.themeMode,
    );
    if (isSaved) {
      emit(state.copyWith(themeMode: event.themeMode));
    } else {
      // Preference save failed.
    }
  }
}
