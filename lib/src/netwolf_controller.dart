import 'package:netwolf/netwolf.dart';
import 'package:netwolf/src/enums.dart';
import 'package:notification_dispatcher/notification_dispatcher.dart';

class NetwolfController {
  NetwolfController._();

  static final instance = NetwolfController._();

  final _responses = <NetwolfResponse>[];
  List<NetwolfResponse> get responses => _responses;

  bool _logging = true;

  /// The current logging status.
  bool get logging => _logging;

  /// Shows the netwolf overlay, if enabled.
  void show() {
    NotificationDispatcher.instance.post(name: NotificationName.show.name);
  }

  /// Enable logging.
  void enableLogging() {
    _logging = true;
  }

  /// Disables logging.
  void disableLogging() {
    _logging = false;
  }

  /// Adds a request to Netwolf.
  void addRequest(
    int requestHashCode, {
    required HttpRequestMethod? method,
    required String? url,
    required Map<String, dynamic>? requestHeaders,
    required dynamic requestBody,
  }) {
    if (!logging) return;

    _responses.insert(
      0,
      NetwolfResponse(
        method: method,
        responseCode: null,
        url: url,
        startTime: DateTime.now(),
        endTime: null,
        requestHeaders: requestHeaders,
        requestBody: requestBody,
        responseHeaders: null,
        responseBody: null,
        requestHashCode: requestHashCode,
      ),
    );
    _updateListUi();
  }

  /// Adds a response to Netwolf. If the request was not found, the
  /// response will still be added using the [method], [url], [requestHeaders],
  /// [requestBody] and [requestHashCode] as the [NetwolfResponse]'s
  /// constructor parameters.
  void addResponse(
    int requestHashCode, {
    required HttpRequestMethod? method,
    required int? responseCode,
    required String? url,
    required Map<String, dynamic>? requestHeaders,
    required dynamic requestBody,
    required Map<String, dynamic>? responseHeaders,
    required dynamic responseBody,
  }) {
    if (!logging) return;

    final index = _responses.indexWhere(
      (e) => e.requestHashCode == requestHashCode,
    );

    if (index != -1) {
      _responses[index] = _responses[index].copyWith(
        responseCode: responseCode,
        responseHeaders: responseHeaders,
        responseBody: responseBody,
        endTime: DateTime.now(),
        completed: true,
      );
    } else {
      // Not found
      _responses.insert(
        0,
        NetwolfResponse(
          method: method,
          responseCode: responseCode,
          url: url,
          startTime: DateTime.now(),
          endTime: null,
          requestHeaders: requestHeaders,
          requestBody: requestBody,
          responseHeaders: responseHeaders,
          responseBody: responseBody,
          requestHashCode: requestHashCode,
          completed: true,
        ),
      );
    }

    _updateListUi();
  }

  /// Clears all current responses.
  void clearResponses() {
    _responses.clear();
    _updateListUi();
  }

  void _updateListUi() {
    NotificationDispatcher.instance.post(
      name: NotificationName.updateList.name,
    );
  }
}
