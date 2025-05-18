import "package:kana_to_kanji/src/core/models/resources/example.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";

// Dummy examples for testing
final dummyExample1 = Example(
  uid: ResourceUid.fromJson("example-1"),
  sentence: "こんにちは世界",
  translation: "Hello world",
  kanji: ["こんにちは", "世界"],
  reading: ["konnichiwa", "sekai"],
  version: "2025_01_01",
);

final dummyExample2 = Example(
  uid: ResourceUid.fromJson("example-2"),
  sentence: "私は日本語を勉強します",
  translation: "I study Japanese",
  kanji: ["私", "日本語", "勉強"],
  reading: ["watashi", "nihongo", "benkyou"],
  version: "2025_01_01",
);

final dummyExample3 = Example(
  uid: ResourceUid.fromJson("example-3"),
  sentence: "東京は日本の首都です",
  translation: "Tokyo is the capital of Japan",
  kanji: ["東京", "日本", "首都"],
  reading: ["toukyou", "nihon", "shuto"],
  version: "2025_01_01",
);

final dummyExamples = [dummyExample1, dummyExample2, dummyExample3];

// SQL for inserting dummy examples
final sqlInsertDummyExamples = '''
INSERT INTO examples (uid, sentence, translation, kanji, reading, version)
VALUES 
  ('example-1', 'こんにちは世界', 'Hello world', '["こんにちは", "世界"]', '["konnichiwa", "sekai"]', '2025_01_01'),
  ('example-2', '私は日本語を勉強します', 'I study Japanese', '["私", "日本語", "勉強"]', '["watashi", "nihongo", "benkyou"]', '2025_01_01'),
  ('example-3', '東京は日本の首都です', 'Tokyo is the capital of Japan', '["東京", "日本", "首都"]', '["toukyou", "nihon", "shuto"]', '2025_01_01');
  
INSERT OR IGNORE INTO kanjis (uid, kanji, jlpt_level, version, number_of_strokes, grade, main_reading, main_meaning, readings, meanings)
VALUES
  ('kanji-1', '本', 5, '2025_01_01', 5, 1, 'ほん', 'book', '["ほん"]', '["book"]'),
  ('kanji-2', '本', 5, '2025_01_01', 5, 1, 'ほん', 'book', '["ほん"]', '["book"]');
  
INSERT OR IGNORE INTO kanji_examples (kanji_uid, example_uid)
VALUES 
  ('kanji-1', 'example-1'),
  ('kanji-1', 'example-2'),
  ('kanji-2', 'example-3');
  
INSERT OR IGNORE INTO vocabulary (uid, kanji, kana, jlpt_level, romaji, version, meanings, examples) VALUES
('vocabulary-1', '亜', 'あ', 1, 'a', '2025_01_01', '["inferior"]', '[]'),
('vocabulary-2', '亜', 'あ', 1, 'a', '2025_01_01', '["inferior"]', '[]');
  
INSERT OR IGNORE INTO vocabulary_examples (vocabulary_uid, example_uid)
VALUES 
  ('vocabulary-1', 'example-1'),
  ('vocabulary-2', 'example-2'),
  ('vocabulary-2', 'example-3');
''';
