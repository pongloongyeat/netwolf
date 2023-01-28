import 'package:flutter/material.dart';
import 'package:netwolf/netwolf.dart';

final fakeResponse = NetwolfResponse(
  method: HttpRequestMethod.get,
  responseCode: 200,
  url: 'https://abc.xyz',
  requestHeaders: null,
  requestBody: null,
  responseHeaders: null,
  responseBody: null,
);

class TesterHelperWidget extends StatelessWidget {
  const TesterHelperWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: child);
  }
}
