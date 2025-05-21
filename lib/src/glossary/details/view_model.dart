import "dart:async";

import "package:kana_to_kanji/src/core/models/resources/kana.dart";
import "package:kana_to_kanji/src/core/models/resources/kanji.dart";
import "package:kana_to_kanji/src/core/models/resources/resource.dart";
import "package:kana_to_kanji/src/core/models/resources/vocabulary.dart";
import "package:kana_to_kanji/src/core/repositories/example_repository.dart";
import "package:kana_to_kanji/src/core/services/tts_service.dart";
import "package:kana_to_kanji/src/glossary/details/extensions.dart";
import "package:kana_to_kanji/src/glossary/details/models/pronunciation_details.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:stacked/stacked.dart";

class DetailsViewModel extends FutureViewModel {
  final TtsService _ttsService = locator<TtsService>();
  final ExampleRepository _exampleRepository = locator<ExampleRepository>();

  final Resource item;

  late final String title;

  final List<PronunciationDetails> details = [];

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
    details.addAll(item.pronunciationsDetails);
  }

  @override
  Future futureToRun() async {
    // We don't have examples for Kana.
    if (item is Kana) {
      return;
    }

    final List<Future> futures = [];
    for (final detail in details) {
      if (detail.exampleUids.isNotEmpty) {
        futures.add(_fetchExample(detail));
      }
    }

    await Future.wait(futures);
  }

  Future<void> _fetchExample(PronunciationDetails details) async {
    final example = await _exampleRepository.get(details.exampleUids.first);
    details.examples.add(example);
    notifyListeners();
  }

  Future<void> onSpeakerPressed([String? reading]) async {
    if (item is Kana) {
      await _ttsService.speak((item as Kana).kana);
    } else if (reading != null && reading.isNotEmpty) {
      await _ttsService.speak(reading);
    }
  }
}
