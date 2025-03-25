import "package:feedback/feedback.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

// ignore: uri_does_not_exist
import "package:kana_to_kanji/firebase_options.dart";
import "package:kana_to_kanji/src/core/constants/app_configuration.dart";
import "package:kana_to_kanji/src/core/constants/app_theme.dart";
import "package:kana_to_kanji/src/core/repositories/settings_repository.dart";
import "package:kana_to_kanji/src/core/services/dialog_service.dart";
import "package:kana_to_kanji/src/core/widgets/app_not_found_view.dart";
import "package:kana_to_kanji/src/core/widgets/app_snack_bar_upgrader.dart";
import "package:kana_to_kanji/src/feedback/widgets/feedback_screenshot_form.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:kana_to_kanji/src/router.dart";

class KanaToKanjiApp extends StatelessWidget {
  final SettingsRepository _settingsRepository = locator<SettingsRepository>();

  KanaToKanjiApp({super.key});

  static Future initializeApp() async {
    setupLocator();
    WidgetsFlutterBinding.ensureInitialized();

    // Firebase initialization
    await Firebase.initializeApp(
      // ignore: undefined_identifier
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (!kIsWeb && AppConfiguration.enableCrashlytics) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      // Pass all uncaught asynchronous errors that aren't handled
      // by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }

    locator.allReadySync();

    // Load the user settings.
    // Need to be run before the runApp for the theme mode.
    await locator<SettingsRepository>().loadSettings();
  }

  late final _router = buildRouter(locator<DialogService>().navigatorKey);

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _settingsRepository,
    builder:
        (BuildContext context, _) => BetterFeedback(
          mode: FeedbackMode.navigate,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          localeOverride: _settingsRepository.locale,
          theme: FeedbackThemeData(
            sheetIsDraggable: false,
            feedbackSheetHeight: 0.1,
          ),
          feedbackBuilder:
              (context, onSubmit, _) =>
                  FeedbackScreenshotForm(onSubmit: onSubmit),
          child: MaterialApp.router(
            restorationScopeId: "app",

            // Localizations
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            onGenerateTitle:
                (BuildContext context) =>
                    AppLocalizations.of(context).app_title,
            locale: _settingsRepository.locale,

            // Theme
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: _settingsRepository.themeMode,

            // Router
            routerConfig: _router,
            builder:
                (context, child) => AppSnackBarUpgrader(
                  navigatorKey: _router.routerDelegate.navigatorKey,
                  child:
                      child ??
                      AppNotFoundView(uri: Uri(host: ""), goBackUrl: ""),
                ),
          ),
        ),
  );
}
