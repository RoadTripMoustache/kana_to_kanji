import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/app.dart';
import 'package:kana_to_kanji/src/core/repositories/settings_repository.dart';
import 'package:kana_to_kanji/src/locator.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();

  locator.allReadySync();

  // Load the user settings. Need to be run before the runApp for the theme mode.
  await locator<SettingsRepository>().loadSettings();

  runApp(KanaToKanjiApp());
}
