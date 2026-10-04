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

  @override
  void initState() {
    super.initState();
    _pendingUri = widget.initialUri;
    _linkSubscription = AppLinks().uriLinkStream.listen(_openLink);
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  void _openLink(Uri uri) {
    if (uri == widget.initialUri) {
      // Ignore initial URI emission from stream to avoid duplicate navigation.
    } else {
      const String primaryDomain = constants.primaryDomain;
      final String host = uri.host.toLowerCase();
      final bool isAllowedDomain =
          host == primaryDomain || host.endsWith('.$primaryDomain');
      final bool isManuscriptPath = uri.path.startsWith('/manuscript/');

      if (isAllowedDomain && isManuscriptPath) {
        final String? lastSegment = uri.pathSegments.lastOrNull;
        final int? page = lastSegment != null
            ? int.tryParse(lastSegment)
            : null;
        if (page != null && mounted) {
          _navigatorKey.currentState?.pushNamed(
            AppRoute.manuscript.path,
            arguments: page,
          );
        } else {
          // Ignore if page is invalid or widget is unmounted.
        }
      } else {
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
            debugShowCheckedModeBanner: false,
            title: translate('title'),
            initialRoute: () {
              final Uri? pendingUri = _pendingUri;
              if (pendingUri == null) {
                return AppRoute.home.path;
              } else {
                final String? lastSegment = pendingUri.pathSegments.lastOrNull;
                final int page = lastSegment != null
                    ? int.tryParse(lastSegment) ?? 1
                    : 1;
                return '${AppRoute.manuscript.path}/$page';
              }
            }(),
            routes: widget.routeMap,
            onGenerateRoute: (RouteSettings settings) {
              final Uri? uri = Uri.tryParse(settings.name ?? '');
              final String? lastSegment = uri?.pathSegments.lastOrNull;
              final int page = lastSegment != null
                  ? int.tryParse(lastSegment) ?? 1
                  : 1;
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
