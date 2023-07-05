import 'package:kana_to_kanji/src/core/constants/kana_queries.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/services/database_service.dart';
import 'package:kana_to_kanji/src/locator.dart';

class KanaRepository {
  final DatabaseService _databaseService = locator<DatabaseService>();

  final List<Kana> _kana = [];

  Future<List<Kana>> getByGroupIds(List<int> groupIds) async {
    final kana =
        _kana.where((element) => groupIds.contains(element.groupId)).toList();

    if (kana.isEmpty) {
      kana.addAll(await _databaseService.getMultiple(
          getKanaByGroups, Kana.fromJson,
          arguments: [groupIds]));
      _kana.addAll(kana);
    }

    return kana;
  }

  Future<List<Kana>> getByGroupId(int groupId) async {
    final kana = _kana.where((element) => element.groupId == groupId).toList();

    if (kana.isEmpty) {
      kana.addAll(await _databaseService
          .getMultiple(getKanaByGroup, Kana.fromJson, arguments: [groupId]));
      _kana.addAll(kana);
    }

    return kana;
  }
}
