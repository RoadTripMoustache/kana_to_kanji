import "package:freezed_annotation/freezed_annotation.dart";
import "package:isar/isar.dart";

part "example.g.dart";

@JsonSerializable()
@embedded

/// Example of a usage of a resource
class Example {
  final String japanese;
  final String translation;

  const Example(this.japanese, this.translation);

  factory Example.fromJson(Map<String, dynamic> json) =>
      _$ExampleFromJson(json);
}
