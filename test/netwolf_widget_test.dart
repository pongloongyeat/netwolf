import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:netwolf/netwolf.dart';
import 'package:netwolf/src/widgets/widgets.dart';

import 'utils.dart';

void main() {
  Widget buildWidget({required bool enabled}) {
    return TesterHelperWidget(
      child: NetwolfWidget(
        enabled: enabled,
        child: Container(),
      ),
    );
  }

  group('NetwolfWidget', () {
    testWidgets('shows if enable is true', (tester) async {
      final widget = buildWidget(enabled: true);

      await tester.pumpWidget(widget);

      NetwolfController.instance.show();

      await tester.pumpAndSettle();

      expect(find.byType(NetwolfSheet), findsOneWidget);
    });

    testWidgets('does not show if enable is false', (tester) async {
      final widget = buildWidget(enabled: false);

      await tester.pumpWidget(widget);

      NetwolfController.instance.show();

      await tester.pumpAndSettle();

      expect(find.byType(NetwolfSheet), findsNothing);
    });

    testWidgets('shows added request', (tester) async {
      final widget = buildWidget(enabled: true);

      await tester.pumpWidget(widget);

      NetwolfController.instance.addRequest(
        fakeRequest.requestHashCode,
        method: fakeRequest.method,
        url: fakeRequest.url,
        requestHeaders: fakeRequest.requestHeaders,
        requestBody: fakeRequest.requestBody,
      );
      NetwolfController.instance.show();

      await tester.pumpAndSettle();

      expect(find.byType(NetwolfRequestListViewItem), findsOneWidget);
    });

    testWidgets('shows empty listing on clearResponse', (tester) async {
      final widget = buildWidget(enabled: true);

      await tester.pumpWidget(widget);

      NetwolfController.instance.addRequest(
        fakeRequest.requestHashCode,
        method: fakeRequest.method,
        url: fakeRequest.url,
        requestHeaders: fakeRequest.requestHeaders,
        requestBody: fakeRequest.requestBody,
      );
      NetwolfController.instance.clearResponses();

      await tester.pumpAndSettle();

      expect(find.byType(NetwolfRequestListViewItem), findsNothing);
    });

    testWidgets('is able to filter responses by URL', (tester) async {
      final widget = buildWidget(enabled: true);

      await tester.pumpWidget(widget);

      NetwolfController.instance
        ..addRequest(
          fakeRequest.requestHashCode,
          method: fakeRequest.method,
          url: 'http://1.xyz',
          requestHeaders: fakeRequest.requestHeaders,
          requestBody: fakeRequest.requestBody,
        )
        ..addRequest(
          fakeRequest.requestHashCode,
          method: fakeRequest.method,
          url: 'http://1.xyz',
          requestHeaders: fakeRequest.requestHeaders,
          requestBody: fakeRequest.requestBody,
        )
        ..addRequest(
          fakeRequest.requestHashCode + 1,
          method: fakeRequest.method,
          url: 'http://2.xyz',
          requestHeaders: fakeRequest.requestHeaders,
          requestBody: fakeRequest.requestBody,
        )
        ..show();

      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '1');
      await tester.pumpAndSettle();

      expect(find.byType(NetwolfRequestListViewItem), findsNWidgets(2));

      NetwolfController.instance.clearResponses();
    });

    testWidgets('does not show if it is already open', (tester) async {
      final widget = buildWidget(enabled: true);

      await tester.pumpWidget(widget);

      NetwolfController.instance.show();
      NetwolfController.instance.show();

      await tester.pumpAndSettle();

      expect(find.byType(NetwolfSheet), findsOneWidget);
    });
  });
}
