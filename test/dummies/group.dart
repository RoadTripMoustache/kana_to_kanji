import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/constants/kana_type.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/resources/resources.dart";

final Group dummyKatakanaGroup = Group(
  uid: const ResourceUid("group-1", ResourceType.group),
  alphabet: Alphabets.katakana,
  name: "Group name - Katakana",
  kanaType: KanaTypes.main,
  localizedName: "Group name - Katakana",
  version: "2025_01_01",
);
final Group dummyHiraganaGroup = Group(
  uid: const ResourceUid("group-2", ResourceType.group),
  alphabet: Alphabets.hiragana,
  name: "Group name - Hiragana",
  kanaType: KanaTypes.main,
  localizedName: "Group name - Hiragana",
  version: "2025_01_01",
);
final Group dummyKanjiGroup = Group(
  uid: const ResourceUid("group-3", ResourceType.group),
  alphabet: Alphabets.kanji,
  name: "Group name - Kanji",
  kanaType: KanaTypes.main,
  localizedName: "Group name - Kanji",
  version: "2025_01_01",
);

final String sqlInsertDummiesGroups = """
INSERT INTO groups (uid, alphabet, name, localized_name, kana_type, version)
VALUES
  ("${dummyKatakanaGroup.uid.uid}", "katakana", "Group name - Katakana", "Group name - Katakana", "main", "2025_01_01"),
  ("${dummyHiraganaGroup.uid.uid}", "hiragana", "Group name - Hiragana", "Group name - Hiragana", "main", "2025_01_01"),
  ("${dummyKanjiGroup.uid.uid}", "kanji", "Group name - Kanji", "Group name - Kanji", "main", "2025_01_01");
""";

final List<Group> dummyGroups = [
  dummyKatakanaGroup,
  dummyHiraganaGroup,
  dummyKanjiGroup,
];
