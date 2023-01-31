import 'package:flutter_test/flutter_test.dart';
import 'package:netwolf/netwolf.dart';

import 'utils.dart';

void main() {
  group('NetwolfController', () {
    setUp(NetwolfController.instance.clearResponses);

    test('adds a request on addRequest', () {
      NetwolfController.instance.addRequest(
        fakeRequest.requestHashCode,
        method: fakeRequest.method,
        url: fakeRequest.url,
        requestHeaders: fakeRequest.requestHeaders,
        requestBody: fakeRequest.requestBody,
      );
      expect(NetwolfController.instance.responses.length, 1);
    });

    test('does not add a request on addRequest if logging is false', () {
      NetwolfController.instance.disableLogging();
      NetwolfController.instance.addRequest(
        fakeRequest.requestHashCode,
        method: fakeRequest.method,
        url: fakeRequest.url,
        requestHeaders: fakeRequest.requestHeaders,
        requestBody: fakeRequest.requestBody,
      );
      expect(NetwolfController.instance.responses.length, 0);
      NetwolfController.instance.enableLogging();
    });

    test(
        'marks a request as completed when adding a response corresponding '
        'to a request', () {
      NetwolfController.instance.addRequest(
        fakeRequest.requestHashCode,
        method: fakeRequest.method,
        url: fakeRequest.url,
        requestHeaders: fakeRequest.requestHeaders,
        requestBody: fakeRequest.requestBody,
      );
      NetwolfController.instance.addResponse(
        fakeRequest.requestHashCode,
        method: null,
        responseCode: fakeRequest.responseCode,
        url: null,
        requestHeaders: null,
        requestBody: null,
        responseHeaders: null,
        responseBody: null,
      );
      expect(NetwolfController.instance.responses.length, 1);
      expect(NetwolfController.instance.responses.first.completed, isTrue);
    });

    test(
        'does not mark a request as completed when adding a response NOT '
        'corresponding to a request', () {
      NetwolfController.instance.addRequest(
        fakeRequest.requestHashCode,
        method: fakeRequest.method,
        url: fakeRequest.url,
        requestHeaders: fakeRequest.requestHeaders,
        requestBody: fakeRequest.requestBody,
      );
      NetwolfController.instance.addResponse(
        fakeRequest.requestHashCode + 1,
        method: null,
        responseCode: fakeRequest.responseCode,
        url: null,
        requestHeaders: null,
        requestBody: null,
        responseHeaders: null,
        responseBody: null,
      );
      expect(NetwolfController.instance.responses.length, 2);
      expect(NetwolfController.instance.responses.first.completed, isTrue);
      expect(NetwolfController.instance.responses.last.completed, isFalse);
    });

    test('clears responses on clearResponses', () {
      NetwolfController.instance.addRequest(
        fakeRequest.requestHashCode,
        method: fakeRequest.method,
        url: fakeRequest.url,
        requestHeaders: fakeRequest.requestHeaders,
        requestBody: fakeRequest.requestBody,
      );
      NetwolfController.instance.clearResponses();
      expect(NetwolfController.instance.responses.length, 0);
    });
  });
}
