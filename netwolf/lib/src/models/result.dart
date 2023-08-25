class Result<D, E> {
  const Result(D this.data) : error = null;
  const Result.error(E this.error, {this.data});

  final D? data;
  final E? error;

  bool get hasError => error != null;
}
