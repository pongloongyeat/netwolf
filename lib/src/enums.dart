import 'package:collection/collection.dart';

enum HttpRequestMethod {
  delete,
  get,
  head,
  patch,
  post,
  put;

  static HttpRequestMethod parse(String method) {
    return values
        .firstWhere((e) => e.name.toLowerCase() == method.toLowerCase());
  }

  static HttpRequestMethod? tryParse(String? method) {
    return values
        .firstWhereOrNull((e) => e.name.toLowerCase() == method?.toLowerCase());
  }
}

enum HttpResponseStatus {
  info(100, 199),
  success(200, 299),
  redirect(300, 399),
  clientError(400, 499),
  serverError(500, 599);

  const HttpResponseStatus(this.startRange, this.endRange);

  /// The starting range of a response status (inclusive).
  final int startRange;

  /// The ending range of a response status (inclusive).
  final int endRange;

  static HttpResponseStatus? fromResponseCode(int? responseCode) {
    if (responseCode == null) return null;

    for (final status in values) {
      if (responseCode >= status.startRange &&
          responseCode <= status.endRange) {
        return status;
      }
    }

    return null;
  }
}

enum NotificationKey { show }
