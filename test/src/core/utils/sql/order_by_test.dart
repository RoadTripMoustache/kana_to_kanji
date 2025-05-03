import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/utils/sql/order_by.dart";
import "package:kana_to_kanji/src/core/utils/sql/sql_column.dart";

class TestSqlColumn implements SqlColumn {
  @override
  final String column;

  TestSqlColumn(this.column);
}

void main() {
  group("OrderBy", () {
    final nameColumn = TestSqlColumn("name");
    final ageColumn = TestSqlColumn("age");
    final dateColumn = TestSqlColumn("created_at");

    test("builds with default ascending direction", () {
      final orderBy = OrderBy(nameColumn);
      expect(orderBy.build(), "name ASC");
    });

    test("builds with explicit ascending direction", () {
      final orderBy = OrderBy(nameColumn);
      expect(orderBy.build(), "name ASC");
    });

    test("builds with descending direction", () {
      final orderBy = OrderBy(ageColumn, direction: OrderByDirection.desc);
      expect(orderBy.build(), "age DESC");
    });

    test("works with column name containing underscore", () {
      final orderBy = OrderBy(dateColumn);
      expect(orderBy.build(), "created_at ASC");
    });

    test("maintains original column name casing", () {
      final customColumn = TestSqlColumn("UserName");
      final orderBy = OrderBy(customColumn);
      expect(orderBy.build(), "UserName ASC");
    });

    test("handles column name with spaces correctly", () {
      final columnWithSpace = TestSqlColumn("first name");
      final orderBy = OrderBy(
        columnWithSpace,
        direction: OrderByDirection.desc,
      );
      expect(orderBy.build(), "first name DESC");
    });
  });
}
