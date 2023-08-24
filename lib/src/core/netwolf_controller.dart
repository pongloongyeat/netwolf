import 'package:flutter/foundation.dart';
import 'package:netwolf/src/core/exceptions.dart';
import 'package:netwolf/src/core/typedefs.dart';
import 'package:netwolf/src/enums.dart';
import 'package:netwolf/src/models/netwolf_request.dart';
import 'package:netwolf/src/models/result.dart';
import 'package:netwolf/src/repositories/request_repository.dart';
import 'package:notification_dispatcher/notification_dispatcher.dart';
import 'package:sqflite/sqflite.dart';

@visibleForTesting
Future<Database> initDb({
  required bool restoreFromPreviousSession,
  required String? dbPathOverride,
}) async {
  final path = dbPathOverride ?? '${await getDatabasesPath()}/netwolf.db';

  if (!restoreFromPreviousSession &&
      dbPathOverride == null &&
      await databaseExists(path)) {
    await deleteDatabase(path);
  }

  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
CREATE TABLE IF NOT EXISTS ${NetwolfRequest.tableName} (
  id INTEGER NOT NULL,
  method TEXT NOT NULL,
  url TEXT NOT NULL,
  start_time TEXT NOT NULL,
  request_headers TEXT,
  request_body TEXT,

  status_code INTEGER,
  end_time TEXT,
  response_headers TEXT,
  response_body TEXT,

  PRIMARY KEY(id)
);
''');
    },
  );
}

abstract class _NetwolfController {
  late RequestRepository _repository;

  /// Initialises the controller and any needed tables.
  @mustCallSuper
  Future<void> init({
    bool restoreFromPreviousSession = false,
  }) async {
    final db = await initDb(
      restoreFromPreviousSession: restoreFromPreviousSession,
      dbPathOverride: null,
    );
    _repository = RequestRepository(db);
  }

  /// Shows the Netwolf overlay, if enabled.
  void show();

  /// Adds a request to Netwolf. Returns the ID of the added request.
  Future<Result<NetwolfRequest, Exception>> addRequest(
    NetwolfRequest request,
  );

  /// Adds a response to Netwolf. If the request was not found, the
  /// response will still be added but you will not be able to find
  /// the matching request that gave this response. Returns the ID of
  /// the added response.
  Future<Result<NetwolfRequest, Exception>> updateRequest(
    Id id,
    NetwolfRequest response,
  );

  /// Clears all current responses.
  void clearAll();
}

class NetwolfController extends _NetwolfController {
  @visibleForTesting
  NetwolfController();

  static final instance = NetwolfController();

  bool _logging = true;

  /// The current logging status.
  bool get logging => _logging;

  /// Enable logging.
  void enableLogging() {
    setLogging(true);
  }

  /// Disables logging.
  void disableLogging() {
    setLogging(false);
  }

  /// Set the current logging status.
  // ignore: avoid_positional_boolean_parameters, use_setters_to_change_properties
  void setLogging(bool value) {
    _logging = value;
  }

  @override
  void show() {
    NotificationDispatcher.instance.post(name: NotificationKey.show.name);
  }

  @override
  Future<Result<NetwolfRequest, Exception>> addRequest(
    NetwolfRequest request,
  ) async {
    if (!logging) return Result.error(NetwolfLoggingDisabledException());
    return _repository.addRequest(request);
  }

  @override
  Future<Result<NetwolfRequest, Exception>> updateRequest(
    Id id,
    NetwolfRequest response,
  ) async {
    if (!logging) return Result.error(NetwolfLoggingDisabledException());
    return _repository.updateRequest(id, response);
  }

  @override
  Future<void> clearAll() {
    return _repository.deleteAllRequests();
  }
}

@visibleForTesting
class MockNetwolfController extends NetwolfController {
  @visibleForTesting
  MockNetwolfController();

  static final instance = MockNetwolfController();

  @override
  // ignore: must_call_super
  Future<void> init({
    bool restoreFromPreviousSession = false,
    RequestRepository? repositoryOverride,
  }) async {
    final db = await initDb(
      restoreFromPreviousSession: restoreFromPreviousSession,
      dbPathOverride: inMemoryDatabasePath,
    );
    _repository = repositoryOverride ?? RequestRepository(db);
  }
}
