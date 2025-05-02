import "package:kana_to_kanji/src/core/models/resources/kana.dart";
import "package:kana_to_kanji/src/core/models/resources/kanji.dart";
import "package:kana_to_kanji/src/core/models/resources/vocabulary.dart";
import "package:stacked/stacked.dart";

class DetailsViewModel extends BaseViewModel {
  dynamic item;

  late final String title;

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
  }
}
