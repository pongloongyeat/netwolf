import 'package:collection/collection.dart';

enum HttpRequestMethod {
  delete,
  get,
  head,
  patch,
  post,
  put;

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

  const HttpResponseStatus(this.responseCodeStart, this.responseCodeEnd);

  /// The starting range of a response status (inclusive).
  final int responseCodeStart;

  /// The ending range of a response status (inclusive).
  final int responseCodeEnd;

  static HttpResponseStatus? fromResponseCode(int? responseCode) {
    if (responseCode == null) return null;

    for (final status in values) {
      if (responseCode >= status.responseCodeStart &&
          responseCode <= status.responseCodeEnd) {
        return status;
      }
    }

    return null;
  }
}

enum NotificationName {
  show,
  hide,
  search,
  clearSearch,
  updateList,
  updateFilters,
  clearFilters,
}

enum NotificationKey { searchTerm, method, status }
