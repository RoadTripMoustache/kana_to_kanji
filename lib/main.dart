import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/app.dart';
import 'package:kana_to_kanji/src/core/repositories/settings_repository.dart';
import 'package:kana_to_kanji/src/core/services/groups_service.dart';
import 'package:kana_to_kanji/src/core/services/kana_service.dart';
import 'package:kana_to_kanji/src/locator.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();

  await Isar.initialize();
  locator.allReadySync();

  // Load the user settings. Need to be run before the runApp for the theme mode.
  await locator<SettingsRepository>().loadSettings();
  await locator<GroupsService>().loadCollection();
  await locator<KanaService>().loadCollection();

  runApp(KanaToKanjiApp());
}
