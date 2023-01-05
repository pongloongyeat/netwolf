import 'package:netwolf/src/enums.dart';

class NetwolfResponse {
  NetwolfResponse({
    required this.method,
    required this.status,
    required this.url,
  }) : timeStamp = DateTime.now();

  final HttpRequestMethod? method;
  final HttpResponseStatus? status;
  final String? url;
  final DateTime timeStamp;
}
