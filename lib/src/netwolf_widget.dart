import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:netwolf/netwolf.dart';
import 'package:netwolf/src/enums.dart';
import 'package:netwolf/src/widgets/widgets.dart';
import 'package:notification_dispatcher/notification_dispatcher.dart';

class NetwolfWidget extends StatefulWidget {
  const NetwolfWidget({
    super.key,
    this.enabled = kDebugMode,
    this.child,
  });

  factory NetwolfWidget.builder(BuildContext _, Widget? child) {
    return NetwolfWidget(child: child);
  }

  /// Enables/disables Netwolf. If disabled, this will not show the overlay
  /// even if [NetwolfController.show] is called.
  final bool enabled;
  final Widget? child;

  @override
  State<NetwolfWidget> createState() => _NetwolfWidgetState();
}

class _NetwolfWidgetState extends State<NetwolfWidget> {
  bool _shown = false;

  @override
  void initState() {
    super.initState();
    NotificationDispatcher.instance
      ..addObserver(
        this,
        name: NotificationName.show.name,
        callback: (_) => _show(),
      )
      ..addObserver(
        this,
        name: NotificationName.hide.name,
        callback: (_) => _hide(),
      );
  }

  @override
  void dispose() {
    NotificationDispatcher.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: Stack(
        children: [
          widget.child ?? Container(),
          Align(
            alignment: Alignment.bottomCenter,
            child: ExpandableSection(
              expand: _shown,
              axisAlignment: -1,
              child: const NetwolfSheet(),
            ),
          ),
        ],
      ),
    );
  }

  void _show() {
    if (widget.enabled) setState(() => _shown = true);
  }

  void _hide() {
    setState(() => _shown = false);
  }
}
