import 'package:flutter/foundation.dart';
import 'package:netwolf/src/core/exceptions.dart';
import 'package:netwolf/src/models/netwolf_request.dart';
import 'package:netwolf/src/models/netwolf_response.dart';
import 'package:netwolf/src/models/result.dart';
import 'package:netwolf/src/repositories/request_repository.dart';
import 'package:netwolf/src/repositories/response_repository.dart';
import 'package:sqflite/sqflite.dart';

abstract class _NetwolfController {
  late RequestRepository _requestRepository;
  late ResponseRepository _responseRepository;

  /// Initialises the controller and any needed tables.
  @mustCallSuper
  Future<void> init({
    bool restoreFromPreviousSession = false,
  }) async {
    final path = await getDatabasesPath();
    final dbPath = '$path/netwolf.db';

    if (!restoreFromPreviousSession && await databaseExists(dbPath)) {
      await deleteDatabase(dbPath);
    }

    final db = await openDatabase(
      dbPath,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE IF NOT EXISTS ${NetwolfRequest.tableName} (
  id INTEGER NOT NULL,
  method TEXT NOT NULL,
  url TEXT NOT NULL,
  start_time TEXT NOT NULL,
  headers TEXT,
  body TEXT,

  PRIMARY KEY(id)
);
''');
        await db.execute('''
CREATE TABLE IF NOT EXISTS ${NetwolfResponse.tableName} (
  id INTEGER NOT NULL,
  request_id INTEGER NOT NULL,
  status_code INTEGER NOT NULL,
  end_time TEXT NOT NULL,
  headers TEXT,
  body TEXT,

  PRIMARY KEY(id),
  FOREIGN KEY(request_id) REFERENCES ${NetwolfRequest.tableName}(id) ON DELETE CASECADE
)
''');
      },
    );

    _requestRepository = RequestRepository(db);
    _responseRepository = ResponseRepository(db);
  }

  /// Shows the Netwolf overlay, if enabled.
  void show();

  /// Hides the Netwolf overlay.
  void hide();

  /// Adds a request to Netwolf. Returns the ID of the added request.
  Future<Result<NetwolfRequest, Exception>> addRequest(
    NetwolfRequest request,
  );

  /// Adds a response to Netwolf. If the request was not found, the
  /// response will still be added but you will not be able to find
  /// the matching request that gave this response. Returns the ID of
  /// the added response.
  Future<Result<NetwolfResponse, Exception>> addResponse(
    NetwolfResponse response,
  );

  /// Clears all current responses.
  void clearAll();
}

class NetwolfController extends _NetwolfController {
  NetwolfController._();

  static final instance = NetwolfController._();

  bool _logging = true;

  /// The current logging status.
  bool get logging => _logging;

  /// Enable logging.
  void enableLogging() => _logging = true;

  /// Disables logging.
  void disableLogging() => _logging = false;

  @override
  void show() {
    // TODO: implement show
  }

  @override
  void hide() {
    // TODO: implement hide
  }

  @override
  Future<Result<NetwolfRequest, Exception>> addRequest(
    NetwolfRequest request,
  ) async {
    if (!logging) return Result.error(NetwolfLoggingDisabledException());
    return _requestRepository.addRequest(request);
  }

  @override
  Future<Result<NetwolfResponse, Exception>> addResponse(
    NetwolfResponse response,
  ) async {
    if (!logging) return Result.error(NetwolfLoggingDisabledException());
    return _responseRepository.addResponse(response);
  }

  @override
  Future<void> clearAll() {
    return _requestRepository.deleteAllRequests();
  }
}
