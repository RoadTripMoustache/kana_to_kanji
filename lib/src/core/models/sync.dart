import "package:freezed_annotation/freezed_annotation.dart";

part "sync.freezed.dart";
part "sync.g.dart";

@freezed
class Sync with _$Sync {
  const factory Sync({
    required bool achievements,
    required bool cleanup,
    @JsonKey(name: "groups") required bool groupsFlag,
    required bool kana,
    required bool kanji,
    required LearningSync learning,
    required bool vocabulary,
    @Default(false) bool forceReload,
  }) = _Sync;

  factory Sync.fromJson(Map<String, dynamic> json) => _$SyncFromJson(json);
}

class SyncConfiguration {
  final bool achievements;
  final String? achievementsVersion;
  final bool group;
  final String? groupVersion;
  final bool kana;
  final String? kanaVersion;
  final bool kanji;
  final String? kanjiVersion;
  final bool vocabulary;
  final String? vocabularyVersion;
  final bool cleanup;
  final bool forceReload;

  const SyncConfiguration({
    required this.achievements,
    required this.group,
    required this.kana,
    required this.kanji,
    required this.vocabulary,
    required this.cleanup,
    this.achievementsVersion,
    this.groupVersion,
    this.kanaVersion,
    this.kanjiVersion,
    this.vocabularyVersion,
    this.forceReload = false,
  });

  String? get latestVersion {
    String? version = "";
    if (achievementsVersion != null) {
      version = achievementsVersion;
    }
    if (groupVersion != null && groupVersion!.compareTo(version!) > 0) {
      version = groupVersion;
    }
    if (kanaVersion != null && kanaVersion!.compareTo(version!) > 0) {
      version = kanaVersion;
    }
    if (kanjiVersion != null && kanjiVersion!.compareTo(version!) > 0) {
      version = kanjiVersion;
    }
    if (vocabularyVersion != null &&
        vocabularyVersion!.compareTo(version!) > 0) {
      version = vocabularyVersion;
    }
    return version;
  }
}

@freezed
class LearningSync with _$LearningSync {
  const factory LearningSync({required bool stages}) = _LearningSync;

  factory LearningSync.fromJson(Map<String, dynamic> json) =>
      _$LearningSyncFromJson(json);
}
