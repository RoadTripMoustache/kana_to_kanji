import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_test/flutter_test.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/constants/app_theme.dart";
import "package:kana_to_kanji/src/locator.dart";

/// Unregister the service [T] from GetIt
void unregister<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}

String getRouterKey(String route) => "key_$route";

extension WidgetTesterExtension on WidgetTester {
  /// Pump a router on [widget].
  /// [initialLocation] is the current location of the widget and [allowedRoutes]
  /// contains all the routes available for the router.
  Future<void> pumpRouterApp(Widget widget, String initialLocation,
      [List<String> allowedRoutes = const []]) {
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: initialLocation,
          builder: (context, state) => widget,
        ),
        ...allowedRoutes.map(
          (e) => GoRoute(
            path: e,
            builder: (context, state) => Container(
              key: Key(
                getRouterKey(e),
              ),
            ),
          ),
        )
      ],
    );

    return pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  /// Pump a router on a localized [widget].
  /// [initialLocation] is the current location of the widget and [allowedRoutes]
  /// contains all the routes available for the router.
  Future<void> pumpLocalizedRouterWidget(Widget widget,
      {String initialLocation = "/",
      String locale = "en",
      double textScaleFactor = 0.9,
      ThemeMode themeMode = ThemeMode.light,
      bool useScaffold = true,
      Widget? allowedRoutesChild,
      List<String> allowedRoutes = const []}) {
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: initialLocation,
          builder: (context, state) => Scaffold(body: widget),
        ),
        ...allowedRoutes.map(
          (e) => GoRoute(
            path: e,
            builder: (context, state) => Container(
              key: Key(
                getRouterKey(e),
              ),
              child: allowedRoutesChild,
            ),
          ),
        )
      ],
    );

    return pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: themeMode,
        locale: Locale(locale),
      ),
    );
  }

  /// Pump a localized widget
  Future<void> pumpLocalizedWidget(Widget widget,
          {String locale = "en",
          double textScaleFactor = 0.9,
          ThemeMode themeMode = ThemeMode.light,
          bool useScaffold = true}) =>
      pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,
          locale: Locale(locale),
          home: useScaffold ? Scaffold(body: widget) : widget,
        ),
      );
}

/// Load the l10n class
Future<AppLocalizations> setupLocalizations([String locale = "en"]) async =>
    AppLocalizations.delegate.load(Locale(locale));
