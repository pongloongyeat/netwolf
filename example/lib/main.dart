import 'dart:math';

import 'package:flutter/material.dart';
import 'package:netwolf/netwolf.dart';

void main() {
  runApp(
    const MaterialApp(
      builder: NetwolfWidget.builder,
      home: SomePage(),
    ),
  );
}

class SomePage extends StatelessWidget {
  const SomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Netwolf Demo')),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  ElevatedButton(
                    onPressed: NetwolfController.instance.show,
                    child: const Text('Show'),
                  ),
                  const ElevatedButton(
                    onPressed: null,
                    child: Text('Mock response'),
                  ),
                  ElevatedButton(
                    onPressed: () => NetwolfController.instance
                        .addResponse(_generateRandomResponse()),
                    child: const Text('Add custom response'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  NetwolfResponse _generateRandomResponse() => NetwolfResponse(
        url: Random().nextBool() ? 'https://google.com/' : null,
        method: Random().nextBool()
            ? HttpRequestMethod
                .values[Random().nextInt(HttpRequestMethod.values.length)]
            : null,
        status: Random().nextBool()
            ? HttpResponseStatus
                .values[Random().nextInt(HttpResponseStatus.values.length)]
            : null,
      );
}
