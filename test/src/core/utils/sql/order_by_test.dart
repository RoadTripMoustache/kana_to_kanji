import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/utils/sql/order_by.dart";
import "package:kana_to_kanji/src/core/utils/sql/sql_column.dart";

class TestSqlColumn implements SqlColumn {
  @override
  final String column;

  @override
  final String prefix;

  TestSqlColumn(this.column, {this.prefix = "t"});

  @override
  String get selectColumn => "$prefix.$column";
}

void main() {
  group("OrderBy", () {
    final nameColumn = TestSqlColumn("name");
    final ageColumn = TestSqlColumn("age");
    final dateColumn = TestSqlColumn("created_at");

    test("builds with default ascending direction", () {
      final orderBy = OrderBy(nameColumn);
      expect(orderBy.build(), "t.name");
    });

    test("builds with explicit ascending direction", () {
      final orderBy = OrderBy(nameColumn);
      expect(orderBy.build(), "t.name");
    });

    test("builds with descending direction", () {
      final orderBy = OrderBy(ageColumn, direction: OrderByDirection.desc);
      expect(orderBy.build(), "t.age DESC");
    });

    test("works with column name containing underscore", () {
      final orderBy = OrderBy(dateColumn);
      expect(orderBy.build(), "t.created_at");
    });

    test("maintains original column name casing", () {
      final customColumn = TestSqlColumn("UserName");
      final orderBy = OrderBy(customColumn);
      expect(orderBy.build(), "t.UserName");
    });

    test("handles column name with spaces correctly", () {
      final columnWithSpace = TestSqlColumn("first name");
      final orderBy = OrderBy(
        columnWithSpace,
        direction: OrderByDirection.desc,
      );
      expect(orderBy.build(), "t.first name DESC");
    });
  });
}
