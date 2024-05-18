import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/kana.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

const Kana dummyHiragana = Kana(
    ResourceUid("0", ResourceType.kana),
    Alphabets.hiragana,
    ResourceUid("0", ResourceType.group),
    "あ",
    "a",
    "2023-12-01",
    1);

const Kana dummyKatakana = Kana(
    ResourceUid("1", ResourceType.kana),
    Alphabets.katakana,
    ResourceUid("1", ResourceType.group),
    "ア",
    "a",
    "2023-12-01",
    2);

/// Generates a dummy kana with the index given in parameter.
Kana generateDummyKana(int index) => Kana(
    const ResourceUid("kana-1", ResourceType.kana),
    Alphabets.hiragana,
    const ResourceUid("group-1", ResourceType.group),
    "あ",
    "a",
    "2023-12-01",
    index);
