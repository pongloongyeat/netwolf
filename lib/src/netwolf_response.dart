import 'package:netwolf/netwolf.dart';

/// The response class used by Netwolf.
class NetwolfResponse {
  NetwolfResponse({
    required this.method,
    required this.responseCode,
    required this.url,
    required this.startTime,
    required this.endTime,
    required this.requestHeaders,
    required this.requestBody,
    required this.responseHeaders,
    required this.responseBody,
    required this.requestHashCode,
    this.completed = false,
  })  : status = HttpResponseStatus.fromResponseCode(responseCode),
        uri = url != null ? Uri.tryParse(url) : null,
        responseTime = endTime?.difference(startTime);

  final HttpRequestMethod? method;
  final int? responseCode;
  final HttpResponseStatus? status;
  final String? url;
  final Uri? uri;
  final DateTime startTime;
  final DateTime? endTime;
  final Map<String, dynamic>? requestHeaders;
  final dynamic requestBody;
  final Map<String, dynamic>? responseHeaders;
  final dynamic responseBody;
  final int requestHashCode;
  final Duration? responseTime;
  final bool completed;

  NetwolfResponse copyWith({
    int? responseCode,
    HttpResponseStatus? status,
    DateTime? endTime,
    Map<String, dynamic>? responseHeaders,
    dynamic responseBody,
    bool? completed,
  }) {
    return NetwolfResponse(
      method: method,
      responseCode: responseCode ?? this.responseCode,
      url: url,
      startTime: startTime,
      endTime: endTime ?? this.endTime,
      requestHeaders: requestHeaders,
      requestBody: requestBody,
      responseHeaders: responseHeaders ?? this.responseHeaders,
      responseBody: responseBody ?? this.responseBody,
      requestHashCode: requestHashCode,
      completed: completed ?? this.completed,
    );
  }
}
