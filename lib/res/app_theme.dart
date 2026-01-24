import 'package:flutter/material.dart';

ThemeData createAppTheme(Brightness brightness) {
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
      onSurface: isDark ? const Color(0xFFE6E1E5) : const Color(0xFF1D1B20),
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
