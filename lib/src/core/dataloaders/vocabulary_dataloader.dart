import "package:flutter/cupertino.dart";
import "package:kana_to_kanji/src/core/dataloaders/resource_dataloader.dart";
import "package:kana_to_kanji/src/core/models/resources/vocabulary.dart";
import "package:kana_to_kanji/src/core/services/resources/vocabulary_service.dart";
import "package:kana_to_kanji/src/core/utils/kana_utils.dart";

class VocabularyDataLoader extends ResourceDataLoader<Vocabulary> {
  VocabularyDataLoader()
    : super(fromJson: deserialize, apiResourceType: "vocabulary");

  @visibleForTesting
  static Vocabulary deserialize(Map<String, dynamic> item) =>
      Vocabulary.fromJson({
        ...item,
        // ignore: avoid_dynamic_calls
        sqlKanaSyllablesColumn: splitBySyllable(item[sqlKanaColumn] as String),
      });
}
