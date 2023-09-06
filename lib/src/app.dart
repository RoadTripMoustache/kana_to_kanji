import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/firebase_options.dart';
import 'package:kana_to_kanji/src/core/constants/app_theme.dart';
import 'package:kana_to_kanji/src/core/repositories/settings_repository.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:kana_to_kanji/src/router.dart';

class KanaToKanjiApp extends StatelessWidget {
  final SettingsRepository _settingsRepository = locator<SettingsRepository>();

  KanaToKanjiApp({
    super.key,
  });

  static Future initializeApp() async {
    setupLocator();
    WidgetsFlutterBinding.ensureInitialized();

    // Firebase initialization
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    locator.allReadySync();

    // Load the user settings. Need to be run before the runApp for the theme mode.
    await locator<SettingsRepository>().loadSettings();
  }

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
