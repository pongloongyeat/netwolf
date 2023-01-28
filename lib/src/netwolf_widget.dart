import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:netwolf/netwolf.dart';
import 'package:netwolf/src/enums.dart';
import 'package:netwolf/src/widgets/widgets.dart';
import 'package:notification_dispatcher/notification_dispatcher.dart';
import 'package:shake/shake.dart';

class NetwolfWidget extends StatefulWidget {
  const NetwolfWidget({
    super.key,
    this.enabled = kDebugMode,
    required this.child,
  });

  /// Enables/disables Netwolf. If disabled, this will not show the overlay
  /// even if [NetwolfController.show] is called.
  final bool enabled;
  final Widget child;

  @override
  State<NetwolfWidget> createState() => _NetwolfWidgetState();
}

class _NetwolfWidgetState extends State<NetwolfWidget> {
  bool shown = false;

  @override
  void initState() {
    super.initState();

    ShakeDetector.autoStart(onPhoneShake: _show);
    NotificationDispatcher.instance.addObserver(
      this,
      name: NotificationName.show.name,
      callback: (_) => _show(),
    );
  }

  @override
  void dispose() {
    NotificationDispatcher.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _show() {
    if (widget.enabled && mounted && !shown) {
      shown = true;
      showCustomModalBottomSheet<void>(
        context: context,
        builder: (_) => const NetwolfSheet(),
      ).then((value) => shown = false);
    }
  }
}

Future<T?> showCustomModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  final mediaQueryData = MediaQueryData.fromWindow(ui.window);
  final deviceSize = mediaQueryData.size;
  final statusBarHeight = mediaQueryData.viewPadding.top;

  return showModalBottomSheet<T>(
    context: context,
    constraints: BoxConstraints.expand(
      width: deviceSize.width,
      height: deviceSize.height - statusBarHeight,
    ),
    isScrollControlled: true,
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
