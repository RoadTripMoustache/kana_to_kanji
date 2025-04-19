import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/models/vocabulary.dart";

const Vocabulary dummyVocabulary = Vocabulary(
  uid: ResourceUid("vocabulary-1", ResourceType.vocabulary),
  kanji: "亜",
  kana: "あ",
  jlptLevel: 1,
  meanings: ["inferior"],
  romaji: "a",
  kanaSyllables: [],
  version: "2023-12-1",
);

const Vocabulary dummyVocabularyWithoutKanji = Vocabulary(
  uid: ResourceUid("vocabulary-2", ResourceType.vocabulary),
  kanji: "",
  kana: "あ",
  jlptLevel: 1,
  meanings: ["inferior"],
  romaji: "a",
  kanaSyllables: [],
  version: "2023-12-1",
);

final List<Vocabulary> dummiesVocabulary = [
  dummyVocabulary,
  dummyVocabularyWithoutKanji,
];
