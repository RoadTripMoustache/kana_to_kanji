import "package:flutter/foundation.dart";
import "package:kana_to_kanji/src/core/dataloaders/resource_dataloader.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/core/services/kanji_service.dart";
import "package:kana_to_kanji/src/core/utils/kana_utils.dart";

class KanjiDataLoader extends ResourceDataLoader<Kanji> {
  KanjiDataLoader() : super(fromJson: deserialize, apiResourceType: "kanjis");

  @visibleForTesting
  static Kanji deserialize(Map<String, dynamic> item) => Kanji.fromJson({
    ...item,
    sqlJpSortSyllablesColumn: _buildSortSyllables(item),
  });

  static List<int> _buildSortSyllables(Map<String, dynamic> json) {
    List<int> sortSyllables = [];

    // TODO : To clean up once migrated to pronunciations
    if (json["pronunciations"] != null &&
        // ignore: avoid_dynamic_calls
        !json["pronunciations"].isEmpty) {
      // ignore: avoid_dynamic_calls
      sortSyllables = splitBySyllable(json["pronunciations"][0]["readings"][0]);
    }

    return sortSyllables;
  }
}
