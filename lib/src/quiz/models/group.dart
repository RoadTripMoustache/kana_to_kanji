import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';

@freezed
class Group with _$Group {
  const factory Group(
      {required int id, required String name, String? localizedName}) = _Group;
}
