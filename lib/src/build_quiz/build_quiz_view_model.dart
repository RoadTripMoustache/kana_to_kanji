import 'package:go_router/go_router.dart';
import 'package:kana_to_kanji/src/quiz/quiz_view.dart';
import 'package:stacked/stacked.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/core/repositories/groups_repository.dart';

class BuildQuizViewModel extends FutureViewModel {
  final GoRouter router;

  final GroupsRepository _groupsRepository = locator<GroupsRepository>();

  final Map<Alphabets, List<Group>> _categoryTiles = {};

  bool get readyToStart => _selectedGroups.isNotEmpty;

  final List<Group> _selectedGroups = [];

  List<Group> get selectedGroups => _selectedGroups;

  BuildQuizViewModel(this.router);

  @override
  Future futureToRun() async {
    for (final alphabet in [Alphabets.hiragana, Alphabets.katakana]) {
      final groups = await _groupsRepository.getGroups(alphabet);

      _categoryTiles.putIfAbsent(alphabet, () => groups);
    }
  }

  List<Group> getGroup(Alphabets alphabet) {
    return _categoryTiles[alphabet] ?? [];
  }

  void onGroupCardTapped(Group groupTapped) {
    if (_selectedGroups.contains(groupTapped)) {
      _selectedGroups.remove(groupTapped);
    } else {
      _selectedGroups.add(groupTapped);
    }
    notifyListeners();
  }

  void onSelectAllTapped(List<Group> groups, bool toAdd) {
    if (toAdd) {
      for (final Group group in groups) {
        if (!_selectedGroups.contains(group)) {
          _selectedGroups.add(group);
        }
      }
    } else {
      _selectedGroups.removeWhere((group) => groups.contains(group));
    }
    notifyListeners();
  }

  void onSelectAllAlphabetTapped(Alphabets alphabet) {
    final areAllSelected = selectedGroups
            .where((element) => element.alphabet == alphabet)
            .length ==
        _categoryTiles[alphabet]!.length;

    if (!areAllSelected) {
      for (final Group group in _categoryTiles[alphabet] ?? []) {
        if (!_selectedGroups.contains(group)) {
          _selectedGroups.add(group);
        }
      }
    } else {
      _selectedGroups.removeWhere((element) => element.alphabet == alphabet);
    }
    notifyListeners();
  }

  void resetSelected() {
    _selectedGroups.clear();
    notifyListeners();
  }

  void startQuiz() {
    router.go(QuizView.routeName, extra: _selectedGroups);
  }
}
