import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/repositories/kana_repository.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:stacked/stacked.dart';

class KatakanaTabViewModel extends FutureViewModel {
  final KanaRepository _kanaRepository = locator<KanaRepository>();

  final List<Kana> _katakanaList = [];

  List<Kana> get katakanaList => _katakanaList;

  KatakanaTabViewModel();

  @override
  Future futureToRun() async {
    final katatanaDbList = await _kanaRepository.getKatakana();

    for (final kana in katatanaDbList) {
      katakanaList.add(kana);
    }
  }
}
