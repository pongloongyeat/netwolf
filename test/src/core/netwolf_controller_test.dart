import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netwolf/netwolf.dart';
import 'package:netwolf/src/core/exceptions.dart';
import 'package:netwolf/src/repositories/request_repository.dart';

import '../../init.dart';

final class _MockRequestRepository extends Mock implements RequestRepository {}

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
      'returns a NetwolfLoggingDisabledException if adding or updating '
      'a request when logging is disabled',
      () async {
        final controller = MockNetwolfController()..disableLogging();

        final mockRequest = NetwolfRequest.uri(
          method: HttpRequestMethod.get,
          uri: Uri(),
        );
        final result = await controller.addRequest(mockRequest);

        expect(
          result,
          isA<Result<NetwolfRequest, Exception>>().having(
            (s) => s.error,
            'error',
            isA<NetwolfLoggingDisabledException>(),
          ),
        );

        expect(
          await controller.updateRequest(Random().nextInt(100), mockRequest),
          isA<Result<NetwolfRequest, Exception>>().having(
            (s) => s.error,
            'error',
            isA<NetwolfLoggingDisabledException>(),
          ),
        );
      },
    );

    test('calls the correct repository methods', () async {
      final controller = MockNetwolfController();
      final _repository = _MockRequestRepository();
      await controller.init(repositoryOverride: _repository);

      final mockRequest = NetwolfRequest.uri(
        method: HttpRequestMethod.get,
        uri: Uri(),
      );

      when(_repository.getRequests)
          .thenAnswer((_) async => Result([mockRequest]));
      when(() => _repository.getRequestById(any()))
          .thenAnswer((_) async => Result(mockRequest));
      when(() => _repository.addRequest(mockRequest))
          .thenAnswer((_) async => Result(mockRequest));
      when(() => _repository.updateRequest(any(), mockRequest))
          .thenAnswer((_) async => Result(mockRequest));
      when(_repository.deleteAllRequests)
          .thenAnswer((_) async => const Result(null));

      await controller.getRequests();
      verify(_repository.getRequests).called(1);

      await controller.getRequestById(Random().nextInt(100));
      verify(() => _repository.getRequestById(any())).called(1);

      await controller.addRequest(mockRequest);
      verify(() => _repository.addRequest(mockRequest)).called(1);

      await controller.updateRequest(Random().nextInt(100), mockRequest);
      verify(() => _repository.updateRequest(any(), mockRequest)).called(1);

      await controller.clearAll();
      verify(_repository.deleteAllRequests).called(1);
    });
  });
}
