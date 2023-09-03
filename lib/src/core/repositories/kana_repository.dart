import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/services/kana_service.dart';

class KanaRepository {
  final KanaService _kanaService = KanaService();

  Future<List<Kana>> getByGroupIds(List<int> groupIds) async {
    return _kanaService.getByGroupIds(groupIds);
  }

  Future<List<Kana>> getByGroupId(int groupId) async {
    return _kanaService.getByGroupId(groupId);
  }
}
