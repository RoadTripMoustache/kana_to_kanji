import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/repositories/kana_repository.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:stacked/stacked.dart';

class QuizViewModel extends FutureViewModel {
  final List<Group> groups;

  final List<Kana> kana = [];

  final KanaRepository _kanaRepository = locator<KanaRepository>();

  QuizViewModel(this.groups);

  @override
  Future futureToRun() async {
    kana.addAll(await _kanaRepository
        .getByGroupIds(groups.map((e) => e.id).toList(growable: false)));
  }
}
