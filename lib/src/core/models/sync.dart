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

  const Sync(
      {required this.achievements,
      required this.cleanup,
      required this.groupsFlag,
      required this.kana,
      required this.kanji,
      required this.learning,
      required this.vocabulary});

  factory Sync.fromJson(Map<String, dynamic> json) => _$SyncFromJson(json);
}

@embedded
@JsonSerializable()
class LearningSync {
  final bool stages;

  const LearningSync({required this.stages});

  factory LearningSync.fromJson(Map<String, dynamic> json) =>
      _$LearningSyncFromJson(json);
}
