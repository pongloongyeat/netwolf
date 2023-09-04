import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'database.g.dart';

@DriftDatabase(include: {'sql/tables.drift'})
class NetwolfDatabase extends _$NetwolfDatabase {
  NetwolfDatabase({
    required String dbPath,
  }) : super(_openConnection(dbPath: dbPath));

  NetwolfDatabase.inMemory({
    bool logStatements = false,
  }) : super(NativeDatabase.memory(logStatements: logStatements));

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
