import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/resources/resources.dart";

final Kana dummyHiragana = Kana(
  uid: ResourceUid.fromJson("kana-0"),
  alphabet: Alphabets.hiragana,
  groupUid: ResourceUid.fromJson("group-kana_hiragana"),
  kana: "あ",
  romaji: "a",
  version: "2025_01_01",
  position: 1,
);

final Kana dummyKatakana = Kana(
  uid: ResourceUid.fromJson("kana-1"),
  alphabet: Alphabets.katakana,
  groupUid: ResourceUid.fromJson("group-kana_katakana"),
  kana: "ア",
  romaji: "a",
  version: "2025_01_01",
  position: 2,
);

final List<Kana> dummiesKana = [dummyHiragana, dummyKatakana];

final String sqlInsertDummiesKana = """
INSERT OR IGNORE INTO groups (uid, alphabet, name, localized_name, kana_type, version)
VALUES
  ("${dummyHiragana.groupUid.uid}", "katakana", "Katakana", "Katakana", "main", "2025_01_01"),
  ("${dummyKatakana.groupUid.uid}", "hiragana", "Hiragana", "Hiragana", "main", "2025_01_01");
  
INSERT OR IGNORE INTO kanas (uid, alphabet, group_uid, kana, romaji, version, position)
VALUES
  ("${dummyHiragana.uid.uid}", "hiragana", "${dummyHiragana.groupUid.uid}", "あ", "a", "2025_01_01", 1),
  ("${dummyKatakana.uid.uid}", "katakana", "${dummyKatakana.groupUid.uid}", "ア", "a", "2025_01_01", 2);
""";

/// Generates a dummy kana with the index given in parameter.
Kana generateDummyKana(int index) => Kana(
  uid: ResourceUid.fromJson("kana-$index"),
  alphabet: Alphabets.hiragana,
  groupUid: const ResourceUid("group-1", ResourceType.group),
  kana: "あ",
  romaji: "a",
  version: "2025_01_01",
  position: index,
);
