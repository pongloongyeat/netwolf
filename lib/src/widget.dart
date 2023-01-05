import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:netwolf/src/constants.dart';
import 'package:netwolf/src/dialogs/dialogs.dart';
import 'package:netwolf/src/enums.dart';
import 'package:netwolf/src/extensions.dart';
import 'package:netwolf/src/netwolf_response.dart';
import 'package:netwolf/src/pages/pages.dart';
import 'package:netwolf/src/widgets/widgets.dart';

part 'controller.dart';
part 'pages/landing.dart';
part 'widgets/search_bar.dart';
part 'widgets/listing.dart';

class NetwolfWidget extends StatelessWidget {
  /// The default constructor.
  const NetwolfWidget({
    super.key,
    this.enabled = kDebugMode,
    this.enableLogging = kDebugMode,
    this.controller,
    this.child,
  });

  /// A convenience factory if wrapping around [MaterialApp.builder].
  factory NetwolfWidget.builder(BuildContext _, Widget? child) {
    return NetwolfWidget(child: child);
  }

  /// Enables/disables Netwolf. If disabled, this will not show the overlay
  /// even if [NetwolfController.show] is called
  final bool enabled;

  /// Enables/disables Netwolf from logging requests. If disabled, this will
  /// not log any requests, even if [enabled] is true.
  final bool enableLogging;

  /// The controller associated with this widget. If specified, the widget
  /// uses the specified controller, otherwise, it uses
  /// [NetwolfController.instance]. If you need to customise when to show or
  /// hide Netwolf, you can call [NetwolfController.show], provided [enabled]
  /// is true.
  final NetwolfController? controller;

  final Widget? child;

  NetwolfController get _effectiveController =>
      controller ?? NetwolfController.instance;

  @override
  Widget build(BuildContext context) {
    _effectiveController.setLogging(enableLogging);

    return Portal(
      child: _NetwolfWidget(
        key: _effectiveController._widgetKey,
        enabled: enabled,
        controller: controller,
        child: child,
      ),
    );
  }
}

class _NetwolfWidget extends StatefulWidget {
  const _NetwolfWidget({
    super.key,
    required this.enabled,
    required this.controller,
    required this.child,
  });

  final bool enabled;
  final NetwolfController? controller;
  final Widget? child;

  @override
  State<_NetwolfWidget> createState() => _NetwolfWidgetState();
}

class _NetwolfWidgetState extends State<_NetwolfWidget> {
  bool _shown = false;

  NetwolfController get _effectiveController =>
      widget.controller ?? NetwolfController.instance;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child ?? Container(),
        Align(
          alignment: Alignment.bottomCenter,
          child: ExpandableSection(
            expand: _shown,
            axisAlignment: -1,
            child: NetwolfSheet(controller: _effectiveController),
          ),
        ),
      ],
    );
  }

  void _setNetwolfState(bool show) {
    if (_shown == show) return;
    setState(() => _shown = show);
  }

  void showNetwolf() {
    if (widget.enabled) _setNetwolfState(true);
  }

  void hideNetwolf() {
    _setNetwolfState(false);
  }
}
