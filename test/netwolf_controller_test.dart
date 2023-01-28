import 'package:flutter_test/flutter_test.dart';
import 'package:netwolf/netwolf.dart';

import 'utils.dart';

void main() {
  group('NetwolfController', () {
    test('adds a response on addResponse', () {
      NetwolfController.instance.addResponse(fakeResponse);
      expect(NetwolfController.instance.responses.length, 1);
      NetwolfController.instance.clearResponses();
    });

    test('does not add a response on addResponse if logging is false', () {
      NetwolfController.instance.disableLogging();
      NetwolfController.instance.addResponse(fakeResponse);
      expect(NetwolfController.instance.responses.length, 0);
      NetwolfController.instance.clearResponses();
      NetwolfController.instance.enableLogging();
    });

    test('clears responses on clearResponses', () {
      NetwolfController.instance.addResponse(fakeResponse);
      NetwolfController.instance.clearResponses();
      expect(NetwolfController.instance.responses.length, 0);
    });
  });
}
