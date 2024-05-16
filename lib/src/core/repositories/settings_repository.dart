import "package:flutter/material.dart";
import "package:kana_to_kanji/src/core/constants/preference_flags.dart";
import "package:kana_to_kanji/src/core/services/preferences_service.dart";
import "package:kana_to_kanji/src/locator.dart";

class SettingsRepository with ChangeNotifier {
  final PreferencesService _preferencesService = locator<PreferencesService>();

  late ThemeMode _themeMode;
  late Locale? _locale;

  ThemeMode get themeMode => _themeMode;
  Locale? get locale => _locale;

  int getMaximumAttemptsByQuestion() => 3;

  /// Load the user's settings.
  Future<void> loadSettings() async {
    final String? modeValue =
        await _preferencesService.getString(PreferenceFlags.themeMode);

    _themeMode = ThemeMode.values.firstWhere((e) => e.toString() == modeValue,
        orElse: () => ThemeMode.system);

    final String? localeValue =
        await _preferencesService.getString(PreferenceFlags.locale);

    _locale = null;
    if (localeValue != null) {
      _locale = Locale.fromSubtags(languageCode: localeValue);
    }

    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == _themeMode) {
      return;
    }

    _themeMode = newThemeMode;

    notifyListeners();
    await _preferencesService.setString(
        PreferenceFlags.themeMode, newThemeMode.toString());
  }

  /// Update and persist the Locale based on the user's selection.
  Future<void> updateLocale(Locale? newLocale) async {
    if (newLocale == null || newLocale == _locale) return;

    _locale = newLocale;

    notifyListeners();
    await _preferencesService.setString(
        PreferenceFlags.locale, newLocale.languageCode);
  }
}
