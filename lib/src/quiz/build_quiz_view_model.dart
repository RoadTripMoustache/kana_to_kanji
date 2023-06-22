import 'package:kana_to_kanji/src/locator.dart';
import 'package:kana_to_kanji/src/quiz/constants/alphabets.dart';
import 'package:kana_to_kanji/src/quiz/models/group.dart';
import 'package:kana_to_kanji/src/quiz/repositories/kana_repository.dart';
import 'package:stacked/stacked.dart';

class BuildQuizViewModel extends BaseViewModel {
  final KanaRepository _kanaRepository = locator<KanaRepository>();

  final Map<Alphabets, List<Group>> _categoryTiles = {};

  bool get readyToStart => _selectedGroups.isNotEmpty;

  final List<Group> _selectedGroups = [];

  List<Group> get selectedGroups => _selectedGroups;

  List<Group> getGroup(Alphabets alphabet) {
    if (!_categoryTiles.containsKey(alphabet)) {
      _categoryTiles.putIfAbsent(
          alphabet, () => _kanaRepository.getGroups(alphabet));
    }

    return _categoryTiles[alphabet]!;
  }

  void onGroupCardTapped(Group groupTapped) {
    if (_selectedGroups.contains(groupTapped)) {
      _selectedGroups.remove(groupTapped);
    } else {
      _selectedGroups.add(groupTapped);
    }
    notifyListeners();
  }
}
