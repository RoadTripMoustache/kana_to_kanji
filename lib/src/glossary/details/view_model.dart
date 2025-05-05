import "package:kana_to_kanji/src/core/models/resources/kana.dart";
import "package:kana_to_kanji/src/core/models/resources/kanji.dart";
import "package:kana_to_kanji/src/core/models/resources/resource.dart";
import "package:kana_to_kanji/src/core/models/resources/vocabulary.dart";
import "package:kana_to_kanji/src/glossary/details/extensions.dart";
import "package:kana_to_kanji/src/glossary/details/models/pronunciation_details.dart";
import "package:stacked/stacked.dart";

class DetailsViewModel extends BaseViewModel {
  Resource item;

  late final String title;

  final List<PronunciationDetails> pronunciations = [];

  bool get isKana => item is Kana;

  DetailsViewModel(this.item)
    : assert(
        item is Kana || item is Kanji || item is Vocabulary,
        "item must be a Kana, Kanji, or Vocabulary",
      ) {
    switch (item) {
      case final Kana kana:
        title = kana.kana;
      case final Kanji kanji:
        title = kanji.kanji;
      case final Vocabulary vocabulary:
        title =
            vocabulary.kanji.isNotEmpty ? vocabulary.kanji : vocabulary.kana;
    }
    pronunciations.addAll(item.pronunciationsDetails);
  }

  Future<void> onSpeakerPressed([String? reading]) async {
    if (isKana) {
      // ignore: avoid_print
      print("Kana reading");
    } else if (reading != null && reading.isNotEmpty) {
      // ignore: avoid_print
      print("Pronunciation reading: $reading");
    }
  }
}
