enum HttpRequestMethod {
  delete,
  get,
  head,
  patch,
  post,
  put,
  unknown;

  static HttpRequestMethod parse(String method) {
    return values.firstWhere(
      (e) => e.name.toLowerCase() == method.toLowerCase(),
      orElse: () => HttpRequestMethod.unknown,
    );
  }
}
