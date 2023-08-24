import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:netwolf/src/core/netwolf_controller.dart';
import 'package:netwolf/src/enums.dart';
import 'package:netwolf/src/models/netwolf_request.dart';
import 'package:netwolf/src/models/netwolf_response.dart';
import 'package:netwolf/src/repositories/request_repository.dart';
import 'package:netwolf/src/repositories/response_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../../init.dart';

void main() {
  late Database db;
  late ResponseRepository repository;

  late NetwolfRequest mockRequest;
  late NetwolfResponse mockResponse;

  initMockDb();

  setUp(() async {
    db = await initDb(
      restoreFromPreviousSession: false,
      dbPathOverride: inMemoryDatabasePath,
    );

    mockRequest = NetwolfRequest.uri(
      method: HttpRequestMethod.get,
      uri: Uri(),
    );
    final requestRepository = RequestRepository(db);
    final result = await requestRepository.addRequest(mockRequest);
    mockRequest = result.data!;
    mockResponse = NetwolfResponse(
      request: mockRequest,
      statusCode: 200,
      endTime: DateTime.now(),
    );

    repository = ResponseRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('ResponseRepository', () {
    test('can add a response', () async {
      final result = await repository.addResponse(mockResponse);
      final data = result.data;

      expect(result.hasError, isFalse);
      expect(data, isNotNull);
      expect(data!.id, isNotNull);

      final dbObject = result.data!.toDbObject();

      // Remove the assigned ID since our mock data will not have any ID
      dbObject['id'] = null;

      expect(
        const DeepCollectionEquality().equals(
          dbObject,
          mockResponse.toDbObject(),
        ),
        isTrue,
      );
    });

    test('can get responses', () async {
      var result = await repository.getResponses();
      var data = result.data;

      expect(result.hasError, isFalse);
      expect(data, isNotNull);
      expect(data, isEmpty);

      await repository.addResponse(mockResponse);
      result = await repository.getResponses();
      data = result.data;

      expect(result.hasError, isFalse);
      expect(data, isNotNull);
      expect(data!.length, 1);
    });

    test('can get a specific response', () async {
      final request = await repository.addResponse(mockResponse);
      final result = await repository.getResponseById(request.data!.id!);
      final data = result.data;

      expect(result.hasError, isFalse);
      expect(data, isNotNull);

      final dbObject = result.data!.toDbObject();

      // Remove the assigned ID since our mock data will not have any ID
      dbObject['id'] = null;

      expect(
        const DeepCollectionEquality().equals(
          dbObject,
          mockResponse.toDbObject(),
        ),
        isTrue,
      );
    });
  });
}
