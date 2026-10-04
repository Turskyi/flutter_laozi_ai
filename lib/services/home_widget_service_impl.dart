import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:injectable/injectable.dart';
import 'package:laozi_ai/res/constants.dart' as constants;
import 'package:laozi_ai/res/home_widget_keys.dart';
import 'package:laozi_ai/services/home_widget_service.dart';

@Injectable(as: HomeWidgetService)
class HomeWidgetServiceImpl implements HomeWidgetService {
  const HomeWidgetServiceImpl();

  static const MethodChannel _widgetChannel = MethodChannel(
    constants.kHomeWidgetMethodChannel,
  );

  @override
  Future<void> setAppGroupId(String appGroupId) {
    if (kIsWeb) {
      return Future<void>.value();
    } else if (Platform.isMacOS) {
      return _widgetChannel.invokeMethod<void>(
        constants.kSetAppGroupIdMethod,
        <String, String>{constants.kAppGroupIdArgKey: appGroupId},
      );
    } else {
      return HomeWidget.setAppGroupId(appGroupId);
    }
  }

  @override
  Future<bool?> saveWidgetData<T>(String id, T? data) {
    if (kIsWeb) {
      return Future<bool>.value(false);
    } else if (Platform.isMacOS) {
      return _widgetChannel.invokeMethod<bool>(
        constants.kSaveWidgetDataMethod,
        <String, Object?>{
          'key': id,
          'value': data,
          constants.kAppGroupIdArgKey: constants.kAppleAppGroupId,
        },
      );
    } else {
      return HomeWidget.saveWidgetData<T>(id, data);
    }
  }

  @override
  Future<bool?> updateWidget({
    String? name,
    String? androidName,
    String? iOSName,
    String? qualifiedAndroidName,
  }) {
    if (kIsWeb) {
      return Future<bool>.value(false);
    } else if (Platform.isMacOS) {
      return _widgetChannel.invokeMethod<bool>(constants.kUpdateWidgetMethod);
    } else {
      return HomeWidget.updateWidget(
        name: name,
        iOSName: iOSName,
        androidName: androidName,
        qualifiedAndroidName: qualifiedAndroidName,
      );
    }
  }

  @override
  Future<void> updateHomeWidgetLanguage(String languageCode) async {
    await setAppGroupId(constants.kAppleAppGroupId);
    await saveWidgetData<String>(
      HomeWidgetKey.selectedLanguage.stringValue,
      languageCode,
    );
    await updateWidget(
      iOSName: constants.kIosWidgetName,
      androidName: constants.kAndroidWidgetName,
      qualifiedAndroidName: constants.kQualifiedAndroidWidgetName,
    );
  }
}
