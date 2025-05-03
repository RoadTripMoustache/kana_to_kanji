abstract interface class SqlColumn {
  final String column;

  SqlColumn(this.column)
    : assert(column.isNotEmpty, "Column name cannot be empty");
}
