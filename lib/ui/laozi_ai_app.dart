import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/env/env.dart';
import 'package:laozi_ai/res/resources.dart';
import 'package:laozi_ai/router/app_route.dart';
import 'package:resend/resend.dart';

class LaoziAiApp extends StatelessWidget {
  const LaoziAiApp({
    required this.routeMap,
    super.key,
  });

  final Map<String, WidgetBuilder> routeMap;

  @override
  Widget build(BuildContext context) {
    Resend(apiKey: Env.resendApiKey);
    return Resources(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: translate('title'),
        initialRoute: AppRoute.home.path,
        routes: routeMap,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            // A unique purple shade as the primary color
            seedColor: const Color(0xFF6750A4),
            brightness: Brightness.dark,
            primary: const Color(0xFF6750A4),
            onPrimary: const Color(0xFFFFFFFF),
            primaryContainer: const Color(0xFFEADDFF),
            onPrimaryContainer: const Color(0xFF21005D),
            secondary: const Color(0xFF625B71),
            onSecondary: const Color(0xFFFFFFFF),
            secondaryContainer: const Color(0xFFE8DEF8),
            onSecondaryContainer: const Color(0xFF1D192B),
            tertiary: const Color(0xFF7D5260),
            onTertiary: const Color(0xFFFFFFFF),
            tertiaryContainer: const Color(0xFFFFD8E4),
            onTertiaryContainer: const Color(0xFF31111D),
            error: const Color(0xFFB3261E),
            onError: const Color(0xFFFFFFFF),
            errorContainer: const Color(0xFFF9DEDC),
            onErrorContainer: const Color(0xFF410E0B),
            surface: const Color(0xFF1C1B1F),
            onSurface: const Color(0xFFE6E1E5),
            surfaceContainerHighest: const Color(0xFF49454F),
            onSurfaceVariant: const Color(0xFFCAC4D0),
            outline: const Color(0xFF938F99),
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 96, fontWeight: FontWeight.bold),
            displayMedium: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            displaySmall: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            headlineLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            headlineMedium:
                TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
        ),
      ),
    );
  }
}
