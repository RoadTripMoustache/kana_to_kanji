import "package:sqflite/sqflite.dart";

extension TransactionExtension on Transaction {
  Future<List<T>> queryTrans<T>(
      String table, {
        required T Function(Map<String, Object?>) transformer,
        bool? distinct,
        List<String>? columns,
        String? where,
        List<Object?>? whereArgs,
        String? groupBy,
        String? having,
        String? orderBy,
        int? limit,
        int? offset,
      }) async {
    final List<Map<String, Object?>> result = await query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

    return result.map<T>(transformer).toList();
  }

  Future<List<T>> rawQueryTrans<T>(
      String query, {
        required T Function(Map<String, Object?>) transformer,
        List<dynamic> arguments = const [],
      }) async {
    final List<Map<String, dynamic>> result = await rawQuery(
      query,
      arguments,
    );

    return result.map<T>(transformer).toList();
  }
}