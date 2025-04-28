import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/models/resource.dart";

part "paginated_response.freezed.dart";

part "paginated_response.g.dart";

@Freezed(toJson: false, genericArgumentFactories: true)
sealed class PaginatedResponse<T extends Resource> with _$PaginatedResponse<T> {
  const PaginatedResponse._();

  const factory PaginatedResponse({
    required PageLinks links,
    required List<T> data,
  }) = _PaginatedResponse;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$PaginatedResponseFromJson(json, fromJsonT);

  bool get hasMore => links.hasMore;
}

@Freezed(toJson: false)
sealed class PageLinks with _$PageLinks {
  const factory PageLinks({
    required String first,
    required String previous,
    required String self,
    required String next,
    required String last,
    required bool hasMore,
  }) = _PageLinks;

  factory PageLinks.fromJson(Map<String, dynamic> json) =>
      _$PageLinksFromJson(json);
}
