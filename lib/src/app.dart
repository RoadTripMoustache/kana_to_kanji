import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/constants/app_theme.dart';
import 'package:kana_to_kanji/src/core/repositories/settings_repository.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:kana_to_kanji/src/router.dart';

class KanaToKanjiApp extends StatelessWidget {
  final SettingsRepository _settingsRepository = locator<SettingsRepository>();

  KanaToKanjiApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _settingsRepository,
        builder: (BuildContext context, _) {
          return MaterialApp.router(
              restorationScopeId: 'app',

              // Localizations
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              onGenerateTitle: (BuildContext context) =>
                  AppLocalizations.of(context).app_title,

              // Theme
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: _settingsRepository.themeMode,

              // Router
              routerConfig: router);
        });
  }
}
