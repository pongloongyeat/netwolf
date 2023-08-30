import 'dart:convert';

import 'package:netwolf_core/src/core/enums.dart';
import 'package:netwolf_core/src/core/typedefs.dart';

class AddRequestDto {
  AddRequestDto({
    this.id,
    required HttpRequestMethod method,
    required Uri uri,
    required DateTime startTime,
    required Map<String, dynamic>? requestHeaders,
    required this.requestBody,
  })  : method = method.name,
        url = '$uri',
        startTime = startTime.toIso8601String(),
        requestHeaders =
            requestHeaders != null ? jsonEncode(requestHeaders) : null;

  final Id? id;
  final String method;
  final String url;
  final String startTime;
  final String? requestHeaders;
  final String? requestBody;
}

class CompleteRequestDto {
  CompleteRequestDto({
    required this.id,
    required this.statusCode,
    required DateTime endTime,
    required Map<String, dynamic>? responseHeaders,
    required this.responseBody,
  })  : endTime = endTime.toIso8601String(),
        responseHeaders =
            responseHeaders != null ? jsonEncode(responseHeaders) : null;

  final Id id;
  final int? statusCode;
  final String endTime;
  final String? responseHeaders;
  final String? responseBody;
}
