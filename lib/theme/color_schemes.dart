import 'package:flutter/material.dart';

class AppColorSchemes {
  static const Color primarySeed = Color(0xFF8B5CF6);

  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: primarySeed,
    brightness: Brightness.light,
  );

  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: primarySeed,
    brightness: Brightness.dark,
  );

  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);
}