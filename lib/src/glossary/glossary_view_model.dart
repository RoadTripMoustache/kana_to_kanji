import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kana_to_kanji/src/settings/settings_view.dart';
import 'package:stacked/stacked.dart';

class GlossaryViewModel extends BaseViewModel {
  final GoRouter router;

  final AppLocalizations l10n;

  GlossaryViewModel(this.router, {required this.l10n});

  void onSettingsTapped() {
    router.push(SettingsView.routeName);
  }
}
