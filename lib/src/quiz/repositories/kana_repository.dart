import 'package:kana_to_kanji/src/quiz/constants/alphabets.dart';
import 'package:kana_to_kanji/src/quiz/models/group.dart';
import 'package:kana_to_kanji/src/quiz/models/kana.dart';

class KanaRepository {
  static const List<Group> _hiraganaGroup = [
    Group(id: 0, name: "a あ"),
    Group(id: 1, name: "ka か"),
    Group(id: 2, name: "sa さ"),
    Group(id: 3, name: "ta た"),
    Group(id: 4, name: "na な"),
    Group(id: 5, name: "ha は"),
    Group(id: 6, name: "ma ま"),
    Group(id: 7, name: "ya や"),
    Group(id: 8, name: "ra ら"),
    Group(id: 9, name: "wa わ"),
  ];

  static const List<Group> _katakanaGroup = [
    Group(id: 10, name: "a ア"),
    Group(id: 11, name: "ka カ"),
    Group(id: 12, name: "sa サ"),
    Group(id: 13, name: "ta タ"),
    Group(id: 14, name: "na ナ"),
    Group(id: 15, name: "ha ハ"),
    Group(id: 16, name: "ma マ"),
    Group(id: 17, name: "ya ヤ"),
    Group(id: 18, name: "ra ラ"),
    Group(id: 19, name: "wa ワ")
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
