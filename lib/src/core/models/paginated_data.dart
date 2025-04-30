import "package:freezed_annotation/freezed_annotation.dart";

part "paginated_data.freezed.dart";

@Freezed(fromJson: false, toJson: false)
sealed class PaginatedData<T> with _$PaginatedData<T> {
  const PaginatedData._();

  const factory PaginatedData({
    required List<T> data,
    Future<PaginatedData<T>> Function()? next,
  }) = _PaginatedData;

  bool get hasMore => next != null;
}
