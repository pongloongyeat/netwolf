import 'package:netwolf_core/src/core/enums.dart';
import 'package:netwolf_core/src/core/exceptions.dart';
import 'package:netwolf_core/src/core/typedefs.dart';
import 'package:netwolf_core/src/data/database.dart';
import 'package:netwolf_core/src/data/models/data.dart';
import 'package:netwolf_core/src/data/models/dtos.dart';
import 'package:netwolf_core/src/data/models/result.dart';
import 'package:netwolf_core/src/data/repository.dart';

abstract class BaseNetwolfController {
  BaseNetwolfController.inMemory({
    bool logStatements = false,
  }) : _repository = NetwolfRepository(
          NetwolfDatabase.inMemory(logStatements: logStatements),
        );

  BaseNetwolfController.fromPath(String dbPath)
      : _repository = NetwolfRepository(NetwolfDatabase(dbPath: dbPath));

  final NetwolfRepository _repository;

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

  /// Gets all stored requests. The headers and bodies are ommitted by default.
  /// To get the headers or bodies of a request, use [getRequestById].
  Future<Result<List<NetwolfRequestData>, NetwolfException>> getAllRequests() {
    return _repository.getAllRequests();
  }

  /// Gets a specific request.
  Future<Result<NetwolfRequestData, NetwolfException>> getRequestById(Id id) {
    return _repository.getRequestById(id);
  }

  /// Adds a request to Netwolf. Returns the ID of the added request.
  Future<Result<Id, NetwolfException>> addRequest({
    required HttpRequestMethod method,
    required Uri uri,
    DateTime? startTime,
    Map<String, dynamic>? requestHeaders,
    String? requestBody,
  }) async {
    if (!logging) return Result.error(NetwolfLoggingDisabledException());
    return _repository.addRequest(
      AddRequestDto(
        method: method,
        uri: uri,
        startTime: startTime ?? DateTime.now(),
        requestHeaders: requestHeaders,
        requestBody: requestBody,
      ),
    );
  }

  /// Completes an existing request and returns the updated request.
  /// Returns a [NetwolfLoggingDisabledException] if [logging] is enabled.
  Future<Result<void, NetwolfException>> completeRequest(
    Id id, {
    int? statusCode,
    DateTime? endTime,
    Map<String, dynamic>? responseHeaders,
    String? responseBody,
  }) async {
    if (!logging) return Result.error(NetwolfLoggingDisabledException());
    return _repository.completeRequest(
      CompleteRequestDto(
        id: id,
        statusCode: statusCode,
        endTime: endTime ?? DateTime.now(),
        responseHeaders: responseHeaders,
        responseBody: responseBody,
      ),
    );
  }

  /// Clears all current responses.
  Future<Result<void, NetwolfException>> clearAll() {
    return _repository.deleteAllRequests();
  }

  Future<Result<void, NetwolfException>> clearRequestById(Id id) {
    return _repository.deleteRequestById(id);
  }
}
