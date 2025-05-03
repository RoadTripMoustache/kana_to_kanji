import "package:flutter/foundation.dart";
import "package:kana_to_kanji/src/core/dataloaders/resource_dataloader.dart";
import "package:kana_to_kanji/src/core/models/resources/kanji.dart";

class KanjiDataLoader extends ResourceDataLoader<Kanji> {
  KanjiDataLoader()
    : super(fromJson: Kanji.fromJson, apiResourceType: "kanjis");

  @visibleForTesting
  static Kanji deserialize(Map<String, dynamic> item) => Kanji.fromJson(item);
}
