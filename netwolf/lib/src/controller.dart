import 'package:netwolf/src/enums.dart';
import 'package:netwolf_core/netwolf_core.dart';
import 'package:notification_dispatcher/notification_dispatcher.dart';

final class NetwolfController extends BaseNetwolfController {
  NetwolfController._();

  static final instance = NetwolfController._();

  @override
  void show() {
    NotificationDispatcher.instance.post(name: NotificationName.show.name);
  }
}
