import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/models/kanji.dart';
import 'package:kana_to_kanji/src/core/models/vocabulary.dart';
import 'package:stacked/stacked.dart';

class DetailsViewModel extends BaseViewModel {
  dynamic item;

  late final String title;

  DetailsViewModel(this.item)
      : assert(item is Kana || item is Kanji || item is Vocabulary) {
    switch (item) {
      case Kana kana:
        title = kana.kana;
        break;
      case Kanji kanji:
        title = kanji.kanji;
        break;
      case Vocabulary vocabulary:
        title =
            vocabulary.kanji.isNotEmpty ? vocabulary.kanji : vocabulary.kana;
        break;
    }
  }
}
