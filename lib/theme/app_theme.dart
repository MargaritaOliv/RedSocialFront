import 'package:flutter/material.dart';
import 'color_schemes.dart';
import 'typography.dart';
import 'shapes.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorSchemes.lightColorScheme,
      textTheme: AppTypography.textTheme,
      fontFamily: 'Inter',

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.buttonBorderRadius,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorSchemes.lightColorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: AppShapes.inputBorderRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppShapes.inputBorderRadius,
          borderSide: BorderSide(
            color: AppColorSchemes.lightColorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppShapes.inputBorderRadius,
          borderSide: BorderSide(
            color: AppColorSchemes.lightColorScheme.error,
            width: 1,
          ),
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.cardBorderRadius,
        ),
      ),

      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColorSchemes.lightColorScheme.surface,
        foregroundColor: AppColorSchemes.lightColorScheme.onSurface,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorSchemes.darkColorScheme,
      textTheme: AppTypography.textTheme,
      fontFamily: 'Inter',

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.buttonBorderRadius,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorSchemes.darkColorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: AppShapes.inputBorderRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppShapes.inputBorderRadius,
          borderSide: BorderSide(
            color: AppColorSchemes.darkColorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppShapes.inputBorderRadius,
          borderSide: BorderSide(
            color: AppColorSchemes.darkColorScheme.error,
            width: 1,
          ),
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.cardBorderRadius,
        ),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColorSchemes.darkColorScheme.surface,
        foregroundColor: AppColorSchemes.darkColorScheme.onSurface,
      ),
    );
  }
}
