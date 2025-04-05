import "package:freezed_annotation/freezed_annotation.dart";

part "example.freezed.dart";
part "example.g.dart";

@freezed
class Example with _$Example {
  const factory Example({
    required String japanese,
    required String translation,
  }) = _Example;

  factory Example.fromJson(Map<String, dynamic> json) =>
      _$ExampleFromJson(json);
}
