import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/constants/kana_type.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/group.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

final Group dummyKatakanaGroup = Group(
  uid: const ResourceUid("group-1", ResourceType.group),
  alphabet: Alphabets.katakana,
  name: "Group name - Katakana",
  kanaType: KanaTypes.main,
  localizedName: "Group name - Katakana",
  version: "v1",
);
final Group dummyHiraganaGroup = Group(
  uid: const ResourceUid("group-2", ResourceType.group),
  alphabet: Alphabets.hiragana,
  name: "Group name - Hiragana",
  kanaType: KanaTypes.main,
  localizedName: "Group name - Hiragana",
  version: "v1",
);
final Group dummyKanjiGroup = Group(
  uid: const ResourceUid("group-3", ResourceType.group),
  alphabet: Alphabets.kanji,
  name: "Group name - Kanji",
  kanaType: KanaTypes.main,
  localizedName: "Group name - Kanji",
  version: "v1",
);
