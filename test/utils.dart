import 'package:flutter/material.dart';
import 'package:netwolf/netwolf.dart';

final fakeRequest = NetwolfResponse(
  method: HttpRequestMethod.get,
  responseCode: 200,
  url: 'https://abc.xyz',
  startTime: DateTime.now(),
  endTime: null,
  requestHeaders: null,
  requestBody: null,
  responseHeaders: null,
  responseBody: null,
  requestHashCode: 1,
);

class TesterHelperWidget extends StatelessWidget {
  const TesterHelperWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: child);
  }
}
