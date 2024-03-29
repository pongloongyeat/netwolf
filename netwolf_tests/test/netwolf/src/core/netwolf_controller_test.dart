import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netwolf/src/core/enums.dart';
import 'package:netwolf/src/core/exceptions.dart';
import 'package:netwolf/src/core/netwolf_controller.dart';
import 'package:netwolf/src/models/netwolf_request.dart';
import 'package:netwolf/src/models/result.dart';
import 'package:netwolf/src/repositories/request_repository.dart';

import '../../init.dart';

final class _MockRequestRepository extends Mock implements RequestRepository {}

void main() {
  initMockDb();
  setUp(
    () => registerFallbackValue(
      NetwolfRequest.uri(
        method: HttpRequestMethod.get,
        uri: Uri(),
      ),
    ),
  );

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
          await controller.completeRequest(Random().nextInt(100)),
          isA<Result<void, Exception>>().having(
            (s) => s.error,
            'error',
            isA<NetwolfLoggingDisabledException>(),
          ),
        );
      },
    );

    test('calls the correct repository methods', () async {
      final controller = MockNetwolfController();
      final repository = _MockRequestRepository();
      await controller.init(repositoryOverride: repository);

      final mockRequest = NetwolfRequest.uri(
        method: HttpRequestMethod.get,
        uri: Uri(),
      );

      when(repository.getRequests)
          .thenAnswer((_) async => Result([mockRequest]));
      when(() => repository.getRequestById(any()))
          .thenAnswer((_) async => Result(mockRequest));
      when(() => repository.addRequest(any()))
          .thenAnswer((_) async => Result(mockRequest));
      when(
        () => repository.updateRequest(
          any(),
          dbObject: any(named: 'dbObject'),
        ),
      ).thenAnswer((_) async => const Result(null));
      when(repository.deleteAllRequests)
          .thenAnswer((_) async => const Result(null));

      await controller.getRequests();
      verify(repository.getRequests).called(1);

      await controller.getRequestById(Random().nextInt(100));
      verify(() => repository.getRequestById(any())).called(1);

      await controller.addRequest(mockRequest);
      verify(() => repository.addRequest(mockRequest)).called(1);

      await controller.completeRequest(Random().nextInt(100));
      verify(
        () => repository.updateRequest(
          any(),
          dbObject: any(named: 'dbObject'),
        ),
      ).called(1);

      await controller.clearAll();
      verify(repository.deleteAllRequests).called(1);
    });
  });
}
