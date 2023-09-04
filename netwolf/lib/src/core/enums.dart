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

  static HttpResponseStatus? fromStatusCode(int? statusCode) {
    if (statusCode == null) return null;

    for (final status in values) {
      if (statusCode >= status.startRange && statusCode <= status.endRange) {
        return status;
      }
    }

    return null;
  }
}

enum NotificationName {
  show,
  search,
  refetchRequests,
  updateFilters,
  clearFilters
}

enum NotificationKey { searchTerm, method, status }
