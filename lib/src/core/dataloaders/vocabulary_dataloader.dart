import "dart:convert";

import "package:http/http.dart";
import "package:kana_to_kanji/src/core/dataloaders/resource_dataloader.dart";
import "package:kana_to_kanji/src/core/models/vocabulary.dart";
import "package:kana_to_kanji/src/core/services/vocabulary_service.dart";
import "package:kana_to_kanji/src/core/utils/kana_utils.dart";

class VocabularyDataLoader extends ResourceDataLoader<Vocabulary> {
  /// [service] should only be used for testing
  VocabularyDataLoader({VocabularyService? service})
    : super(
        service: service ?? VocabularyService(),
        fromJson: Vocabulary.fromJson,
        apiResourceType: "vocabulary",
      );

  @override
  List<Vocabulary> extractItems(Response response) {
    if (response.statusCode == 200) {
      final List<Vocabulary> items = [];
      final rawItems = jsonDecode(response.body);
      for (final g in rawItems) {
        items.add(
          fromJson({
            ...g,
            // ignore: avoid_dynamic_calls
            sqlKanaSyllablesColumn: splitBySyllable(g[sqlKanaColumn] as String),
          }),
        );
      }
      return items;
    } else {
      // If the server did not return a 200 OK response,
      // then return an empty list.
      return List.empty();
    }
  }
}
