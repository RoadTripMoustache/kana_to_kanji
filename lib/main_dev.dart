import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/app.dart';
import 'package:kana_to_kanji/src/core/widgets/app_config.dart';

void main() async {
  // Initialize the application
  await KanaToKanjiApp.initializeApp();

  runApp(AppConfig(environment: Environment.dev, child: KanaToKanjiApp()));
}
