abstract interface class SqlColumn {
  final String column;

  final String prefix;

  SqlColumn(this.column, [this.prefix = ""])
    : assert(column.isNotEmpty, "Column name cannot be empty");

  /// Returns the column name with the prefix.
  String get selectColumn;
}
