import 'package:kana_to_kanji/src/core/models/kana.dart';

class IKanaRepository {

  Future<List<Kana>> getByGroupIds(List<int> groupIds) async {
    return Future(() => List.empty());
  }

  Future<List<Kana>> getByGroupId(int groupId) async {
    return Future(() => List.empty());
  }
}
