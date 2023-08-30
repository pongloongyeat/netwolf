import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:netwolf/src/ui/pages/netwolf_landing_page.dart';
import 'package:netwolf/src/ui/widgets/netwolf_widget.dart';

import '../../widget_tester_helper.dart';

typedef NavigatorKey = GlobalKey<NavigatorState>;

void main() {
  setUp(TestWidgetsFlutterBinding.ensureInitialized);

  group('NetwolfWidget', () {
    testWidgets('displays when tapped specified number of times',
        (tester) async {
      final key = GlobalKey();
      final tapsToShow = Random().nextInt(10);
      final widget = WidgetTesterHelper(
        key: key,
        enabled: true,
        navigatorKey: NavigatorKey(),
        tapsToShow: tapsToShow,
        child: const Scaffold(),
      );

      await tester.pumpWidget(widget);
      expect(find.byType(NetwolfWidget), findsOneWidget);
      expect(find.byType(NetwolfLandingPage), findsNothing);

      for (var _ = 0; _ < tapsToShow; _++) {
        await tester.tap(find.byKey(key));
      }

      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      expect(find.byType(NetwolfLandingPage), findsOneWidget);
    });
  });
}
