import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:laozi_ai/domain_services/settings_repository.dart';
import 'package:laozi_ai/entities/enums/language.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._settingsRepository)
    : super(
        SettingsState(
          language: _settingsRepository.getLanguage(),
          themeMode: _settingsRepository.getThemeMode(),
        ),
      ) {
    on<LoadSettingsEvent>(_onLoadSettingsEvent);
    on<ChangeLanguageSettingsEvent>(_onChangeLanguageSettingsEvent);
    on<ChangeThemeModeSettingsEvent>(_onChangeThemeModeSettingsEvent);
  }

  final SettingsRepository _settingsRepository;

  FutureOr<void> _onLoadSettingsEvent(
    LoadSettingsEvent _,
    Emitter<SettingsState> emit,
  ) {
    emit(
      state.copyWith(
        language: _settingsRepository.getLanguage(),
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
      emit(state.copyWith(language: event.language));
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
    }
  }
}
