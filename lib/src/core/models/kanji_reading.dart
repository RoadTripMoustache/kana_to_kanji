import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'kanji_reading.g.dart';

@JsonSerializable()
@embedded
/// Reading of a kanji in a word.
class KanjiReading {
  final int id;
  final String kanji;
  final String reading;


  const KanjiReading(
      this.id,
      this.kanji,
      this.reading);

  factory KanjiReading.fromJson(Map<String, dynamic> json) => _$KanjiReadingFromJson(json);
}
