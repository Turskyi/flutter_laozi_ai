import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/application_services/blocs/settings/settings_bloc.dart';
import 'package:laozi_ai/env/env.dart';
import 'package:laozi_ai/res/app_theme.dart';
import 'package:laozi_ai/res/resources.dart';
import 'package:laozi_ai/router/app_route.dart';
import 'package:resend/resend.dart';

class LaoziAiApp extends StatelessWidget {
  const LaoziAiApp({required this.routeMap, super.key});

  final Map<String, WidgetBuilder> routeMap;

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
            debugShowCheckedModeBanner: false,
            title: translate('title'),
            initialRoute: AppRoute.home.path,
            routes: routeMap,
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
