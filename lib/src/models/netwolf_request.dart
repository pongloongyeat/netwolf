import 'dart:convert';

import 'package:netwolf/src/core/typedefs.dart';
import 'package:netwolf/src/enums.dart';

final class NetwolfRequest {
  NetwolfRequest.uri({
    this.id,
    required this.method,
    required this.uri,
    DateTime? startTime,
    this.headers,
    this.body,
  }) : startTime = startTime ?? DateTime.now();

  NetwolfRequest.urlString({
    this.id,
    required this.method,
    required String url,
    DateTime? startTime,
    this.headers,
    this.body,
  })  : uri = Uri.parse(url),
        startTime = startTime ?? DateTime.now();

  factory NetwolfRequest.fromDbObjectComponents({
    required Id? id,
    required String method,
    required String url,
    required String startTime,
    required String? headers,
    required String? body,
  }) {
    return NetwolfRequest.urlString(
      id: id,
      method: HttpRequestMethod.parse(method),
      url: url,
      startTime: DateTime.parse(startTime),
      headers:
          headers != null ? jsonDecode(headers) as Map<String, dynamic> : null,
      body: body,
    );
  }

  factory NetwolfRequest.fromDbObject(Map<String, Object?> map) {
    return NetwolfRequest.fromDbObjectComponents(
      id: map['id'] as Id?,
      method: map['method']! as String,
      url: map['url']! as String,
      startTime: map['start_time']! as String,
      headers: map['headers'] != null ? map['headers']! as String : null,
      body: map['body'] as String?,
    );
  }

  final Id? id;
  final HttpRequestMethod method;
  final Uri uri;
  final DateTime startTime;
  final Map<String, dynamic>? headers;
  final String? body;

  static String get tableName => 'REQUESTS';

  NetwolfRequest copyWith({
    Id? id,
    HttpRequestMethod? method,
    Uri? uri,
    DateTime? startTime,
    Map<String, dynamic>? headers,
    String? body,
  }) {
    return NetwolfRequest.uri(
      id: id ?? this.id,
      method: method ?? this.method,
      uri: uri ?? this.uri,
      startTime: startTime ?? this.startTime,
      headers: headers ?? this.headers,
      body: body ?? this.body,
    );
  }

  Map<String, Object?> toDbObject() => {
        'id': id,
        'method': method.name,
        'url': uri.toString(),
        'start_time': startTime.toIso8601String(),
        'headers': headers != null ? jsonEncode(headers) : null,
        'body': body,
      };
}
