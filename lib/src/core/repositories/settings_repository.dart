import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/constants/preference_flags.dart';
import 'package:kana_to_kanji/src/core/services/preferences_service.dart';
import 'package:kana_to_kanji/src/locator.dart';

class SettingsRepository with ChangeNotifier {
  final PreferencesService _preferencesService = locator<PreferencesService>();

  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  int getMaximumAttemptsByQuestion() {
    return 3;
  }

  /// Load the user's settings.
  Future<void> loadSettings() async {
    String? modeValue =
        await _preferencesService.getString(PreferenceFlags.themeMode);

    _themeMode = ThemeMode.values.firstWhere((e) => e.toString() == modeValue,
        orElse: () => ThemeMode.system);

    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;

    notifyListeners();
    await _preferencesService.setString(
        PreferenceFlags.themeMode, newThemeMode.toString());
  }
}
