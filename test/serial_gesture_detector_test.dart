import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:netwolf/src/widgets/widgets.dart';

import 'utils.dart';

void main() {
  Widget buildWidget(
    int? numberOfTaps,
    VoidCallback onTap,
  ) {
    return TesterHelperWidget(
      child: SerialGestureDetector(
        count: numberOfTaps,
        onSerialTap: onTap,
        child: const Text('Visible'),
      ),
    );
  }

  group('SerialGestureDetector', () {
    testWidgets('Triggers callback on correct number of taps', (tester) async {
      const numberOfConsecutiveTapsForOneTap = 5;
      var numberOfTapsReceived = 0;
      final widget = buildWidget(
        numberOfConsecutiveTapsForOneTap,
        () => numberOfTapsReceived++,
      );

      await tester.pumpWidget(widget);

      for (var i = 0; i < numberOfConsecutiveTapsForOneTap; i++) {
        await tester.tap(find.byType(Text));
      }

      expect(numberOfTapsReceived, 1);
    });

    testWidgets(
        'Does not trigger callback if number of taps is less than specified',
        (tester) async {
      const numberOfConsecutiveTapsForOneTap = 5;
      var numberOfTapsReceived = 0;
      final widget = buildWidget(
        numberOfConsecutiveTapsForOneTap,
        () => numberOfTapsReceived++,
      );

      await tester.pumpWidget(widget);

      for (var i = 0; i < numberOfConsecutiveTapsForOneTap - 1; i++) {
        await tester.tap(find.byType(Text));
      }

      expect(numberOfTapsReceived, 0);
    });

    testWidgets('Does not trigger callback on null number of taps',
        (tester) async {
      var numberOfTapsReceived = 0;
      final widget = buildWidget(
        null,
        () => numberOfTapsReceived++,
      );

      await tester.pumpWidget(widget);

      for (var i = 0; i < 5; i++) {
        await tester.tap(find.byType(Text));
      }

      expect(numberOfTapsReceived, 0);
    });
  });
}
