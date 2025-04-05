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

@freezed
class LearningSync with _$LearningSync {
  const factory LearningSync({required bool stages}) = _LearningSync;

  factory LearningSync.fromJson(Map<String, dynamic> json) =>
      _$LearningSyncFromJson(json);
}
