part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {
  const SettingsEvent();
}

final class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

final class ChangeLanguageSettingsEvent extends SettingsEvent {
  const ChangeLanguageSettingsEvent(this.language);

  final Language language;
}

final class ChangeThemeModeSettingsEvent extends SettingsEvent {
  const ChangeThemeModeSettingsEvent(this.themeMode);

  final ThemeMode themeMode;
}
