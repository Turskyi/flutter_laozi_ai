import 'package:flutter/material.dart';

class DebugNavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    print(
      'Deb: Navigator.didPush route: ${route.settings.name}, '
      'previous: ${previousRoute?.settings.name}',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    print(
      'Deb: Navigator.didPop route: ${route.settings.name}, '
      'revealed: ${previousRoute?.settings.name}',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    print(
      'Deb: Navigator.didRemove route: ${route.settings.name}, '
      'previous: ${previousRoute?.settings.name}',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print(
      'Deb: Navigator.didReplace old: ${oldRoute?.settings.name}, '
      'new: ${newRoute?.settings.name}',
    );
  }
}
