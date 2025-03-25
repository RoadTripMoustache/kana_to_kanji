import "package:flutter/material.dart";

class AppTheme {
  const AppTheme._();

  static ThemeData light() => ThemeData.light(useMaterial3: true);

  static ThemeData dark() => ThemeData.dark(useMaterial3: true);

  static Color getModalBottomSheetBackgroundColor(ThemeData theme) =>
      ElevationOverlay.applySurfaceTint(
        theme.colorScheme.surface,
        theme.colorScheme.surfaceTint,
        2.0,
      );
}
