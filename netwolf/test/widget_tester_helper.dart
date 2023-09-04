import 'package:flutter/material.dart';
import 'package:netwolf/netwolf.dart';

class WidgetTesterHelper extends StatelessWidget {
  const WidgetTesterHelper({
    super.key,
    required this.enabled,
    required this.navigatorKey,
    required this.tapsToShow,
    this.child,
  });

  final bool enabled;
  final GlobalKey<NavigatorState> navigatorKey;
  final int tapsToShow;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      builder: (context, child) => NetwolfWidget(
        enabled: enabled,
        navigatorKey: navigatorKey,
        tapsToShow: tapsToShow,
        child: child ?? Container(),
      ),
      home: child ?? const Scaffold(),
    );
  }
}
