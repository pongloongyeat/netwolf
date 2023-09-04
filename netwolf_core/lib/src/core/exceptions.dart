sealed class NetwolfException implements Exception {}

final class NetwolfRecordNotFoundException implements NetwolfException {}

final class NetwolfDecodingException implements NetwolfException {}

final class NetwolfLoggingDisabledException implements NetwolfException {}

final class NetwolfDbException implements NetwolfException {
  NetwolfDbException(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}
