
import "package:kana_to_kanji/src/core/models/resource_uid.dart";

abstract class Resource {
  const Resource();

  ResourceUid get uid;

  String get version;

  Map<String, dynamic> toJson();
}
