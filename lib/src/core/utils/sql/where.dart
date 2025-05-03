import "package:freezed_annotation/freezed_annotation.dart";
import "package:kana_to_kanji/src/core/utils/sql/sql_column.dart";

part "where.freezed.dart";

enum WhereOperator {
  equal("="),
  notEqual("!="),
  greaterThan(">"),
  greaterThanOrEqual(">="),
  lessThan("<"),
  lessThanOrEqual("<="),
  like("LIKE"),
  inList("IN"),
  notInList("NOT IN");

  final String symbol;

  const WhereOperator(this.symbol);

  String build(String left, String right, {bool isRightString = false}) =>
      left.isNotEmpty && right.isNotEmpty
          ? "$left $symbol ${isRightString ? "'$right'" : right}"
          : "";
}

enum WhereCondition { and, or }

extension SqlListExtension on List {
  String toSql() {
    if (isEmpty) {
      return "";
    }
    return "(${map((item) => "?").join(",")})";
  }

  List<dynamic> toSqlArgs() {
    if (isEmpty) {
      return [];
    }
    return map(
      (item) => item is Object && item.isBasicType ? item : item.toString(),
    ).toList();
  }
}

extension ObjectExtension on Object {
  /// Determine if the object is a basic type (String, int, double, bool)
  bool get isBasicType =>
      this is String || this is int || this is double || this is bool;
}

@freezed
class Where<L extends SqlColumn, R extends Object> with _$Where<L, R> {
  /// Left side should always be a column
  @override
  final L left;

  @override
  final WhereOperator operator;

  @override
  final R right;

  /// Condition of the where clause, if any the condition symbol
  /// will be added before the left side
  @override
  final WhereCondition? condition;

  Where(this.left, this.operator, this.right, {this.condition})
    : assert(
        right is List &&
                [
                  WhereOperator.inList,
                  WhereOperator.notInList,
                ].contains(operator) ||
            right is! List &&
                ![
                  WhereOperator.inList,
                  WhereOperator.notInList,
                ].contains(operator),
        "right must be a List when operator is ${operator.name}",
      );

  String build() {
    final String processed = operator.build(
      left.column,
      right is List ? (right as List).toSql() : right.toString(),
      isRightString: right is String,
    );

    if (condition != null) {
      return "${condition!.name.toUpperCase()} $processed";
    }
    return processed;
  }

  List<dynamic> buildArgs() {
    if (right is List) {
      return (right as List).toSqlArgs();
    }
    return [if (right.isBasicType) right else right.toString()];
  }
}
