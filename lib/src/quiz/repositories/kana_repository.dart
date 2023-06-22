import 'package:kana_to_kanji/src/quiz/constants/alphabets.dart';
import 'package:kana_to_kanji/src/quiz/models/group.dart';
import 'package:kana_to_kanji/src/quiz/models/kana.dart';

class KanaRepository {
  static const List<Group> _hiraganaGroup = [
    Group(id: 0, alphabet: Alphabets.hiragana, name: "a/あ"),
    Group(id: 1, alphabet: Alphabets.hiragana, name: "ka/か"),
    Group(id: 2, alphabet: Alphabets.hiragana, name: "sa/さ"),
    Group(id: 3, alphabet: Alphabets.hiragana, name: "ta/た"),
    Group(id: 4, alphabet: Alphabets.hiragana, name: "na/な"),
    Group(id: 5, alphabet: Alphabets.hiragana, name: "ha/は"),
    Group(id: 6, alphabet: Alphabets.hiragana, name: "ma/ま"),
    Group(id: 7, alphabet: Alphabets.hiragana, name: "ya/や"),
    Group(id: 8, alphabet: Alphabets.hiragana, name: "ra/ら"),
    Group(id: 9, alphabet: Alphabets.hiragana, name: "wa/わ"),
  ];

  static const List<Group> _katakanaGroup = [
    Group(id: 10, alphabet: Alphabets.katakana, name: "a/ア"),
    Group(id: 11, alphabet: Alphabets.katakana, name: "ka/カ"),
    Group(id: 12, alphabet: Alphabets.katakana, name: "sa/サ"),
    Group(id: 13, alphabet: Alphabets.katakana, name: "ta/タ"),
    Group(id: 14, alphabet: Alphabets.katakana, name: "na/ナ"),
    Group(id: 15, alphabet: Alphabets.katakana, name: "ha/ハ"),
    Group(id: 16, alphabet: Alphabets.katakana, name: "ma/マ"),
    Group(id: 17, alphabet: Alphabets.katakana, name: "ya/ヤ"),
    Group(id: 18, alphabet: Alphabets.katakana, name: "ra/ラ"),
    Group(id: 19, alphabet: Alphabets.katakana, name: "wa/ワ")
  ];

  List<Group> getGroups([Alphabets? alphabet]) {
    if (alphabet == Alphabets.hiragana) {
      return _hiraganaGroup;
    } else if (alphabet == Alphabets.katakana) {
      return _katakanaGroup;
    } else {
      return [..._hiraganaGroup, ..._katakanaGroup];
    }
  }
}
