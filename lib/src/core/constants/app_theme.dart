import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";

class AppTheme {
  const AppTheme._();

  static const ColorSwatch primary = ColorSwatch(0xffBE5104, {
    100: Color(0xffFCFCFC),
    200: Color(0xffFDEEE3),
    300: Color(0xffFBD4B8),
    400: Color(0xffF4A770),
    500: Color(0xffBE5104),
    600: Color(0xffA64703),
    700: Color(0xff8C3C03),
    800: Color(0xff723103),
    900: Color(0xff4A1F03),
  });

  // static const ColorSwatch _purple = ColorSwatch(0xff3E58BB, {
  //   100: Color(0xffEBEFFD),
  //   200: Color(0xffD3DBF9),
  //   300: Color(0xff8DA3F5),
  //   400: Color(0xff637FEA),
  //   500: Color(0xff3E58BB),
  //   600: Color(0xff2A429E),
  //   700: Color(0xff172B77),
  //   800: Color(0xff112261),
  //   900: Color(0xff0B1846)
  // });

  static const ColorSwatch blue = ColorSwatch(0xff0199DF, {
    100: Color(0xffFAFDFF),
    200: Color(0xffD7F2FE),
    300: Color(0xff9ADEFE),
    400: Color(0xff58C9FE),
    500: Color(0xff0199DF),
    600: Color(0xff017AB2),
    700: Color(0xff015A84),
    800: Color(0xff014565),
    900: Color(0xff01283C),
  });

  static const ColorSwatch neutral = ColorSwatch(0xff75716C, {
    50: Color(0xffFFFEFC),
    100: Color(0xffFAF7F3),
    200: Color(0xffE1E1DF),
    300: Color(0xffC0BEB9),
    400: Color(0xffA09C98),
    500: Color(0xff75716c),
    600: Color(0xff5B5752),
    700: Color(0xff2E2A28),
    800: Color(0xff141212),
    900: Color(0xff000000),
  });

  static const ColorSwatch red = ColorSwatch(0xffC44747, {
    100: Color(0xffFEF8F8),
    200: Color(0xffFEC4C4),
    300: Color(0xffFE8080),
    400: Color(0xffE36464),
    500: Color(0xffC44747),
    600: Color(0xffA93636),
    700: Color(0xff8B2727),
    800: Color(0xff711B1B),
    900: Color(0xff490F0F),
  });

  static ColorScheme light = ColorScheme.light(
    primary: primary,
    onPrimary: primary[100]!,
    primaryContainer: primary[600],
    onPrimaryContainer: primary[100],
    primaryFixedDim: primary[700],
    onPrimaryFixedVariant: primary[100],
    primaryFixed: primary[900],
    secondary: blue[700]!,
    onSecondary: blue[100]!,
    secondaryFixed: blue[200],
    onSecondaryFixed: blue[900],
    secondaryFixedDim: blue[300],
    onSecondaryFixedVariant: blue[900],
    secondaryContainer: blue[800],
    onSecondaryContainer: blue[100],
    tertiary: neutral[600],
    onTertiary: neutral[100],
    tertiaryContainer: neutral[700],
    onTertiaryContainer: neutral[100],
    tertiaryFixedDim: neutral[800],
    onTertiaryFixedVariant: neutral[100],
    tertiaryFixed: neutral[700],
    // onTertiaryFixed: _neutral[200],
    // surfaceBright: _neutral[50],
    // surfaceDim: _neutral[300],
    surface: neutral[50]!,
    onSurface: neutral[900]!,
    // surfaceContainerLowest: Colors.white,
    // surfaceContainerLow: _neutral[50],
    surfaceContainer: neutral[100],
    surfaceContainerHigh: neutral[200],
    surfaceContainerHighest: neutral[300],
    onSurfaceVariant: neutral[300],
    // inverseSurface: _neutral[800],
    // onInverseSurface: _neutral[200],
    outline: neutral[900],
    shadow: neutral[800],
    // scrim: _neutral[900],
    error: red[600]!,
    onError: red[100]!,
    errorContainer: red[700],
    onErrorContainer: red[100],
  );

  static ColorScheme dark = ColorScheme.dark(
    primary: primary[300]!,
    onPrimary: primary[900]!,
    primaryContainer: primary[400],
    onPrimaryContainer: primary[800],
    primaryFixedDim: primary[400],
    onPrimaryFixedVariant: primary[100],
    primaryFixed: primary[500],
    secondary: blue[300]!,
    onSecondary: blue[900]!,
    secondaryFixed: blue[200],
    onSecondaryFixed: blue[900],
    secondaryFixedDim: blue[300],
    onSecondaryFixedVariant: blue[900],
    secondaryContainer: blue[500],
    onSecondaryContainer: blue[100],
    tertiary: neutral[200],
    onTertiary: neutral[900],
    tertiaryContainer: neutral[100],
    onTertiaryContainer: neutral[900],
    tertiaryFixedDim: neutral[400],
    onTertiaryFixedVariant: neutral[900],
    tertiaryFixed: neutral,
    // surfaceDim: _neutral[200],
    // surfaceBright: _neutral[500],
    surface: neutral[900]!,
    onSurface: neutral[100]!,
    // surfaceContainerLowest: _neutral[900],
    // surfaceContainerLow: _neutral[800],
    surfaceContainer: neutral[700],
    surfaceContainerHigh: neutral[600],
    surfaceContainerHighest: neutral[500],
    onSurfaceVariant: neutral[600],
    // inverseSurface: _neutral[50],
    // onInverseSurface: _neutral[900],
    outline: neutral[100],
    shadow: neutral[200],
    // scrim: _neutral[100],
    error: red[400]!,
    onError: red[900]!,
    errorContainer: red[500],
    onErrorContainer: red[200],
  );

  static ThemeData lightTheme = RTMTheme.light(
    colorScheme: light,
    progressIndicatorTheme: RTMProgressIndicatorThemeData(
      color: primary[600],
      circularBackgroundColor: primary[200],
      circularTextColor: primary[700],
      milestoneValueColor: primary[600],
    ),
  );

  static ThemeData darkTheme = RTMTheme.dark(
    colorScheme: dark,
    bottomAppBarTheme: RTMBottomAppBarTheme(color: dark.surface),
    bottomNavigationBarTheme: RTMBottomNavigationBarThemeData(
      backgroundColor: dark.surface,
    ),
    navigationBarTheme: RTMNavigationBarThemeData(
      backgroundColor: dark.surface,
    ),
    navigationRailTheme: RTMNavigationRailThemeData(
      backgroundColor: dark.surface,
    ),
    progressIndicatorTheme: RTMProgressIndicatorThemeData(
      color: primary[600],
      circularBackgroundColor: primary[200],
      circularTextColor: primary[700],
      milestoneTrackColor: primary[600],
      milestoneValueColor: dark.onSurface,
      milestoneIconTheme: IconThemeData(color: primary[600]),
      milestoneTextStyle: TextStyle(color: dark.onSurface),
      milestoneReachedTextStyle: TextStyle(color: primary[600]),
    ),
  );

  static Color getModalBottomSheetBackgroundColor(ThemeData theme) =>
      ElevationOverlay.applySurfaceTint(
        theme.colorScheme.surface,
        theme.colorScheme.surfaceTint,
        2.0,
      );
}
