import 'package:flutter/foundation.dart';
import 'package:netwolf/src/core/enums.dart';
import 'package:netwolf/src/core/exceptions.dart';
import 'package:netwolf/src/core/typedefs.dart';
import 'package:netwolf/src/models/netwolf_request.dart';
import 'package:netwolf/src/models/result.dart';
import 'package:netwolf/src/repositories/request_repository.dart';
import 'package:notification_dispatcher/notification_dispatcher.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@visibleForTesting
Future<Database> initDb({
  required bool restoreFromPreviousSession,
  required String? dbPathOverride,
}) async {
  final path = dbPathOverride ?? join(await getDatabasesPath(), 'netwolf.db');

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

abstract class BaseNetwolfController {
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

  /// Shows the Netwolf overlay, if enabled.
  void show();

  /// Gets all stored requests.
  Future<Result<List<NetwolfRequest>, NetwolfException>> getRequests() {
    return _repository.getRequests();
  }

  /// Gets a specific request.
  Future<Result<NetwolfRequest, NetwolfException>> getRequestById(Id id) {
    return _repository.getRequestById(id);
  }

  /// Adds a request to Netwolf. Returns the ID of the added request.
  Future<Result<NetwolfRequest, NetwolfException>> addRequest(
    NetwolfRequest request,
  ) async {
    if (!logging) return Result.error(NetwolfLoggingDisabledException());
    return _repository.addRequest(request);
  }

  /// Completes an existing request. If the request was not found, a
  /// [NetwolfRecordNotFoundException] will be returned. Otherwise,
  /// this simply returns the updated request.
  Future<Result<NetwolfRequest, NetwolfException>> completeRequest(
    NetwolfRequest request, {
    int? statusCode,
    DateTime? endTime,
    Map<String, dynamic>? responseHeaders,
    String? responseBody,
  }) async {
    if (!logging) return Result.error(NetwolfLoggingDisabledException());
    return _repository.updateRequest(
      request,
      request.completeRequest(
        statusCode: statusCode,
        endTime: endTime,
        responseHeaders: responseHeaders,
        responseBody: responseBody,
      ),
    );
  }

  /// Clears all current responses.
  Future<void> clearAll() {
    return _repository.deleteAllRequests();
  }
}

@visibleForTesting
final class MockNetwolfController extends BaseNetwolfController {
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

  @override
  void show() {}
}

final class NetwolfController extends BaseNetwolfController {
  NetwolfController._();

  static final instance = NetwolfController._();

  @override
  void show() {
    NotificationDispatcher.instance.post(name: NotificationName.show.name);
  }
}
