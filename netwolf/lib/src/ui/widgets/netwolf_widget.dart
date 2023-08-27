import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:netwolf/src/core/enums.dart';
import 'package:netwolf/src/core/netwolf_controller.dart';
import 'package:netwolf/src/ui/pages/netwolf_landing_page.dart';
import 'package:netwolf/src/ui/widgets/serial_gesture_detector.dart';
import 'package:notification_dispatcher/notification_dispatcher.dart';

class NetwolfWidget extends StatefulWidget {
  const NetwolfWidget({
    super.key,
    this.enabled = kDebugMode,
    required this.navigatorKey,
    this.tapsToShow = 5,
    required this.child,
  });

  final bool enabled;

  final GlobalKey<NavigatorState> navigatorKey;

  /// The number of consecutive taps ([kDoubleTapTimeout] between each tap)
  /// to show the overlay. If null, this disables the gesture recogniser and
  /// you may manually call [NetwolfController.show] somewhere else.
  ///
  /// Defaults to 5 taps.
  ///
  final int tapsToShow;
  final Widget child;

  @override
  State<NetwolfWidget> createState() => _NetwolfWidgetState();
}

class _NetwolfWidgetState extends State<NetwolfWidget> {
  bool _shown = false;

  @override
  void initState() {
    super.initState();

    NotificationDispatcher.instance.addObserver(
      this,
      name: NotificationName.show.name,
      callback: _onShow,
    );
  }

  @override
  void dispose() {
    NotificationDispatcher.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SerialGestureDetector(
      count: 5,
      onSerialTap: _show,
      child: widget.child,
    );
  }

  void _onShow(NotificationMessage message) {
    _show();
  }

  void _show() {
    final enabled = widget.enabled;
    if (!enabled || !mounted || _shown) return;

    final context = widget.navigatorKey.currentContext!;
    _shown = true;
    showCustomModalBottomSheet<void>(
      context: context,
      builder: (_) => const NetwolfLandingPage(),
    ).then((_) => _shown = false);
  }
}

Future<T?> showCustomModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  final device = MediaQuery.of(context);
  final deviceSize = device.size;
  final statusBarHeight = device.viewPadding.top;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    constraints: BoxConstraints.expand(
      width: deviceSize.width,
      height: deviceSize.height - statusBarHeight,
    ),
    backgroundColor: Colors.transparent,
    builder: (dialogContext) => ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: builder(dialogContext),
    ),
  );
}
