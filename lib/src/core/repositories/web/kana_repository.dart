import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/repositories/interfaces/kana_repository.dart';

class KanaRepository implements IKanaRepository {

  @override
  Future<List<Kana>> getByGroupIds(List<int> groupIds) async {
    // TODO : To implement
    return Future(() => List.empty());
  }

  @override
  Future<List<Kana>> getByGroupId(int groupId) async {
    // TODO : To implement
    return Future(() => List.empty());
  }
}
