import 'package:flutter/material.dart';
import 'package:netwolf/src/widget.dart';
import 'package:netwolf/src/widgets/widgets.dart';

class NetwolfSheet extends StatelessWidget {
  const NetwolfSheet({super.key, required this.controller});

  final NetwolfController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: NetwolfRouter(
        initialPage: Builder(
          builder: (context) => NetwolfLanding(controller: controller),
        ),
      ),
    );
  }
}
