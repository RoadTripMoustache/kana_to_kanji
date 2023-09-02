import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/app.dart';
import 'package:kana_to_kanji/src/core/repositories/settings_repository.dart';
import 'package:kana_to_kanji/src/core/widgets/app_config.dart';
import 'package:kana_to_kanji/src/locator.dart';

void main() async {
  // Initialize the application
  await KanaToKanjiApp.initializeApp();

  runApp(AppConfig(environment: Environment.beta, child: KanaToKanjiApp()));
}
