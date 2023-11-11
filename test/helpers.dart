import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kana_to_kanji/src/core/constants/app_theme.dart';
import 'package:kana_to_kanji/src/locator.dart';

/// Unregister the service [T] from GetIt
void unregister<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}

String getRouterKey(String route) {
  return 'key_$route';
}

extension RouterWidgetTester on WidgetTester {
  Future<void> pumpRouterApp(Widget widget, String initialLocation,
      [List<String> allowedRoutes = const []]) {
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: initialLocation,
          builder: (context, state) => widget,
        ),
        ...allowedRoutes
            .map(
              (e) => GoRoute(
                path: e,
                builder: (context, state) => Container(
                  key: Key(
                    getRouterKey(e),
                  ),
                ),
              ),
            )
            .toList()
      ],
    );

    return pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

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
        ...allowedRoutes
            .map(
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
            .toList()
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

  Future<void> pumpLocalizedWidget(Widget widget,
      {String locale = "en",
      double textScaleFactor = 0.9,
      ThemeMode themeMode = ThemeMode.light,
      bool useScaffold = true}) {
    return pumpWidget(
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
}

/// Load the l10n class
Future<AppLocalizations> setupLocalizations([String locale = 'en']) async {
  return AppLocalizations.delegate.load(Locale(locale));
}
