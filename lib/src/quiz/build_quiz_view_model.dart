import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/quiz/constants/types.dart';
import 'package:stacked/stacked.dart';

class BuildQuizViewModel extends BaseViewModel {
  final Map<Types, List<String>> categoryTiles = {
    Types.hiragana: [
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
    Types.katakana: [
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
    Types.kanji: []
  };

  bool _readyToStart = false;
  bool get readyToStart => _readyToStart;
}
