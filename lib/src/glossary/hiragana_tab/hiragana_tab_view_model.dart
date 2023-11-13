import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/repositories/kana_repository.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:stacked/stacked.dart';

class HiraganaTabViewModel extends FutureViewModel {
  final KanaRepository _kanaRepository = locator<KanaRepository>();

  final List<Kana> _hiraganaList = [];

  List<Kana> get hiraganaList => _hiraganaList;

  HiraganaTabViewModel();

  @override
  Future futureToRun() async {
    final hiraganaDbList = await _kanaRepository.getHiragana();

    for (final kana in hiraganaDbList) {
      _hiraganaList.add(kana);
    }
  }
}
