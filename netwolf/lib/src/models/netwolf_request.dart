import 'dart:convert';

import 'package:netwolf/src/core/enums.dart';
import 'package:netwolf/src/core/typedefs.dart';

enum NetwolfRequestDbObjectKeys {
  id,
  method,
  url,
  startTime,
  requestHeaders,
  requestBody,
  statusCode,
  endTime,
  responseHeaders,
  responseBody;

  String get name {
    return switch (this) {
      id => 'id',
      method => 'method',
      url => 'url',
      startTime => 'start_time',
      requestHeaders => 'request_headers',
      requestBody => 'request_body',
      statusCode => 'status_code',
      endTime => 'end_time',
      responseHeaders => 'response_headers',
      responseBody => 'response_body',
    };
  }

  static List<NetwolfRequestDbObjectKeys> get requestKeys =>
      [method, url, startTime, requestHeaders, requestBody];

  static List<NetwolfRequestDbObjectKeys> get responseKeys =>
      [statusCode, endTime, responseHeaders, responseBody];
}

final class NetwolfRequest {
  const NetwolfRequest._({
    required this.id,
    required this.method,
    required this.uri,
    required this.startTime,
    required this.requestHeaders,
    required this.requestBody,
    required this.statusCode,
    required this.endTime,
    required this.responseHeaders,
    required this.responseBody,
    required this.responseTime,
  });

  factory NetwolfRequest.uri({
    Id? id,
    required HttpRequestMethod method,
    required Uri uri,
    DateTime? startTime,
    Map<String, dynamic>? requestHeaders,
    String? requestBody,
    int? statusCode,
    DateTime? endTime,
    Map<String, dynamic>? responseHeaders,
    String? responseBody,
  }) {
    final effectiveStartTime = startTime ?? DateTime.now();
    return NetwolfRequest._(
      id: id,
      method: method,
      uri: uri,
      startTime: effectiveStartTime,
      requestHeaders: requestHeaders,
      requestBody: requestBody,
      statusCode: statusCode,
      endTime: endTime,
      responseHeaders: responseHeaders,
      responseBody: responseBody,
      responseTime: endTime?.difference(effectiveStartTime),
    );
  }

  factory NetwolfRequest.urlString({
    Id? id,
    required HttpRequestMethod method,
    required String url,
    DateTime? startTime,
    Map<String, dynamic>? requestHeaders,
    String? requestBody,
    int? statusCode,
    DateTime? endTime,
    Map<String, dynamic>? responseHeaders,
    String? responseBody,
  }) {
    return NetwolfRequest.uri(
      id: id,
      method: method,
      uri: Uri.parse(url),
      startTime: startTime,
      requestHeaders: requestHeaders,
      requestBody: requestBody,
      statusCode: statusCode,
      endTime: endTime,
      responseHeaders: responseHeaders,
      responseBody: responseBody,
    );
  }

  factory NetwolfRequest.fromDbObjectComponents({
    required Id? id,
    required String method,
    required String url,
    required String startTime,
    required String? requestHeaders,
    required String? requestBody,
    required int? statusCode,
    required String? endTime,
    required String? responseHeaders,
    required String? responseBody,
  }) {
    return NetwolfRequest.urlString(
      id: id,
      method: HttpRequestMethod.parse(method),
      url: url,
      startTime: DateTime.parse(startTime),
      requestHeaders: requestHeaders != null
          ? jsonDecode(requestHeaders) as Map<String, dynamic>
          : null,
      requestBody: requestBody,
      statusCode: statusCode,
      endTime: endTime != null ? DateTime.parse(endTime) : null,
      responseHeaders: responseHeaders != null
          ? jsonDecode(responseHeaders) as Map<String, dynamic>
          : null,
      responseBody: responseBody,
    );
  }

  factory NetwolfRequest.fromDbObject(DbObject map) {
    final id = map[NetwolfRequestDbObjectKeys.id.name];
    final method = map[NetwolfRequestDbObjectKeys.method.name];
    final url = map[NetwolfRequestDbObjectKeys.url.name];
    final startTime = map[NetwolfRequestDbObjectKeys.startTime.name];
    final requestHeaders = map[NetwolfRequestDbObjectKeys.requestHeaders.name];
    final requestBody = map[NetwolfRequestDbObjectKeys.requestBody.name];
    final statusCode = map[NetwolfRequestDbObjectKeys.statusCode.name];
    final endTime = map[NetwolfRequestDbObjectKeys.endTime.name];
    final responseHeaders =
        map[NetwolfRequestDbObjectKeys.responseHeaders.name];
    final responseBody = map[NetwolfRequestDbObjectKeys.responseBody.name];

    return NetwolfRequest.fromDbObjectComponents(
      id: id as Id?,
      method: method! as String,
      url: url! as String,
      startTime: startTime! as String,
      requestHeaders: requestHeaders != null ? requestHeaders as String : null,
      requestBody: requestBody as String?,
      statusCode: statusCode as int?,
      endTime: endTime as String?,
      responseHeaders:
          responseHeaders != null ? responseHeaders as String : null,
      responseBody: responseBody as String?,
    );
  }

  final Id? id;
  final HttpRequestMethod method;
  final Uri uri;
  final DateTime startTime;
  final Map<String, dynamic>? requestHeaders;
  final String? requestBody;

  final int? statusCode;
  final DateTime? endTime;
  final Map<String, dynamic>? responseHeaders;
  final String? responseBody;

  final Duration? responseTime;

  static String get tableName => 'REQUESTS';

  bool get completed => endTime != null;

  NetwolfRequest copyWith({
    Id? id,
    HttpRequestMethod? method,
    Uri? uri,
    DateTime? startTime,
    Map<String, dynamic>? requestHeaders,
    String? requestBody,
    int? statusCode,
    DateTime? endTime,
    Map<String, dynamic>? responseHeaders,
    String? responseBody,
  }) {
    return NetwolfRequest.uri(
      id: id ?? this.id,
      method: method ?? this.method,
      uri: uri ?? this.uri,
      startTime: startTime ?? this.startTime,
      requestHeaders: requestHeaders ?? this.requestHeaders,
      requestBody: requestBody ?? this.requestBody,
      statusCode: statusCode ?? this.statusCode,
      endTime: endTime ?? this.endTime,
      responseHeaders: responseHeaders ?? this.responseHeaders,
      responseBody: responseBody ?? this.responseBody,
    );
  }

  DbObject toDbObject({bool withId = true}) {
    return {
      if (withId) NetwolfRequestDbObjectKeys.id.name: id,
      NetwolfRequestDbObjectKeys.method.name: method.name,
      NetwolfRequestDbObjectKeys.url.name: uri.toString(),
      NetwolfRequestDbObjectKeys.startTime.name: startTime.toIso8601String(),
      NetwolfRequestDbObjectKeys.requestHeaders.name:
          requestHeaders != null ? jsonEncode(requestHeaders) : null,
      NetwolfRequestDbObjectKeys.requestBody.name: requestBody,
      NetwolfRequestDbObjectKeys.statusCode.name: statusCode,
      NetwolfRequestDbObjectKeys.endTime.name: endTime?.toIso8601String(),
      NetwolfRequestDbObjectKeys.responseHeaders.name:
          responseHeaders != null ? jsonEncode(responseHeaders) : null,
      NetwolfRequestDbObjectKeys.responseBody.name: responseBody,
    };
  }
}
