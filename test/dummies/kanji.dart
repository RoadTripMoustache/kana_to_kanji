import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

const Kanji dummyKanji = Kanji(
  uid: ResourceUid("kanji-1", ResourceType.kanji),
  kanji: "本",
  jlptLevel: 5,
  grade: 1,
  numberOfStrokes: 5,
  onReadings: ["ほん"],
  kunReadings: ["ほん"],
  version: "2025_01_01",
  jpSortSyllables: [164, 218],
  mainMeaning: "book",
);

final Kanji dummyKanjiWithRelatedData = Kanji(
  uid: ResourceUid("kanji-2", ResourceType.kanji),
  kanji: "本",
  jlptLevel: 5,
  grade: 1,
  numberOfStrokes: 5,
  onReadings: ["ほん"],
  kunReadings: ["ほん"],
  version: "2025_01_01",
  jpSortSyllables: [164, 218],
  mainMeaning: "book",
  relatedVocabulary: [ResourceUid.fromJson("vocabulary-kanji_related")],
  groups: [ResourceUid.fromJson("group-kanji_related")],
);

const Kanji dummyKanjiWithoutOnReading = Kanji(
  uid: ResourceUid("kanji-3", ResourceType.kanji),
  kanji: "本",
  jlptLevel: 5,
  grade: 1,
  numberOfStrokes: 5,
  kunReadings: ["ほん"],
  version: "2025_01_01",
  jpSortSyllables: [164, 218],
  mainMeaning: "book",
);

const Kanji dummyKanjiWithoutKunReading = Kanji(
  uid: ResourceUid("kanji-3", ResourceType.kanji),
  kanji: "本",
  jlptLevel: 5,
  grade: 1,
  numberOfStrokes: 5,
  onReadings: ["ほん"],
  version: "2025_01_01",
  jpSortSyllables: [164, 218],
  mainMeaning: "book",
);

final String sqlInsertDummiesKanji = """
INSERT OR IGNORE INTO groups (uid, alphabet, name, kana_type, version)
VALUES
  ('${dummyKanjiWithRelatedData.groups.first.uid}', 'kanji', '', 'main', '2025_01_01');

INSERT OR IGNORE INTO vocabulary (uid, kanji, kana, jlpt_level, romaji, version, kana_syllables, meanings) VALUES
('${dummyKanjiWithRelatedData.relatedVocabulary.first.uid}', '日本語', 'にほんご', 5, 'nihongo', '2025_01_01', '["に","ほ","ん","ご"]', '["Japanese language"]');

INSERT OR IGNORE INTO kanjis (uid, kanji, jlpt_level, version, jp_sort_syllables, number_of_strokes, grade, on_readings, kun_readings, pronunciations, main_meaning)
VALUES
  ('${dummyKanji.uid.uid}', '本', 5, '2025_01_01', '[164, 218]', 5, 1, '["ほん"]', '["ほん"]', '[]', 'book'),
  ('${dummyKanjiWithRelatedData.uid.uid}', '本', 5, '2025_01_01', '[164, 218]', 5, 1, '["ほん"]', '["ほん"]', '[]', 'book'),
  ('${dummyKanjiWithoutOnReading.uid.uid}', '本', 5, '2025_01_01', '[164, 218]', 5, 1, '[]', '["ほん"]', '[]', 'book');
  
INSERT OR IGNORE INTO kanji_groups (kanji_uid, group_uid)
VALUES
('${dummyKanjiWithRelatedData.uid.uid}', '${dummyKanjiWithRelatedData.groups.first.uid}');

INSERT OR IGNORE INTO kanji_related_vocabulary (kanji_uid, vocabulary_uid)
VALUES ('${dummyKanjiWithRelatedData.uid.uid}', '${dummyKanjiWithRelatedData.relatedVocabulary.first.uid}');
""";

final List<Kanji> dummiesKanji = [
  dummyKanji,
  dummyKanjiWithRelatedData,
  dummyKanjiWithoutOnReading,
];
