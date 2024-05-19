import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/models/resource_uid.dart";
import "package:kana_to_kanji/src/core/models/vocabulary.dart";

const Vocabulary dummyVocabulary = Vocabulary(
    ResourceUid("vocabulary-1", ResourceType.vocabulary),
    "亜",
    "あ",
    1,
    ["inferior"],
    "a",
    [],
    "2023-12-1",
    [],
    [],
    [],
    []);

const Vocabulary dummyVocabularyWithoutKanji = Vocabulary(
    ResourceUid("vocabulary-1", ResourceType.vocabulary),
    "",
    "あ",
    1,
    ["inferior"],
    "a",
    [],
    "2023-12-1",
    [],
    [],
    [],
    []);
