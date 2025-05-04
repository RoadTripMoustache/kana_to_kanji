import "package:freezed_annotation/freezed_annotation.dart";

part "paginated_data.freezed.dart";

typedef FetchNextPageCallback<T> = Future<PaginatedData<T>> Function();

@Freezed(fromJson: false, toJson: false)
sealed class PaginatedData<T> with _$PaginatedData<T> {
  const PaginatedData._();

  const factory PaginatedData({
    required List<T> data,
    FetchNextPageCallback<T>? next,
  }) = _PaginatedData;

  bool get hasMore => next != null;
}
