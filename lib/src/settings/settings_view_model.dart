import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/core/services/info_service.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsViewModel extends BaseViewModel {
  final InfoService _infoService = locator<InfoService>();

  final AppLocalizations l10n;

  String get version => _infoService.appVersion;

  SettingsViewModel({required this.l10n});

  Map<ThemeMode, Map<String, dynamic>> get themeModes => {
        ThemeMode.light: {
          "icon": Icons.light_mode_outlined,
          "tooltip": l10n.settings_theme_light
        },
        ThemeMode.system: {
          "icon": Icons.smartphone_outlined,
          "tooltip": l10n.settings_theme_system
        },
        ThemeMode.dark: {
          "icon": Icons.dark_mode_outlined,
          "tooltip": l10n.settings_theme_dark
        },
      };

  ThemeMode _themeMode = ThemeMode.system;

  List<bool> get themeModeSelected =>
      themeModes.keys.map((e) => e == _themeMode).toList(growable: false);

  Future<void> setThemeMode(int index) async {
    _themeMode = themeModes.keys.elementAt(index);
    notifyListeners();
  }
}
