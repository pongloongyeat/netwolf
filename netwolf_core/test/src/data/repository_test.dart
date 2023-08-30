import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:netwolf_core/src/core/enums.dart';
import 'package:netwolf_core/src/data/database.dart';
import 'package:netwolf_core/src/data/models/dtos.dart';
import 'package:netwolf_core/src/data/repository.dart';
import 'package:test/test.dart';

void main() {
  late NetwolfDatabase database;
  late NetwolfRepository repository;

  setUp(() {
    database = NetwolfDatabase(queryExecutor: NativeDatabase.memory());
    repository = NetwolfRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('NetwolfRepository', () {
    test('can add a request', () async {
      expect(await database.netwolfRequests.all().get(), isEmpty);

      final addRequestDto = AddRequestDto(
        method: HttpRequestMethod.get,
        uri: Uri.parse('http://path.to'),
        startTime: DateTime.now(),
        requestHeaders: {'a': 1},
        requestBody: 'test',
      );
      final result = await repository.addRequest(addRequestDto);
      final id = result.data;

      expect(result.hasError, isFalse);
      expect(id, isNotNull);

      final data = await database.netwolfRequests.all().get();

      expect(
        data,
        isList.having((l) => l.length, 'length', 1),
      );
      expect(data.first.id, id);
      expect(data.first.method, addRequestDto.method);
      expect(data.first.url, addRequestDto.url);
      expect(data.first.startTime, addRequestDto.startTime);
      expect(data.first.requestHeaders, addRequestDto.requestHeaders);
      expect(data.first.requestBody, addRequestDto.requestBody);
    });

    test('can get all requests', () async {
      final addRequestDto = AddRequestDto(
        method: HttpRequestMethod.get,
        uri: Uri.parse('http://path.to'),
        startTime: DateTime.now(),
        requestHeaders: {'a': 1},
        requestBody: 'test',
      );
      await database.insertRequest(
        addRequestDto.method,
        addRequestDto.url,
        addRequestDto.startTime,
        addRequestDto.requestHeaders,
        addRequestDto.requestBody,
      );

      final result = await repository.getAllRequests();
      final data = result.data;

      expect(result.hasError, isFalse);
      expect(data, isNotNull);
      expect(data!.length, 1);
      expect(data.first.method, addRequestDto.method);
      expect(data.first.uri.toString(), addRequestDto.url);
      expect(data.first.startTime, addRequestDto.startTime);
      expect(data.first.requestHeaders, addRequestDto.requestHeaders);
      expect(data.first.requestBody, addRequestDto.requestBody);
    });

    test('can get a specific request', () async {
      final addRequestDto = AddRequestDto(
        method: HttpRequestMethod.get,
        uri: Uri.parse('http://path.to'),
        startTime: DateTime.now(),
        requestHeaders: {'a': 1},
        requestBody: 'test',
      );
      final request = await repository.addRequest(addRequestDto);
      final result = await repository.getRequestById(request.data!);
      final data = result.data;

      expect(result.hasError, isFalse);
      expect(data, isNotNull);
    });

    // test('can update a request with a specific ID', () async {
    //   final result = await repository.addRequest(mockRequest);
    //   final data = result.data!;

    //   final updatedData = data.completeRequest(
    //     statusCode: 200,
    //     endTime: DateTime.now(),
    //   );
    //   final updatedResult = await repository.updateRequest(
    //     data.id!,
    //     dbObject: updatedData.toDbObject(),
    //   );

    //   expect(updatedResult.hasError, isFalse);

    //   final updatedResultInDb = await repository.getRequestById(data.id!);
    //   expect(
    //     const DeepCollectionEquality().equals(
    //       updatedData.toDbObject(),
    //       updatedResultInDb.data!.toDbObject(),
    //     ),
    //     isTrue,
    //   );
    // });

    // test('can delete a specific request', () async {
    //   const numberOfRequestsToAdd = 5;
    //   for (var i = 0; i < numberOfRequestsToAdd; i++) {
    //     await repository.addRequest(mockRequest);
    //   }

    //   var allRequestsResult = await repository.getRequests();
    //   var allRequests = allRequestsResult.data;

    //   expect(allRequestsResult.hasError, isFalse);
    //   expect(allRequests, isNotNull);
    //   expect(allRequests!.length, numberOfRequestsToAdd);

    //   final random = Random();
    //   final randomRequest = allRequests[random.nextInt(allRequests.length)];

    //   final deletedRequestResult =
    //       await repository.deleteRequestById(randomRequest.id!);
    //   allRequestsResult = await repository.getRequests();
    //   allRequests = allRequestsResult.data;

    //   expect(deletedRequestResult.hasError, isFalse);
    //   expect(allRequestsResult.hasError, isFalse);
    //   expect(allRequests, isNotNull);
    //   expect(allRequests!.length, numberOfRequestsToAdd - 1);
    //   expect(
    //     allRequests.any((element) => element.id == randomRequest.id!),
    //     isFalse,
    //   );
    // });

    // test('can delete all requests', () async {
    //   const numberOfRequestsToAdd = 5;
    //   for (var i = 0; i < numberOfRequestsToAdd; i++) {
    //     await repository.addRequest(mockRequest);
    //   }

    //   var allRequestsResult = await repository.getRequests();
    //   var allRequests = allRequestsResult.data;

    //   expect(allRequestsResult.hasError, isFalse);
    //   expect(allRequests, isNotNull);
    //   expect(allRequests!.length, numberOfRequestsToAdd);

    //   final deletedAllRequestsResult = await repository.deleteAllRequests();
    //   allRequestsResult = await repository.getRequests();
    //   allRequests = allRequestsResult.data;

    //   expect(deletedAllRequestsResult.hasError, isFalse);
    //   expect(allRequestsResult.hasError, isFalse);
    //   expect(allRequests, isNotNull);
    //   expect(allRequests, isEmpty);
    // });
  });
}
