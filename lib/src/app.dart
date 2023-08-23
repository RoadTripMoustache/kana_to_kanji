import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/constants/app_theme.dart';
import 'package:kana_to_kanji/src/router.dart';

class KanaToKanjiApp extends StatelessWidget {
  const KanaToKanjiApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        restorationScopeId: 'app',

        // Localizations
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context).app_title,

        // Theme
        theme: AppTheme.dark(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,

        // Router
        routerConfig: router);
  }
}
