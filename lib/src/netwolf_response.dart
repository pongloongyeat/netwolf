import 'package:netwolf/netwolf.dart';

/// [NetwolfResponse] with the duration relative to an initial time.
/// This is usually relative to [NetwolfController]'s initial [DateTime]
/// object instantiated on the first call to [NetwolfController.instance].
class NetwolfResponseWithRelativeTimestamp {
  NetwolfResponseWithRelativeTimestamp({
    required this.response,
    required this.relativeTimestamp,
  });

  /// The response.
  final NetwolfResponse response;

  /// The duration relative to some initial timestamp.
  final Duration relativeTimestamp;
}

/// The response class used by Netwolf.
class NetwolfResponse {
  NetwolfResponse({
    required this.method,
    required this.responseCode,
    required this.url,
    required this.requestHeaders,
    required this.requestBody,
    required this.responseHeaders,
    required this.responseBody,
  })  : status = HttpResponseStatus.fromResponseCode(responseCode),
        uri = url != null ? Uri.tryParse(url) : null,
        timeStamp = DateTime.now();

  final HttpRequestMethod? method;
  final int? responseCode;
  final HttpResponseStatus? status;
  final String? url;
  final Uri? uri;
  final DateTime timeStamp;
  final Map<String, dynamic>? requestHeaders;
  final dynamic requestBody;
  final Map<String, dynamic>? responseHeaders;
  final dynamic responseBody;

  NetwolfResponse copyWith({
    HttpRequestMethod? method,
    int? responseCode,
    HttpResponseStatus? status,
    String? url,
    Uri? uri,
    DateTime? timeStamp,
    Map<String, dynamic>? requestHeaders,
    dynamic requestBody,
    Map<String, dynamic>? responseHeaders,
    dynamic responseBody,
  }) {
    return NetwolfResponse(
      method: method ?? this.method,
      responseCode: responseCode ?? this.responseCode,
      url: url ?? this.url,
      requestHeaders: requestHeaders ?? this.requestHeaders,
      requestBody: requestBody ?? this.requestBody,
      responseHeaders: responseHeaders ?? this.responseHeaders,
      responseBody: responseBody ?? this.responseBody,
    );
  }
}
