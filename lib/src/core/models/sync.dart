import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'sync.g.dart';

@embedded
@JsonSerializable()
class Sync {
  final bool achievements;
  final bool cleanup;
  @JsonKey(name: "groups")
  final bool groupsFlag;
  final bool kana;
  final bool kanji;
  final LearningSync learning;
  final bool vocabulary;
  @JsonKey(defaultValue: false)
  final bool forceReload;

  const Sync(this.achievements, this.cleanup, this.groupsFlag, this.kana,
      this.kanji, this.learning, this.vocabulary, this.forceReload);

  factory Sync.fromJson(Map<String, dynamic> json) => _$SyncFromJson(json);
}

@embedded
@JsonSerializable()
class LearningSync {
  final bool stages;

  const LearningSync(this.stages);

  factory LearningSync.fromJson(Map<String, dynamic> json) =>
      _$LearningSyncFromJson(json);
}
