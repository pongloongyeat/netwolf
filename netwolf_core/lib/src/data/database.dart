import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'database.g.dart';

@DriftDatabase(include: {'sql/tables.drift'})
class NetwolfDatabase extends _$NetwolfDatabase {
  NetwolfDatabase({
    required String dbPath,
    QueryExecutor? queryExecutor,
  }) : super(queryExecutor ?? _openConnection(dbPath: dbPath));

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection({
  required String dbPath,
  bool restoreFromPreviousSession = false,
}) {
  return LazyDatabase(() async {
    final file = File(dbPath);

    if (!restoreFromPreviousSession && file.existsSync()) {
      await file.delete();
    }

    return NativeDatabase.createInBackground(file);
  });
}
