import "package:freezed_annotation/freezed_annotation.dart";

part "paginated_api_response.freezed.dart";
part "paginated_api_response.g.dart";

@Freezed(toJson: false, genericArgumentFactories: true)
sealed class PaginatedApiResponse<T> with _$PaginatedApiResponse<T> {
  const PaginatedApiResponse._();

  const factory PaginatedApiResponse({
    required PageLinks links,
    required List<T> data,
  }) = _PaginatedApiResponse;

  factory PaginatedApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$PaginatedApiResponseFromJson(json, fromJsonT);

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
