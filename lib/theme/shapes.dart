// lib/core/theme/shapes.dart

import 'package:flutter/material.dart';

class AppShapes {
  // Bordes redondeados para botones
  static BorderRadius buttonBorderRadius = BorderRadius.circular(12);

  // Bordes redondeados para inputs
  static BorderRadius inputBorderRadius = BorderRadius.circular(12);

  // Bordes redondeados para cards
  static BorderRadius cardBorderRadius = BorderRadius.circular(16);

  // Bordes redondeados para diálogos
  static BorderRadius dialogBorderRadius = BorderRadius.circular(20);

  // Bordes redondeados para bottom sheets
  static BorderRadius bottomSheetBorderRadius = const BorderRadius.vertical(
    top: Radius.circular(24),
  );
}