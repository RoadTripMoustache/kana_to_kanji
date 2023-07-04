import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';

part 'kana.freezed.dart';

@freezed
class Kana with _$Kana {
  const factory Kana(
      {required int id,
      required Alphabets alphabet,
      required Group group,
      required String kana,
      required String romanji}) = _Kana;

  static const tableCreate = "CREATE TABLE kana("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "alphabet TEXT NOT NULL, "
      "group_id INTEGER, "
      "kana TEXT NOT NULL, "
      "romanji TEXT NOT NULL,"
      "FOREIGN KEY (group_id) REFERENCES groups (id) ON DELETE SET NULL)";
}
