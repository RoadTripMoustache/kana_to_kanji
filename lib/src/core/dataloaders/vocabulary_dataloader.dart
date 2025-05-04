import "package:kana_to_kanji/src/core/dataloaders/resource_dataloader.dart";
import "package:kana_to_kanji/src/core/models/resources/vocabulary.dart";

// TODO: Remove as not needed anymore!
class VocabularyDataLoader extends ResourceDataLoader<Vocabulary> {
  VocabularyDataLoader()
    : super(fromJson: Vocabulary.fromJson, apiResourceType: "vocabulary");
}
