import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

const Kanji dummyKanji = Kanji(
  ResourceUid("kanji-1", ResourceType.kanji),
  "本",
  5,
  1,
  5,
  ["book"],
  ["ほん"],
  ["ほん"],
  [],
  "2023-12-1",
  [],
  [],
  [],
  [],
  [],
  "book",
);

const Kanji dummyKanjiWithoutOnMeaning = Kanji(
  ResourceUid("kanji-1", ResourceType.kanji),
  "本",
  5,
  1,
  5,
  ["book"],
  ["ほん"],
  [],
  [],
  "2023-12-1",
  [],
  [],
  [],
  [],
  [],
  "book",
);
