import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/utils/sql/sql_column.dart";
import "package:kana_to_kanji/src/core/utils/sql/where.dart";

class TestSqlColumn implements SqlColumn {
  @override
  final String column;

  TestSqlColumn(this.column);
}

void main() {
  group("WhereOperator", () {
    group("builds", () {
      test("equal builds correct SQL expression", () {
        expect(WhereOperator.equal.build("count", "1"), "count = 1");
      });

      test("notEqual builds correct SQL expression", () {
        expect(WhereOperator.notEqual.build("age", "30"), "age != 30");
      });

      test("greaterThan builds correct SQL expression", () {
        expect(
          WhereOperator.greaterThan.build("price", "50.5"),
          "price > 50.5",
        );
      });

      test("lessThanOrEqual builds correct SQL expression", () {
        expect(
          WhereOperator.lessThanOrEqual.build("quantity", "100"),
          "quantity <= 100",
        );
      });

      test("like builds correct SQL expression", () {
        expect(WhereOperator.like.build("name", "John"), "name LIKE John");
      });

      test("inList builds correct SQL expression", () {
        expect(WhereOperator.inList.build("id", "(?,?,?)"), "id IN (?,?,?)");
      });

      test("returns empty string when left is empty", () {
        expect(WhereOperator.equal.build("", "value"), "");
      });

      test("returns empty string when right is empty", () {
        expect(WhereOperator.equal.build("name", ""), "");
      });
    });
  });

  group("SqlListExtension", () {
    group("toSql", () {
      test("toSql returns empty string for empty list", () {
        expect([].toSql(), "");
      });

      test("toSql returns correct format for non-empty list", () {
        expect([1, 2, 3].toSql(), "(?,?,?)");
      });
    });

    group("toSqlArgs", () {
      test("returns empty list for empty list", () {
        expect([].toSqlArgs(), []);
      });

      test("preserves basic types", () {
        expect([1, "test", true, 3.14].toSqlArgs(), [1, "test", true, 3.14]);
      });

      test("converts non-basic types to strings", () {
        final date = DateTime(2023);
        expect([date].toSqlArgs(), [date.toString()]);
      });
    });
  });

  group("ObjectExtension", () {
    test("isBasicType returns true for strings", () {
      expect("test".isBasicType, isTrue);
    });

    test("isBasicType returns true for integers", () {
      expect(42.isBasicType, isTrue);
    });

    test("isBasicType returns true for doubles", () {
      expect(3.14.isBasicType, isTrue);
    });

    test("isBasicType returns true for booleans", () {
      expect(true.isBasicType, isTrue);
    });

    test("isBasicType returns false for other types", () {
      expect(DateTime.now().isBasicType, isFalse);
      expect([].isBasicType, isFalse);
      expect({}.isBasicType, isFalse);
    });
  });

  group("Where", () {
    final idColumn = TestSqlColumn("id");
    final nameColumn = TestSqlColumn("name");

    test("builds simple equality condition", () {
      final where = Where(idColumn, WhereOperator.equal, 1);
      expect(where.build(), "id = ?");
      expect(where.buildArgs(), [1]);
    });

    test("builds string condition with quotes", () {
      final where = Where(nameColumn, WhereOperator.equal, "John");
      expect(where.build(), "name = ?");
      expect(where.buildArgs(), ["John"]);
    });

    test("builds in list condition", () {
      final where = Where(idColumn, WhereOperator.inList, [1, 2, 3]);
      expect(where.build(), "id IN (?,?,?)");
      expect(where.buildArgs(), [1, 2, 3]);
    });

    test("builds not in list condition", () {
      final where = Where(idColumn, WhereOperator.notInList, [1, 2, 3]);
      expect(where.build(), "id NOT IN (?,?,?)");
      expect(where.buildArgs(), [1, 2, 3]);
    });

    test("adds AND condition when specified", () {
      final where = Where(
        idColumn,
        WhereOperator.equal,
        1,
        condition: WhereCondition.and,
      );
      expect(where.build(), "AND id = ?");
    });

    test("adds OR condition when specified", () {
      final where = Where(
        idColumn,
        WhereOperator.equal,
        1,
        condition: WhereCondition.or,
      );
      expect(where.build(), "OR id = ?");
    });

    test("converts non-basic right value to string", () {
      final date = DateTime(2023);
      final where = Where(nameColumn, WhereOperator.equal, date);
      expect(where.buildArgs(), [date.toString()]);
    });
  });
}
