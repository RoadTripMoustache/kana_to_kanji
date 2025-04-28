import "package:flutter/cupertino.dart";
import "package:kana_to_kanji/src/core/dataloaders/resource_dataloader.dart";
import "package:kana_to_kanji/src/core/models/vocabulary.dart";
import "package:kana_to_kanji/src/core/services/vocabulary_service.dart";
import "package:kana_to_kanji/src/core/utils/kana_utils.dart";

class VocabularyDataLoader extends ResourceDataLoader<Vocabulary> {
  /// [service] should only be used for testing
  VocabularyDataLoader({VocabularyService? service})
    : super(
        service: service ?? VocabularyService(),
        fromJson: deserialize,
        apiResourceType: "vocabulary",
      );

  @visibleForTesting
  static Vocabulary deserialize(Map<String, dynamic> item) =>
      Vocabulary.fromJson({
        ...item,
        // ignore: avoid_dynamic_calls
        sqlKanaSyllablesColumn: splitBySyllable(item[sqlKanaColumn] as String),
      });
}
