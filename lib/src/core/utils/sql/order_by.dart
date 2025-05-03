import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/utils/sql/sql_column.dart";

part "order_by.freezed.dart";

enum OrderByDirection { asc, desc }

@freezed
class OrderBy<L extends SqlColumn> with _$OrderBy {
  @override
  final L by;

  @override
  final OrderByDirection direction;

  const OrderBy(this.by, {this.direction = OrderByDirection.asc});

  String build() =>
      "${by.selectColumn}${direction == OrderByDirection.asc ? '' : ' DESC'}";
}
