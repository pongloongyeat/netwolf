import 'package:flutter/material.dart';
import 'package:netwolf/src/pages/pages.dart';
import 'package:netwolf/src/widgets/widgets.dart';

class NetwolfSheet extends StatelessWidget {
  const NetwolfSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return NetwolfRouter(
      initialPage: Builder(
        builder: (_) => const LandingPage(),
      ),
    );
  }
}
