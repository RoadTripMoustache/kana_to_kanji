import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/core/repositories/kanji_repository.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:stacked/stacked.dart';

class KanjiTabViewModel extends FutureViewModel {
  final KanjiRepository _kanjiRepository = locator<KanjiRepository>();

  final List<Kanji> _kanjiList = [];

  List<Kanji> get kanjiList => _kanjiList;

  KanjiTabViewModel();

  @override
  Future futureToRun() async {
    final kanjiDbList = await _kanjiRepository.getAll();

    for (final kanji in kanjiDbList) {
      kanjiList.add(kanji);
    }
  }
}
