/// [Language] is an `enum` object that contains all supported languages by
/// project.
enum Language {
  en(
    key: _englishLanguage,
    isoLanguageCode: _englishIsoLanguageCode,
    flag: '🇬🇧',
  ),
  uk(
    key: _ukrainianLanguage,
    isoLanguageCode: _ukrainianIsoLanguageCode,
    flag: '🇺🇦',
  ),
  lv(
    key: _latvianLanguage,
    isoLanguageCode: _latvianIsoLanguageCode,
    flag: '🇱🇻',
  );

  const Language({
    required this.key,
    required this.isoLanguageCode,
    required this.flag,
  });

  final String key;
  final String isoLanguageCode;
  final String flag;

  bool get isEnglish => this == Language.en;

  bool get isUkrainian => this == Language.uk;

  bool get isLatvian => this == Language.lv;

  bool get isNotLatvian => !isLatvian;

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
const String _englishLanguage = 'english';
const String _ukrainianLanguage = 'ukrainian';
const String _latvianLanguage = 'latvian';
