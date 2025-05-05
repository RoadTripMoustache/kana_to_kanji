import "package:freezed_annotation/freezed_annotation.dart";

part "pronunciation_details.freezed.dart";

@freezed
class PronunciationDetails with _$PronunciationDetails {
  @override
  final String reading;

  @override
  final List<String> meanings;

  @override
  final List<String> examples;

  const PronunciationDetails({
    required this.reading,
    required this.meanings,
    this.examples = const [],
  });
}
