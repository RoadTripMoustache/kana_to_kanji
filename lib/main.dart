import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/app.dart';
import 'package:kana_to_kanji/src/locator.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();

  await locator.allReady();

  runApp(const KanaToKanjiApp());
}
