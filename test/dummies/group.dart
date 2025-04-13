import "package:kana_to_kanji/src/core/constants/alphabets.dart";
import "package:kana_to_kanji/src/core/constants/kana_type.dart";
import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/group.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

final Group dummyGroup = Group(
  uid: const ResourceUid("group-1", ResourceType.group),
  alphabet: Alphabets.katakana,
  name: "Group name",
  kanaType: KanaTypes.main,
  localizedName: "Group name",
  version: "v1",
);
