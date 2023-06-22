import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kana_to_kanji/src/quiz/constants/alphabets.dart';
import 'package:kana_to_kanji/src/quiz/models/group.dart';

part 'kana.freezed.dart';

@freezed
class Kana with _$Kana {
  const factory Kana({
    required Alphabets alphabet,
    required Group group,
    required String kana,
    required String romanji
  }) = _Kana;
}