import 'package:flutter/material.dart';

class AppTheme {
  static const _primary = Color(0xFF16324F);
  static const _secondary = Color(0xFFC89B3C);
  static const _lightBackground = Color(0xFFF4EFE6);
  static const _lightSurface = Color(0xFFFFFBF5);
  static const _lightText = Color(0xFF142235);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.light,
      primary: _primary,
      secondary: _secondary,
      surface: _lightSurface,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      brightness: Brightness.light,
      scaffoldBackground: _lightBackground,
      cardSurface: _lightSurface,
      textColor: _lightText,
      subtextColor: const Color(0xFF435266),
      dividerAlpha: 0.08,
    );
  }

  static ThemeData dark() {
    const darkBackground = Color(0xFF0D1117);
    const darkSurface = Color(0xFF161B22);
    const darkText = Color(0xFFE6EDF3);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.dark,
      primary: const Color(0xFF58A6FF),
      secondary: _secondary,
      surface: darkSurface,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      scaffoldBackground: darkBackground,
      cardSurface: darkSurface,
      textColor: darkText,
      subtextColor: const Color(0xFF8B949E),
      dividerAlpha: 0.12,
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Brightness brightness,
    required Color scaffoldBackground,
    required Color cardSurface,
    required Color textColor,
    required Color subtextColor,
    required double dividerAlpha,
  }) {
    final isLight = brightness == Brightness.light;
    final primary = colorScheme.primary;

    return ThemeData(
      colorScheme: colorScheme,
      brightness: brightness,
      scaffoldBackgroundColor: scaffoldBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: cardSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: (isLight ? _primary : Colors.white)
                .withValues(alpha: dividerAlpha),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardSurface,
        indicatorColor: primary.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return TextStyle(
            color: isSelected ? primary : subtextColor,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          );
        }),
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          color: textColor,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          color: textColor,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textColor,
          fontSize: 16,
          height: 1.4,
        ),
        bodyMedium: TextStyle(
          color: subtextColor,
          fontSize: 14,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          color: subtextColor,
          fontSize: 12,
          height: 1.5,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primary.withValues(alpha: 0.08),
        labelStyle: TextStyle(
          color: primary,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: isLight ? Colors.white : const Color(0xFF0D1117),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          foregroundColor: primary,
          side: BorderSide(color: primary.withValues(alpha: 0.2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: subtextColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardSurface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: (isLight ? _primary : Colors.white)
                .withValues(alpha: dividerAlpha),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: (isLight ? _primary : Colors.white)
                .withValues(alpha: dividerAlpha),
          ),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      dividerColor:
          (isLight ? _primary : Colors.white).withValues(alpha: dividerAlpha),
      useMaterial3: true,
    );
  }
}
