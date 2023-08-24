import 'dart:convert';

import 'package:netwolf/src/core/typedefs.dart';
import 'package:netwolf/src/models/netwolf_request.dart';

final class NetwolfResponse {
  NetwolfResponse({
    this.id,
    required this.request,
    required this.statusCode,
    required this.endTime,
    this.headers,
    this.body,
  }) : responseTime = endTime.difference(request.startTime);

  factory NetwolfResponse.fromDbObjectComponents({
    required Id? id,
    required int statusCode,
    required String endTime,
    required String? headers,
    required String? body,
    required Id? requestId,
    required String requestMethod,
    required String requestUrl,
    required String startTime,
    required String? requestHeaders,
    required String? requestBody,
  }) {
    return NetwolfResponse(
      id: id,
      request: NetwolfRequest.fromDbObjectComponents(
        id: requestId,
        method: requestMethod,
        url: requestUrl,
        startTime: startTime,
        headers: requestHeaders,
        body: requestBody,
      ),
      statusCode: statusCode,
      endTime: DateTime.parse(endTime),
      headers:
          headers != null ? jsonDecode(headers) as Map<String, dynamic> : null,
      body: body,
    );
  }

  factory NetwolfResponse.fromDbObject(Map<String, Object?> map) {
    return NetwolfResponse.fromDbObjectComponents(
      id: map['id'] as Id?,
      statusCode: map['status_code']! as int,
      endTime: map['end_time']! as String,
      headers: map['headers'] != null ? map['headers']! as String : null,
      body: map['body'] as String?,
      requestId: map['request_id'] as Id?,
      requestMethod: map['request_method']! as String,
      requestUrl: map['request_url']! as String,
      startTime: map['start_time']! as String,
      requestHeaders: map['request_headers'] != null
          ? map['request_headers']! as String
          : null,
      requestBody: map['request_body'] as String?,
    );
  }

  final Id? id;
  final NetwolfRequest request;
  final int statusCode;
  final DateTime endTime;
  final Map<String, dynamic>? headers;
  final String? body;

  final Duration responseTime;

  static String get tableName => 'RESPONSES';

  NetwolfResponse copyWith({
    Id? id,
    NetwolfRequest? request,
    int? statusCode,
    DateTime? endTime,
    Map<String, dynamic>? headers,
    String? body,
  }) {
    return NetwolfResponse(
      id: id ?? this.id,
      request: request ?? this.request,
      statusCode: statusCode ?? this.statusCode,
      endTime: endTime ?? this.endTime,
      headers: headers ?? this.headers,
      body: body ?? this.body,
    );
  }

  Map<String, Object?> toDbObject() => {
        'id': id,
        'request_id': request.id,
        'status_code': statusCode,
        'end_time': endTime.toIso8601String(),
        'headers': headers != null ? jsonEncode(headers) : null,
        'body': body,
      };
}
