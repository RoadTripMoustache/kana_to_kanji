import 'package:flutter/material.dart';
import 'package:kana_to_kanji/src/quiz/constants/alphabets.dart';
import 'package:stacked/stacked.dart';

class BuildQuizViewModel extends BaseViewModel {
  final Map<Alphabets, List<String>> categoryTiles = {
    Alphabets.hiragana: [
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
    Alphabets.katakana: [
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
    Alphabets.kanji: []
  };

  bool _readyToStart = false;
  bool get readyToStart => _readyToStart;
}
