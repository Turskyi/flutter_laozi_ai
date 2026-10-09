import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/application_services/blocs/settings/settings_bloc.dart';
import 'package:laozi_ai/env/env.dart';
import 'package:laozi_ai/res/app_theme.dart';
import 'package:laozi_ai/res/constants.dart' as constants;
import 'package:laozi_ai/res/resources.dart';
import 'package:laozi_ai/router/app_route.dart';
import 'package:laozi_ai/ui/debug_navigation_observer.dart';
import 'package:resend/resend.dart';

class LaoziAiApp extends StatefulWidget {
  const LaoziAiApp({required this.routeMap, this.initialUri, super.key});

  final Map<String, WidgetBuilder> routeMap;
  final Uri? initialUri;

  @override
  State<LaoziAiApp> createState() => _LaoziAiAppState();
}

class _LaoziAiAppState extends State<LaoziAiApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<Uri>? _linkSubscription;
  Uri? _pendingUri;
  int _linkEventCount = 0;

  @override
  void initState() {
    super.initState();
    _pendingUri = widget.initialUri;
    print('Deb: LaoziAiApp.initState initialUri: ${widget.initialUri}');
    _linkSubscription = AppLinks().uriLinkStream.listen(_openLink);
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  void _openLink(Uri uri) {
    _linkEventCount++;
    print(
      'Deb: _openLink event #$_linkEventCount received uri: $uri, '
      'widget.initialUri: ${widget.initialUri}',
    );
    if (uri == widget.initialUri) {
      print('Deb: _openLink ignoring URI equal to initialUri: $uri');
      // Ignore initial URI emission from stream to avoid duplicate navigation.
    } else {
      const String primaryDomain = constants.primaryDomain;
      final String host = uri.host.toLowerCase();
      final bool isAllowedDomain =
          host == primaryDomain || host.endsWith('.$primaryDomain');
      final bool isManuscriptPath = uri.path.startsWith('/manuscript/');
      print(
        'Deb: _openLink host: $host, allowed: $isAllowedDomain, '
        'manuscriptPath: $isManuscriptPath',
      );

      if (isAllowedDomain && isManuscriptPath) {
        final String? lastSegment = uri.pathSegments.lastOrNull;
        final int? page = lastSegment != null
            ? int.tryParse(lastSegment)
            : null;
        if (page != null && mounted) {
          print(
            'Deb: _openLink pushing manuscript route '
            '${AppRoute.manuscript.path} with page: $page',
          );
          _navigatorKey.currentState?.pushNamed(
            AppRoute.manuscript.path,
            arguments: page,
          );
        } else {
          print(
            'Deb: _openLink not navigating, page: $page, mounted: $mounted',
          );
          // Ignore if page is invalid or widget is unmounted.
        }
      } else {
        print('Deb: _openLink ignoring unsupported URI: $uri');
        // Ignore non-manuscript links.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Resend(apiKey: Env.resendApiKey);
    final LocalizationDelegate localizationDelegate = LocalizedApp.of(
      context,
    ).delegate;

    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (SettingsState previous, SettingsState current) =>
          previous.themeMode != current.themeMode ||
          previous.language != current.language,
      builder: (BuildContext context, SettingsState state) {
        return Resources(
          child: MaterialApp(
            navigatorKey: _navigatorKey,
            navigatorObservers: <NavigatorObserver>[
              DebugNavigationObserver(),
            ],
            debugShowCheckedModeBanner: false,
            title: translate('title'),
            initialRoute: () {
              final Uri? pendingUri = _pendingUri;
              if (pendingUri == null) {
                print(
                  'Deb: MaterialApp initialRoute: ${AppRoute.home.path} '
                  '(pendingUri is null)',
                );
                return AppRoute.home.path;
              } else {
                final String? lastSegment = pendingUri.pathSegments.lastOrNull;
                final int page = lastSegment != null
                    ? int.tryParse(lastSegment) ?? 1
                    : 1;
                final String route = '${AppRoute.manuscript.path}/$page';
                print(
                  'Deb: MaterialApp initialRoute: $route '
                  '(pendingUri: $pendingUri)',
                );
                return route;
              }
            }(),
            routes: widget.routeMap,
            onGenerateRoute: (RouteSettings settings) {
              print(
                'Deb: onGenerateRoute called with name: ${settings.name}, '
                'arguments: ${settings.arguments}\n'
                'Deb: onGenerateRoute call stack:\n${StackTrace.current}',
              );
              final Uri? uri = Uri.tryParse(settings.name ?? '');
              final String? lastSegment = uri?.pathSegments.lastOrNull;
              final int page = lastSegment != null
                  ? int.tryParse(lastSegment) ?? 1
                  : 1;
              print('Deb: onGenerateRoute manuscript page: $page');
              return MaterialPageRoute<void>(
                settings: RouteSettings(name: settings.name, arguments: page),
                builder: (BuildContext context) =>
                    widget.routeMap[AppRoute.manuscript.path]?.call(context) ??
                    const SizedBox.shrink(),
              );
            },
            themeMode: state.themeMode,
            theme: createAppTheme(Brightness.light),
            darkTheme: createAppTheme(Brightness.dark),
            localizationsDelegates: <LocalizationsDelegate<dynamic>>[
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              localizationDelegate,
            ],
            supportedLocales: localizationDelegate.supportedLocales,
            locale: localizationDelegate.currentLocale,
          ),
        );
      },
    );
  }
}
