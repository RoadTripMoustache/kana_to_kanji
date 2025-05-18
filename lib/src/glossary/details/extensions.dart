import "package:kana_to_kanji/src/core/models/resources/kanji.dart";
import "package:kana_to_kanji/src/core/models/resources/pronunciation.dart";
import "package:kana_to_kanji/src/core/models/resources/resource.dart";
import "package:kana_to_kanji/src/core/models/resources/vocabulary.dart";
import "package:kana_to_kanji/src/glossary/details/models/pronunciation_details.dart";

extension ResourceToPronunciationDetails on Resource {
  List<PronunciationDetails> get pronunciationsDetails {
    switch (this) {
      case final Kanji kanji:
        // Sort pronunciations by index before expanding
        final sortedPronunciations =
            List<Pronunciation>.from(kanji.pronunciations)
              ..sort((a, b) => a.position.compareTo(b.position))
              ..map(
                (pronunciation) => PronunciationDetails(
                  reading: pronunciation.reading,
                  meanings: pronunciation.meanings,
                ),
              );

        return sortedPronunciations
            .map(
              (pronunciation) => PronunciationDetails(
                reading: pronunciation.reading,
                meanings: pronunciation.meanings,
              ),
            )
            .toList();

      case final Vocabulary vocabulary:
        // For vocabulary, we create a single pronunciation with the kana
        // reading and all the meanings
        return [
          PronunciationDetails(
            reading: vocabulary.kana,
            meanings: vocabulary.meanings,
          ),
        ];

      default:
        // Return empty list for any other resource type
        return [];
    }
  }
}
