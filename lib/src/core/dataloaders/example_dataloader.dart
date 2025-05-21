import "package:kana_to_kanji/src/core/constants/resource_type.dart";
import "package:kana_to_kanji/src/core/dataloaders/resource_dataloader.dart";
import "package:kana_to_kanji/src/core/models/paginated_data.dart";
import "package:kana_to_kanji/src/core/models/resources/example.dart";
import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";

class ExampleDataLoader extends ResourceDataLoader<Example> {
  ExampleDataLoader()
    : super(fromJson: Example.fromJson, apiResourceType: "examples");

  /// Fetch examples linked to the given resource [uid]
  Future<PaginatedData<Example>> fetchResourceExamples(ResourceUid uid) async {
    assert(
      [ResourceType.kanji, ResourceType.vocabulary].contains(uid.resourceType),
      "examples are only available for kanji and vocabulary",
    );

    String baseUrl = "/v1/";
    switch (uid.resourceType) {
      case ResourceType.kanji:
        baseUrl += "kanjis";
      case ResourceType.vocabulary:
        baseUrl += "vocabulary";
      // ignore: no_default_cases ignoring because of the assert above
      default:
        throw UnimplementedError(
          "Examples for ${uid.resourceType} are not available yet.",
        );
    }
    return fetchPaginated("$baseUrl/${uid.uid}/examples");
  }
}
