abstract interface class HomeWidgetService {
  const HomeWidgetService();

  Future<void> setAppGroupId(String appGroupId);

  Future<bool?> saveWidgetData<T>(String id, T? data);

  Future<bool?> updateWidget({
    String? name,
    String? androidName,
    String? iOSName,
    String? qualifiedAndroidName,
  });

  Future<void> updateHomeWidgetLanguage(String languageCode);

  Future<void> requestPinWidget({
    String? name,
    String? androidName,
    String? qualifiedAndroidName,
  });
}
