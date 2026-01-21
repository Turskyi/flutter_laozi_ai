part of 'settings_bloc.dart';

@immutable
class SettingsState {
  const SettingsState({required this.language, required this.themeMode});

  final Language language;
  final ThemeMode themeMode;

  SettingsState copyWith({Language? language, ThemeMode? themeMode}) =>
      SettingsState(
        language: language ?? this.language,
        themeMode: themeMode ?? this.themeMode,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsState &&
          runtimeType == other.runtimeType &&
          language == other.language &&
          themeMode == other.themeMode;

  @override
  int get hashCode => language.hashCode ^ themeMode.hashCode;
}
