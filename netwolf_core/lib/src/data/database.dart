import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(include: {'sql/tables.drift'})
class NetwolfDatabase extends _$NetwolfDatabase {
  NetwolfDatabase({
    QueryExecutor? queryExecutor,
  }) : super(queryExecutor ?? _openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection({
  bool restoreFromPreviousSession = false,
}) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.path, 'netwolf.sqlite'));

    if (!restoreFromPreviousSession && file.existsSync()) {
      await file.delete();
    }

    return NativeDatabase.createInBackground(file);
  });
}
