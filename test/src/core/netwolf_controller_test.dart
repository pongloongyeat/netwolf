import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netwolf/netwolf.dart';
import 'package:netwolf/src/core/exceptions.dart';
import 'package:netwolf/src/repositories/request_repository.dart';
import 'package:netwolf/src/repositories/response_repository.dart';

import '../../init.dart';

final class _MockRequestRepository extends Mock implements RequestRepository {}

final class _MockResponseRepository extends Mock
    implements ResponseRepository {}

void main() {
  initMockDb();

  group('NetwolfController', () {
    test('has initial logging value of true', () {
      final controller = MockNetwolfController();
      expect(controller.logging, isTrue);
    });

    test('updates logging getter when calling log-related methods', () {
      final controller = MockNetwolfController();

      expect(controller.logging, isTrue);

      controller.disableLogging();

      expect(controller.logging, isFalse);

      controller.enableLogging();

      expect(controller.logging, isTrue);
    });

    test(
      'returns a NetwolfLoggingDisabledException if adding a request '
      'or response when logging is disabled',
      () async {
        final controller = MockNetwolfController()..disableLogging();

        final mockRequest = NetwolfRequest.uri(
          method: HttpRequestMethod.get,
          uri: Uri(),
        );
        final mockResponse = NetwolfResponse(
          request: mockRequest,
          statusCode: 200,
          endTime: DateTime.now(),
        );

        expect(
          await controller.addRequest(mockRequest),
          isA<Result<NetwolfRequest, Exception>>().having(
            (s) => s.error,
            'error',
            isA<NetwolfLoggingDisabledException>(),
          ),
        );

        expect(
          await controller.addResponse(mockResponse),
          isA<Result<NetwolfResponse, Exception>>().having(
            (s) => s.error,
            'error',
            isA<NetwolfLoggingDisabledException>(),
          ),
        );
      },
    );

    test('calls the correct repository methods', () async {
      final controller = MockNetwolfController();
      final requestRepository = _MockRequestRepository();
      final responseRepository = _MockResponseRepository();
      await controller.init(
        requestRepositoryOverride: requestRepository,
        responseRepositoryOverride: responseRepository,
      );

      final mockRequest = NetwolfRequest.uri(
        method: HttpRequestMethod.get,
        uri: Uri(),
      );
      final mockResponse = NetwolfResponse(
        request: mockRequest,
        statusCode: 200,
        endTime: DateTime.now(),
      );

      when(() => requestRepository.addRequest(mockRequest))
          .thenAnswer((_) async => Result(mockRequest));
      when(() => responseRepository.addResponse(mockResponse))
          .thenAnswer((_) async => Result(mockResponse));
      when(requestRepository.deleteAllRequests)
          .thenAnswer((_) async => const Result(null));

      await controller.addRequest(mockRequest);
      verify(() => requestRepository.addRequest(mockRequest)).called(1);

      await controller.addResponse(mockResponse);
      verify(() => responseRepository.addResponse(mockResponse)).called(1);

      await controller.clearAll();
      verify(requestRepository.deleteAllRequests).called(1);
    });
  });
}
