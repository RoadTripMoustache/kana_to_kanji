import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'pronunciations.g.dart';

@JsonSerializable()
@embedded

/// Pronunciation of a kanji with all the meanings matching the readings
class Pronunciation {
  @JsonKey(name: "index")
  final int pronounciationIndex;
  @Default([])
  final List<String> meanings;
  @Default([])
  final List<String> readings;

  const Pronunciation(this.pronounciationIndex, this.meanings, this.readings);

  factory Pronunciation.fromJson(Map<String, dynamic> json) =>
      _$PronunciationFromJson(json);
}
