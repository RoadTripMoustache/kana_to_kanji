import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/kana.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

const Kana dummyHiragana = Kana(
  uid: ResourceUid("0", ResourceType.kana),
  alphabet: Alphabets.hiragana,
  groupUid: ResourceUid("0", ResourceType.group),
  kana: "あ",
  romaji: "a",
  version: "2023-12-01",
  position: 1,
);

const Kana dummyKatakana = Kana(
  uid: ResourceUid("1", ResourceType.kana),
  alphabet: Alphabets.katakana,
  groupUid: ResourceUid("1", ResourceType.group),
  kana: "ア",
  romaji: "a",
  version: "2023-12-01",
  position: 2,
);

/// Generates a dummy kana with the index given in parameter.
Kana generateDummyKana(int index) => Kana(
  uid: const ResourceUid("kana-1", ResourceType.kana),
  alphabet: Alphabets.hiragana,
  groupUid: const ResourceUid("group-1", ResourceType.group),
  kana: "あ",
  romaji: "a",
  version: "2023-12-01",
  position: index,
);
