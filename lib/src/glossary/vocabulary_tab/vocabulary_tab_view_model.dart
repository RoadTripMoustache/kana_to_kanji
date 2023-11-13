import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:kana_to_kanji/src/core/repositories/vocabulary_repository.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:stacked/stacked.dart';

class VocaabularyTabViewModel extends FutureViewModel {
  final VocabularyRepository _vocabularyRepository =
      locator<VocabularyRepository>();

  final List<Vocabulary> _vocabularyList = [];

  List<Vocabulary> get vocabularyList => _vocabularyList;

  VocaabularyTabViewModel();

  @override
  Future futureToRun() async {
    final vocabularyDbList = await _vocabularyRepository.getAll();

    for (final vocabulary in vocabularyDbList) {
      vocabularyList.add(vocabulary);
    }
  }
}
