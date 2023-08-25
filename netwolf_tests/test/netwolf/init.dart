import 'package:sqflite/sqflite_dev.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void initMockDb() {
  sqfliteFfiInit();
  setMockDatabaseFactory(databaseFactoryFfi);
}
