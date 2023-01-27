import 'package:netwolf/netwolf.dart';
import 'package:netwolf/src/enums.dart';
import 'package:notification_dispatcher/notification_dispatcher.dart';

class NetwolfController {
  NetwolfController._(this._intitialTimestamp);

  static final instance = NetwolfController._(DateTime.now());

  final DateTime _intitialTimestamp;

  final _responses = <NetwolfResponseWithRelativeTimestamp>[];
  List<NetwolfResponseWithRelativeTimestamp> get responses => _responses;

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

  void addResponse(NetwolfResponse response) {
    if (!logging) return;

    _responses.insert(
      0,
      NetwolfResponseWithRelativeTimestamp(
        response: response,
        relativeTimestamp: response.timeStamp.difference(_intitialTimestamp),
      ),
    );
    _updateListUi();
  }

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
