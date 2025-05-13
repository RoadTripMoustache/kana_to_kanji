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
import "package:logger/logger.dart";
import "package:stacked/stacked.dart";

class DetailsViewModel extends FutureViewModel {
  // TODO: Remove once examples are fully set up
  final Logger _logger = locator<Logger>();

  final TtsService _ttsService = locator<TtsService>();
  final ExampleRepository _exampleRepository = locator<ExampleRepository>();

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

  @override
  Future futureToRun() async {
    // We don't have examples for Kana.
    if (item is Kana) {
      return;
    }

    // Temporary fix until the "new pronunciation" is implemented
    _logger.i("Fetching data for ${item.uid.uid}");
    final start = DateTime.now();
    final examples = await _exampleRepository.getResourceExamples(item.uid);

    for (final example in examples.data) {
      for (final pronunciation in pronunciations) {
        final indexesConcerned = example.kanji.indexed
            .where(((int, String) e) => e.$2.contains(title))
            .map((e) => e.$1);

        for (final index in indexesConcerned) {
          // TODO strip down . and -
          if (example.reading[index].contains(pronunciation.reading)) {
            pronunciation.examples.add(example);
          }
        }
      }
    }
    _logger.i(
      "Sorting done: ${DateTime.now().difference(start).inMilliseconds}",
    );
  }

  Future<void> onSpeakerPressed([String? reading]) async {
    if (item is Kana) {
      await _ttsService.speak((item as Kana).kana);
    } else if (reading != null && reading.isNotEmpty) {
      await _ttsService.speak(reading);
    }
  }
}
