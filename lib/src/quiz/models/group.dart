import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kana_to_kanji/src/quiz/constants/alphabets.dart';

part 'group.freezed.dart';

@freezed
class Group with _$Group {
  const factory Group(
      {required int id, required Alphabets alphabet, required String name, String? localizedName}) = _Group;
}
