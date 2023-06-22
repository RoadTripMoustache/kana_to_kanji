import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/router.dart';

import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';

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
            AppLocalizations.of(context).appTitle,

        // Theme
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,

        // Router
        routerConfig: router);
  }
}
