import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

const Kanji dummyKanji = Kanji(
  uid: ResourceUid("kanji-1", ResourceType.kanji),
  kanji: "本",
  jlptLevel: 5,
  grade: 1,
  numberOfStrokes: 5,
  meanings: ["book"],
  onReadings: ["ほん"],
  kunReadings: ["ほん"],
  version: "2023-12-1",
  jpSortSyllables: [],
  mainMeaning: "book",
);

const Kanji dummyKanjiWithoutOnMeaning = Kanji(
  uid: ResourceUid("kanji-2", ResourceType.kanji),
  kanji: "本",
  jlptLevel: 5,
  grade: 1,
  numberOfStrokes: 5,
  meanings: ["book"],
  kunReadings: ["ほん"],
  version: "2023-12-1",
  jpSortSyllables: [],
  mainMeaning: "book",
);

final List<Kanji> dummiesKanji = [dummyKanji, dummyKanjiWithoutOnMeaning];
