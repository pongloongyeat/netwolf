import 'package:flutter/material.dart';
import 'package:netwolf/src/core/enums.dart';
import 'package:netwolf_core/netwolf_core.dart';
import 'package:notification_dispatcher/notification_dispatcher.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class NetwolfController extends BaseNetwolfController {
  // ignore: use_super_parameters
  NetwolfController._fromPath(String dbPath) : super.fromPath(dbPath);

  // ignore: use_super_parameters
  NetwolfController._inMemory({
    bool logStatements = false,
  }) : super.inMemory(logStatements: logStatements);

  static late final NetwolfController instance;

  static Future<void> init({
    @visibleForTesting bool inMemory = false,
  }) async {
    if (inMemory) {
      instance = NetwolfController._inMemory();
      return;
    }

    final dbPath = await getApplicationDocumentsDirectory();
    instance = NetwolfController._fromPath(join(dbPath.path, 'netwolf.db'));
  }

  void show() {
    NotificationDispatcher.instance.post(name: NotificationName.show.name);
  }

  @override
  Future<Result<Id, NetwolfException>> addRequest({
    required HttpRequestMethod method,
    required Uri uri,
    DateTime? startTime,
    Map<String, dynamic>? requestHeaders,
    String? requestBody,
  }) async {
    final result = await super.addRequest(
      method: method,
      uri: uri,
      startTime: startTime,
      requestHeaders: requestHeaders,
      requestBody: requestBody,
    );
    if (result.hasError) return result;
    return result;
  }

  @override
  Future<Result<void, NetwolfException>> completeRequest(
    Id id, {
    int? statusCode,
    DateTime? endTime,
    Map<String, dynamic>? responseHeaders,
    String? responseBody,
  }) async {
    final result = await super.completeRequest(
      id,
      statusCode: statusCode,
      endTime: endTime,
      responseHeaders: responseHeaders,
      responseBody: responseBody,
    );
    if (result.hasError) return result;

    NotificationDispatcher.instance.post(
      name: NotificationName.refetchRequests.name,
    );
    return result;
  }
}
