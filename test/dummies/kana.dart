import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/kana.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

import "group.dart";

final Kana dummyHiragana = Kana(
  uid: ResourceUid.fromJson("kana-0"),
  alphabet: Alphabets.hiragana,
  groupUid: dummyHiraganaGroup.uid,
  kana: "あ",
  romaji: "a",
  version: "2023-12-01",
  position: 1,
);

final Kana dummyKatakana = Kana(
  uid: ResourceUid.fromJson("kana-1"),
  alphabet: Alphabets.katakana,
  groupUid: dummyKatakanaGroup.uid,
  kana: "ア",
  romaji: "a",
  version: "2023-12-01",
  position: 2,
);

final List<Kana> dummiesKana = [dummyHiragana, dummyKatakana];

/// Generates a dummy kana with the index given in parameter.
Kana generateDummyKana(int index) => Kana(
  uid: ResourceUid.fromJson("kana-$index"),
  alphabet: Alphabets.hiragana,
  groupUid: const ResourceUid("group-1", ResourceType.group),
  kana: "あ",
  romaji: "a",
  version: "2023-12-01",
  position: index,
);
