import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/kanji_reading.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/models/vocabulary.dart";

const Vocabulary dummyVocabulary = Vocabulary(
  uid: ResourceUid("vocabulary-1", ResourceType.vocabulary),
  kanji: "亜",
  kana: "あ",
  jlptLevel: 1,
  meanings: ["inferior"],
  romaji: "a",
  kanaSyllables: [0],
  version: "2025_01_01",
);

final Vocabulary dummyVocabularyWithRelatedData = Vocabulary(
  uid: ResourceUid("vocabulary-2", ResourceType.vocabulary),
  kanji: "亜",
  kana: "あ",
  jlptLevel: 1,
  meanings: ["inferior"],
  romaji: "a",
  kanaSyllables: [0],
  version: "2025_01_01",
  kanjiReadings: [
    KanjiReading(
      uid: ResourceUid.fromJson("kanji-vocabulary_related"),
      kanji: "亜",
      reading: "あ",
    ),
  ],
  relatedKanjis: [ResourceUid.fromJson("kanji-vocabulary_related")],
  groups: [ResourceUid.fromJson("group-vocabulary_related")],
);

const Vocabulary dummyVocabularyWithoutKanji = Vocabulary(
  uid: ResourceUid("vocabulary-3", ResourceType.vocabulary),
  kanji: "",
  kana: "あ",
  jlptLevel: 1,
  meanings: ["inferior"],
  romaji: "a",
  kanaSyllables: [0],
  version: "2025_01_01",
);

final String sqlInsertDummiesVocabulary = """
INSERT OR IGNORE INTO groups (uid, alphabet, name, kana_type, version)
VALUES
  ('${dummyVocabularyWithRelatedData.groups.first.uid}', 'kanji', '', 'main', '2025_01_01');
  
INSERT OR IGNORE INTO kanjis (uid, kanji, jlpt_level, version, jp_sort_syllables, number_of_strokes, grade, pronunciations, main_meaning)
VALUES
('${dummyVocabularyWithRelatedData.relatedKanjis.first.uid}', '亜', 1, '2025_01_01', '', 0, 0, '[]', '');

INSERT OR IGNORE INTO vocabulary (uid, kanji, kana, jlpt_level, romaji, version, kana_syllables, meanings) VALUES
('${dummyVocabulary.uid.uid}', '亜', 'あ', 1, 'a', '2025_01_01', '[0]', '["inferior"]'),
('${dummyVocabularyWithRelatedData.uid.uid}', '亜', 'あ', 1, 'a', '2025_01_01', '[0]', '["inferior"]'),
('${dummyVocabularyWithoutKanji.uid.uid}', '', 'あ', 1, 'a', '2025_01_01', '[0]', '["inferior"]');

INSERT OR IGNORE INTO vocabulary_kanji_readings (vocabulary_uid, kanji_uid, kanji, reading) VALUES
('${dummyVocabularyWithRelatedData.uid.uid}', '${dummyVocabularyWithRelatedData.kanjiReadings.first.uid.uid}', '亜', 'あ');

INSERT OR IGNORE INTO vocabulary_groups (vocabulary_uid, group_uid) VALUES
('${dummyVocabularyWithRelatedData.uid.uid}', '${dummyVocabularyWithRelatedData.groups.first.uid}');

INSERT OR IGNORE INTO vocabulary_related_kanjis (vocabulary_uid, kanji_uid) VALUES
('${dummyVocabularyWithRelatedData.uid.uid}', '${dummyVocabularyWithRelatedData.relatedKanjis.first.uid}');
""";

final List<Vocabulary> dummiesVocabulary = [
  dummyVocabulary,
  dummyVocabularyWithRelatedData,
  dummyVocabularyWithoutKanji,
];
