import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:stacked/stacked.dart';

class QuizViewModel extends FutureViewModel {
  final List<Group> groups;

  QuizViewModel(this.groups);

  @override
  Future futureToRun() {
    // TODO: implement futureToRun
    // throw UnimplementedError();
    return Future.delayed(Duration(seconds: 1));
  }
}
