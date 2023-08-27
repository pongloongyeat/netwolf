import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:netwolf/src/core/enums.dart';
import 'package:netwolf/src/core/netwolf_controller.dart';
import 'package:netwolf/src/models/netwolf_request.dart';
import 'package:netwolf/src/repositories/request_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../../init.dart';

void main() {
  late Database db;
  late RequestRepository repository;

  initMockDb();

  setUp(() async {
    db = await initDb(
      restoreFromPreviousSession: false,
      dbPathOverride: inMemoryDatabasePath,
    );
    repository = RequestRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('RequestRepository', () {
    final mockRequest = NetwolfRequest.uri(
      method: HttpRequestMethod.get,
      uri: Uri(),
    );

    test('can add a request', () async {
      final result = await repository.addRequest(mockRequest);
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
          mockRequest.toDbObject(),
        ),
        isTrue,
      );
    });

    test('can update a request', () async {
      final result = await repository.addRequest(mockRequest);
      final data = result.data!;
      final dbObject = data.toDbObject();
      final updatedData = data.copyWith(
        statusCode: 200,
        endTime: DateTime.now(),
      );
      final updatedResult = await repository.updateRequest(data, updatedData);

      expect(updatedResult.hasError, isFalse);
      expect(updatedResult.data, isNotNull);

      final updatedDbObject = updatedResult.data!.toDbObject();

      expect(
        const DeepCollectionEquality().equals(dbObject, updatedDbObject),
        isTrue,
      );
    });

    test('can get requests', () async {
      var result = await repository.getRequests();
      var data = result.data;

      expect(result.hasError, isFalse);
      expect(data, isNotNull);
      expect(data, isEmpty);

      await repository.addRequest(mockRequest);
      result = await repository.getRequests();
      data = result.data;

      expect(result.hasError, isFalse);
      expect(data, isNotNull);
      expect(data!.length, 1);
    });

    test('can get a specific request', () async {
      final request = await repository.addRequest(mockRequest);
      final result = await repository.getRequestById(request.data!.id!);
      final data = result.data;

      expect(result.hasError, isFalse);
      expect(data, isNotNull);

      final dbObject = result.data!.toDbObject();

      // Remove the assigned ID since our mock data will not have any ID
      dbObject['id'] = null;

      expect(
        const DeepCollectionEquality().equals(
          dbObject,
          mockRequest.toDbObject(),
        ),
        isTrue,
      );
    });

    test('can delete a specific request', () async {
      const numberOfRequestsToAdd = 5;
      for (var i = 0; i < numberOfRequestsToAdd; i++) {
        await repository.addRequest(mockRequest);
      }

      var allRequestsResult = await repository.getRequests();
      var allRequests = allRequestsResult.data;

      expect(allRequestsResult.hasError, isFalse);
      expect(allRequests, isNotNull);
      expect(allRequests!.length, numberOfRequestsToAdd);

      final random = Random();
      final randomRequest = allRequests[random.nextInt(allRequests.length)];

      final deletedRequestResult =
          await repository.deleteRequestById(randomRequest.id!);
      allRequestsResult = await repository.getRequests();
      allRequests = allRequestsResult.data;

      expect(deletedRequestResult.hasError, isFalse);
      expect(allRequestsResult.hasError, isFalse);
      expect(allRequests, isNotNull);
      expect(allRequests!.length, numberOfRequestsToAdd - 1);
      expect(
        allRequests.any((element) => element.id == randomRequest.id!),
        isFalse,
      );
    });

    test('can delete all requests', () async {
      const numberOfRequestsToAdd = 5;
      for (var i = 0; i < numberOfRequestsToAdd; i++) {
        await repository.addRequest(mockRequest);
      }

      var allRequestsResult = await repository.getRequests();
      var allRequests = allRequestsResult.data;

      expect(allRequestsResult.hasError, isFalse);
      expect(allRequests, isNotNull);
      expect(allRequests!.length, numberOfRequestsToAdd);

      final deletedAllRequestsResult = await repository.deleteAllRequests();
      allRequestsResult = await repository.getRequests();
      allRequests = allRequestsResult.data;

      expect(deletedAllRequestsResult.hasError, isFalse);
      expect(allRequestsResult.hasError, isFalse);
      expect(allRequests, isNotNull);
      expect(allRequests, isEmpty);
    });
  });
}
