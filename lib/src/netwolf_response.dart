import 'package:netwolf/src/enums.dart';

class NetwolfResponseWithRelativeTimestamp {
  NetwolfResponseWithRelativeTimestamp({
    required this.response,
    required this.relativeTimestamp,
  });

  final NetwolfResponse response;
  final Duration relativeTimestamp;
}

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
}
