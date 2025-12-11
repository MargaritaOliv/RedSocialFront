// lib/core/theme/color_schemes.dart

import 'package:flutter/material.dart';

class AppColorSchemes {
  // Color principal de tu app (violeta artístico)
  static const Color primarySeed = Color(0xFF8B5CF6);

  // Esquema de colores para tema claro
  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: primarySeed,
    brightness: Brightness.light,
  );

  // Esquema de colores para tema oscuro
  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: primarySeed,
    brightness: Brightness.dark,
  );

  // Colores personalizados adicionales (opcional)
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);
}