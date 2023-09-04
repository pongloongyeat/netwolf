import 'dart:convert';

import 'package:netwolf_core/src/core/enums.dart';
import 'package:netwolf_core/src/core/typedefs.dart';
import 'package:netwolf_core/src/data/database.dart';

class NetwolfRequestData {
  NetwolfRequestData({
    this.id,
    required this.method,
    required this.uri,
    required this.startTime,
    this.requestHeaders,
    this.requestBody,
    this.statusCode,
    this.endTime,
    this.responseHeaders,
    this.responseBody,
  }) : responseTime = endTime?.difference(startTime);

  factory NetwolfRequestData.fromGetAllRequestsResult(
    GetAllRequestsResult result,
  ) {
    return NetwolfRequestData._(
      id: result.id,
      method: result.method,
      url: result.url,
      startTime: result.startTime,
      requestHeaders: null,
      requestBody: null,
      statusCode: null,
      endTime: null,
      responseHeaders: null,
      responseBody: null,
    );
  }

  factory NetwolfRequestData.fromNetwolfRequest(NetwolfRequest request) {
    return NetwolfRequestData._(
      id: request.id,
      method: request.method,
      url: request.url,
      startTime: request.startTime,
      requestHeaders: request.requestHeaders,
      requestBody: request.requestBody,
      statusCode: request.statusCode,
      endTime: request.endTime,
      responseHeaders: request.responseHeaders,
      responseBody: request.responseBody,
    );
  }

  factory NetwolfRequestData._({
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
    return NetwolfRequestData(
      id: id,
      method: HttpRequestMethod.parse(method),
      uri: Uri.parse(url),
      startTime: DateTime.parse(startTime),
      requestHeaders: _parseStringToJson(requestHeaders),
      requestBody: requestBody,
      statusCode: statusCode,
      endTime: endTime != null ? DateTime.parse(endTime) : null,
      responseHeaders: _parseStringToJson(responseHeaders),
      responseBody: responseBody,
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

  bool get completed => endTime != null;

  static Map<String, dynamic>? _parseStringToJson(String? data) {
    if (data == null) return null;

    final map = jsonDecode(data);
    if (map is Map<String, dynamic>) return map;
    return null;
  }
}
