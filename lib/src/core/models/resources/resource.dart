import "package:kana_to_kanji/src/core/models/resources/resource_uid.dart";

abstract class Resource {
  const Resource();

  ResourceUid get uid;

  String get version;

  Map<String, dynamic> toJson();
}
