import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/constants/kana_type.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/group.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

final Group dummyGroup = Group(
  const ResourceUid("group-1", ResourceType.group),
  Alphabets.katakana,
  "Group name",
  KanaTypes.main,
  "Group name",
  "v1",
);
