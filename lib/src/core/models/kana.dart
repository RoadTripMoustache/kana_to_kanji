import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';

part 'kana.freezed.dart';
part 'kana.g.dart';

@freezed
class Kana with _$Kana {
  const factory Kana(
      {required int id,
      required Alphabets alphabet,
      @JsonKey(name: "group_id") required int groupId,
      required String kana,
      required String romanji}) = _Kana;

  factory Kana.fromJson(Map<String, Object?> json) => _$KanaFromJson(json);

  static const tableCreate = "CREATE TABLE kana("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "alphabet TEXT NOT NULL, "
      "group_id INTEGER, "
      "kana TEXT NOT NULL, "
      "romanji TEXT NOT NULL,"
      "FOREIGN KEY (group_id) REFERENCES groups (id) ON DELETE SET NULL)";
}
