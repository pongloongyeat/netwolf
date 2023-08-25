import 'dart:convert';

import 'package:netwolf/src/core/typedefs.dart';
import 'package:netwolf/src/enums.dart';

class NetwolfRequest {
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

  factory NetwolfRequest.fromDbObject(Map<String, Object?> map) {
    return NetwolfRequest.fromDbObjectComponents(
      id: map['id'] as Id?,
      method: map['method']! as String,
      url: map['url']! as String,
      startTime: map['start_time']! as String,
      requestHeaders: map['request_headers'] != null
          ? map['request_headers']! as String
          : null,
      requestBody: map['request_body'] as String?,
      statusCode: map['status_code'] as int?,
      endTime: map['end_time'] as String?,
      responseHeaders: map['response_headers'] != null
          ? map['response_headers']! as String
          : null,
      responseBody: map['response_body'] as String?,
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

  static String get tableName => 'RESPONSES';

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

  Map<String, Object?> toDbObject() {
    return {
      'id': id,
      'method': method.name,
      'url': uri.toString(),
      'start_time': startTime.toIso8601String(),
      'request_headers':
          requestHeaders != null ? jsonEncode(requestHeaders) : null,
      'request_body': requestBody,
      'status_code': statusCode,
      'end_time': endTime?.toIso8601String(),
      'response_headers':
          responseHeaders != null ? jsonEncode(responseHeaders) : null,
      'response_body': responseBody,
    };
  }
}
