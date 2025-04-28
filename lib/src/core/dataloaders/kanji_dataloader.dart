import "dart:convert";

import "package:http/http.dart";
import "package:kana_to_kanji/src/core/dataloaders/resource_dataloader.dart";
import "package:kana_to_kanji/src/core/models/kanji.dart";
import "package:kana_to_kanji/src/core/services/kanji_service.dart";
import "package:kana_to_kanji/src/core/utils/kana_utils.dart";

class KanjiDataLoader extends ResourceDataLoader<Kanji> {
  /// [service] should only be used for testing
  KanjiDataLoader({KanjiService? service})
    : super(
        service: service ?? KanjiService(),
        fromJson: Kanji.fromJson,
        apiResourceType: "kanjis",
      );

  @override
  List<Kanji> extractItems(Response response) {
    if (response.statusCode == 200) {
      final List<Kanji> items = [];
      final rawItems = jsonDecode(response.body);
      for (final g in rawItems["data"]) {
        items.add(
          fromJson({...g, sqlJpSortSyllablesColumn: _buildSortSyllables(g)}),
        );
      }
      return items;
    } else {
      // If the server did not return a 200 OK response,
      // then return an empty list.
      return List.empty();
    }
  }

  List<int> _buildSortSyllables(Map<String, dynamic> json) {
    List<int> sortSyllables = [];

    // TODO : To clean up once migrated to pronunciations
    if (json["kun_readings"] != null &&
        // ignore: avoid_dynamic_calls
        !json["kun_readings"].isEmpty &&
        // ignore: avoid_dynamic_calls
        json["kun_readings"][0] != "") {
      // ignore: avoid_dynamic_calls
      sortSyllables = splitBySyllable(json["kun_readings"][0]);
      // ignore: avoid_dynamic_calls
    } else if (json["on_readings"] != null && !json["on_readings"].isEmpty) {
      // ignore: avoid_dynamic_calls
      sortSyllables = splitBySyllable(json["on_readings"][0]);
    } else if (json["pronunciations"] != null &&
        // ignore: avoid_dynamic_calls
        !json["pronunciations"].isEmpty) {
      // ignore: avoid_dynamic_calls
      sortSyllables = splitBySyllable(json["pronunciations"][0]["readings"][0]);
    }

    return sortSyllables;
  }
}
