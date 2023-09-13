import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/core/repositories/settings_repository.dart';
import 'package:kana_to_kanji/src/core/services/info_service.dart';
import 'package:kana_to_kanji/src/feedback/feedback_view.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:stacked/stacked.dart';

class SettingsViewModel extends BaseViewModel {
  final SettingsRepository _repository = locator<SettingsRepository>();
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

  ThemeMode get _themeMode => _repository.themeMode;

  Locale? get currentLocale => _repository.locale;

  List<bool> get themeModeSelected {
    final themeMode = _themeMode;

    return themeModes.keys.map((e) => e == themeMode).toList(growable: false);
  }

  Future<void> setThemeMode(int index) async {
    await _repository.updateThemeMode(themeModes.keys.elementAt(index));
    notifyListeners();
  }

  void setLocale(Locale? locale) async {
    _repository.updateLocale(locale);
  }

  void giveFeedback(BuildContext context) async {
    const radius = Radius.circular(10);

    await showModalBottomSheet(
        isDismissible: true,
        enableDrag: false,
        showDragHandle: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: radius, topRight: radius)),
        context: context,
        builder: (context) => const FeedbackView());
  }
}
