enum HomeWidgetKey {
  selectedLanguage;

  String get stringValue {
    switch (this) {
      case HomeWidgetKey.selectedLanguage:
        return 'selected_language';
    }
  }
}
