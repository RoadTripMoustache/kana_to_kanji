import "dart:async";

import "package:kana_to_kanji/src/core/models/resources/kana.dart";
import "package:kana_to_kanji/src/core/models/resources/kanji.dart";
import "package:kana_to_kanji/src/core/models/resources/resource.dart";
import "package:kana_to_kanji/src/core/models/resources/vocabulary.dart";
import "package:kana_to_kanji/src/core/services/tts_service.dart";
import "package:kana_to_kanji/src/glossary/details/extensions.dart";
import "package:kana_to_kanji/src/glossary/details/models/pronunciation_details.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:stacked/stacked.dart";

class DetailsViewModel extends BaseViewModel {
  final TtsService _ttsService = locator<TtsService>();

  final Resource item;

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
    if (item is Kana) {
      await _ttsService.speak((item as Kana).kana);
    } else if (reading != null && reading.isNotEmpty) {
      await _ttsService.speak(reading);
    }
  }
}
