import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const FlexScheme _scheme = FlexScheme.indigo;
  static const FlexSurfaceMode _surfaceMode =
      FlexSurfaceMode.levelSurfacesLowScaffold;
  static const bool _useMaterial3 = true;
  static const bool _useM2StyleDividerMaterial3 = false;
  static const bool _swapLegacyOnMaterial3 = true;

  static ThemeData light() => FlexThemeData.light(
        scheme: _scheme,
        surfaceMode: _surfaceMode,
        blendLevel: 7,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          useM2StyleDividerInM3: _useM2StyleDividerMaterial3,
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
          useM2StyleDividerInM3: _useM2StyleDividerMaterial3,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: _useMaterial3,
        swapLegacyOnMaterial3: _swapLegacyOnMaterial3,
      );
}
