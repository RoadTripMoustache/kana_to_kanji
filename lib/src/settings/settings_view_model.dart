import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/authentication/landing_view.dart";
import "package:kana_to_kanji/src/core/repositories/settings_repository.dart";
import "package:kana_to_kanji/src/core/repositories/user_repository.dart";
import "package:kana_to_kanji/src/core/services/dialog_service.dart";
import "package:kana_to_kanji/src/core/services/info_service.dart";
import "package:kana_to_kanji/src/feedback/feedback_view.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:stacked/stacked.dart";

class SettingsViewModel extends BaseViewModel {
  final SettingsRepository _repository = locator<SettingsRepository>();
  final UserRepository _userRepository = locator<UserRepository>();
  final InfoService _infoService = locator<InfoService>();
  final DialogService _dialogService = locator<DialogService>();

  final AppLocalizations l10n;

  String get version => _infoService.appVersion;

  SettingsViewModel({required this.l10n});

  Map<ThemeMode, Map<String, dynamic>> get themeModes => {
        ThemeMode.light: {
          "icon": Icons.light_mode_rounded,
          "tooltip": l10n.settings_theme_light
        },
        ThemeMode.system: {
          "icon": Icons.smartphone_rounded,
          "tooltip": l10n.settings_theme_system
        },
        ThemeMode.dark: {
          "icon": Icons.dark_mode_rounded,
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

  Future<void> setLocale(Locale? locale) async {
    await _repository.updateLocale(locale);
  }

  /// Open the feedback dialog
  Future<void> giveFeedback() async {
    await _dialogService.showModalBottomSheet(
        enableDrag: false,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (context) => const FeedbackView());
  }

  /// confirmDeletion - Open a dialog to ask the user to confirm the deletion
  /// of his account.
  /// params:
  /// - context : BuildContext
  Future<void> confirmDeletion(BuildContext context) async {
    await _dialogService.showConfirmationModal(
      context: context,
      title: l10n.settings_delete_account_dialog_title,
      content: l10n.settings_delete_account_dialog_content,
      cancelButtonLabel: l10n.settings_delete_account_dialog_cancel,
      cancel: () => Navigator.pop(context, "Cancel"),
      validationButtonLabel: l10n.settings_delete_account_dialog_validate,
      validate: () => deleteAccount(GoRouter.of(context)),
    );
  }

  /// deleteAccount - Delete the account of the user, and redirect the user
  /// to the landing view if the deletion went well.
  /// params:
  /// - router : GoRouter
  Future<void> deleteAccount(GoRouter router) async {
    final bool isDeleted = await _userRepository.deleteUser();
    if (isDeleted) {
      await router.push(LandingView.routeName);
    }
  }
}
