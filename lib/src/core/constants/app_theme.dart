import "package:flex_color_scheme/flex_color_scheme.dart";
import "package:flutter/material.dart";

class AppTheme {
  const AppTheme._();

  static const FlexScheme _scheme = FlexScheme.indigo;
  static const FlexSurfaceMode _surfaceMode =
      FlexSurfaceMode.levelSurfacesLowScaffold;
  static const bool _useMaterial3 = true;
  static const bool _swapLegacyOnMaterial3 = true;

  static ThemeData light() => FlexThemeData.light(
        scheme: _scheme,
        surfaceMode: _surfaceMode,
        blendLevel: 7,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          elevatedButtonRadius: 10.0,
          outlinedButtonRadius: 10.0,
          filledButtonRadius: 10.0,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: _useMaterial3,
        swapLegacyOnMaterial3: _swapLegacyOnMaterial3,
      );

  static ThemeData dark() => FlexThemeData.dark(
        scheme: _scheme,
        surfaceMode: _surfaceMode,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          elevatedButtonRadius: 10.0,
          outlinedButtonRadius: 10.0,
          filledButtonRadius: 10.0,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: _useMaterial3,
        swapLegacyOnMaterial3: _swapLegacyOnMaterial3,
      );

  static Color getModalBottomSheetBackgroundColor(ThemeData theme) =>
      ElevationOverlay.applySurfaceTint(
          theme.colorScheme.surface, theme.colorScheme.surfaceTint, 2.0);
}
