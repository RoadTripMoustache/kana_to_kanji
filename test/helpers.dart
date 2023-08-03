import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/constants/app_theme.dart';
import 'package:kana_to_kanji/src/locator.dart';

/// Unregister the service [T] from GetIt
void unregister<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}

/// Load the Internationalization class
Future<AppLocalizations> setupAppIntl() async {
  return AppLocalizations.delegate.load(const Locale('en'));
}

/// Load the l10n classes. Take the [child] widget to test
class LocalizedWidget extends StatelessWidget {
  final Widget child;

  final bool useScaffold;

  final String locale;

  final double textScaleFactor;

  final ThemeMode themeMode;

  const LocalizedWidget(
      {super.key,
      required this.child,
      this.useScaffold = true,
      this.locale = 'en',
      this.textScaleFactor = 0.9,
      this.themeMode = ThemeMode.light});

  @override
  Widget build(BuildContext context) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: themeMode,
        locale: Locale(locale),
        home: useScaffold ? Scaffold(body: child) : child,
      );
}
