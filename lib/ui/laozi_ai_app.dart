import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/application_services/blocs/settings_bloc.dart';
import 'package:laozi_ai/env/env.dart';
import 'package:laozi_ai/res/resources.dart';
import 'package:laozi_ai/router/app_route.dart';
import 'package:resend/resend.dart';

class LaoziAiApp extends StatelessWidget {
  const LaoziAiApp({required this.routeMap, super.key});

  final Map<String, WidgetBuilder> routeMap;

  @override
  Widget build(BuildContext context) {
    Resend(apiKey: Env.resendApiKey);
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (SettingsState previous, SettingsState current) =>
          previous.themeMode != current.themeMode,
      builder: (BuildContext context, SettingsState state) {
        return Resources(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: translate('title'),
            initialRoute: AppRoute.home.path,
            routes: routeMap,
            themeMode: state.themeMode,
            theme: _createTheme(Brightness.light),
            darkTheme: _createTheme(Brightness.dark),
          ),
        );
      },
    );
  }

  ThemeData _createTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6750A4),
        brightness: brightness,
        primary: const Color(0xFF6750A4),
        onPrimary: const Color(0xFFFFFFFF),
        secondaryContainer: const Color(0xFFE8DEF8),
        onSecondaryContainer: const Color(0xFF1D192B),
        surface: isDark ? const Color(0xFF1C1B1F) : const Color(0xFFFEF7FF),
        onSurface: isDark ? const Color(0xFFE6E1E5) : const Color(0xFF1C1B1F),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 96, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 16),
        titleMedium: TextStyle(fontSize: 14),
        titleSmall: TextStyle(fontSize: 12),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 12),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        labelMedium: TextStyle(fontSize: 12),
        labelSmall: TextStyle(fontSize: 10),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF6750A4),
        foregroundColor: Color(0xFFFFFFFF),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF6750A4),
        foregroundColor: Color(0xFFFFFFFF),
      ),
    );
  }
}
