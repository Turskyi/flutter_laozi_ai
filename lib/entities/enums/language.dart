/// [Language] is an `enum` object that contains all supported languages by
/// project.
enum Language {
  en(
    name: _englishLanguage,
    isoLanguageCode: _englishIsoLanguageCode,
    flag: '🇬🇧',
  ),
  uk(
    name: _ukrainianLanguage,
    isoLanguageCode: _ukrainianIsoLanguageCode,
    flag: '🇺🇦',
  ),
  lv(
    name: _latvianLanguage,
    isoLanguageCode: _latvianIsoLanguageCode,
    flag: '🇱🇻',
  );

  const Language({
    required this.name,
    required this.isoLanguageCode,
    required this.flag,
  });

  final String name;
  final String isoLanguageCode;
  final String flag;

  bool get isEnglish => this == Language.en;

  bool get isUkrainian => this == Language.uk;

  bool get isLatvian => this == Language.lv;

  static Language fromIsoLanguageCode(String isoLanguageCode) {
    switch (isoLanguageCode.trim().toLowerCase()) {
      case _englishIsoLanguageCode:
        return Language.en;
      case _ukrainianIsoLanguageCode:
        return Language.uk;
      case _latvianIsoLanguageCode:
        return Language.lv;
      default:
        return Language.en;
    }
  }
}

const String _englishIsoLanguageCode = 'en';
const String _ukrainianIsoLanguageCode = 'uk';
const String _latvianIsoLanguageCode = 'lv';
const String _englishLanguage = 'English';
const String _ukrainianLanguage = 'Ukrainian';
const String _latvianLanguage = 'Latvian';
