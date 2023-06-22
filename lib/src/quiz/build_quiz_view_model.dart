import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/quiz/constants/categories.dart';
import 'package:stacked/stacked.dart';

class BuildQuizViewModel extends BaseViewModel {
  final Map<Categories, List<String>> categoryTiles = {
    Categories.hiragana: [
      "a あ",
      "ka か",
      "sa さ",
      "ta た",
      "na な",
      "ha は",
      "ma ま",
      "ya や",
      "ra ら",
      "wa わ"
    ],
    Categories.katakana: [
      "a ア",
      "ka カ",
      "sa サ",
      "ta タ",
      "na ナ",
      "ha ハ",
      "ma マ",
      "ya ヤ",
      "ra ラ",
      "wa ワ"
    ],
    Categories.kanji: []
  };

  bool _readyToStart = false;
  bool get readyToStart => _readyToStart;
}
