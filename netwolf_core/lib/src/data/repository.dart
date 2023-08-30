import 'dart:developer';

import 'package:netwolf_core/src/core/exceptions.dart';
import 'package:netwolf_core/src/core/typedefs.dart';
import 'package:netwolf_core/src/data/database.dart';
import 'package:netwolf_core/src/data/models/data.dart';
import 'package:netwolf_core/src/data/models/dtos.dart';
import 'package:netwolf_core/src/data/models/result.dart';

final class NetwolfRepository {
  NetwolfRepository(this.db);

  final NetwolfDatabase db;

  Future<Result<List<NetwolfRequestData>, NetwolfException>>
      getAllRequests() async {
    try {
      final query = await db.getAllRequests().get();
      return Result(
        query.map(NetwolfRequestData.fromGetAllRequestsResult).toList(),
      );
    } catch (e) {
      return Result.error(NetwolfDbException(e.toString()));
    }
  }

  Future<Result<NetwolfRequestData, NetwolfException>> getRequestById(
    Id id,
  ) async {
    try {
      final query = await db.getRequestById(id).getSingle();
      return Result(NetwolfRequestData.fromNetwolfRequest(query));
    } catch (e) {
      log(e.toString());
      return Result.error(NetwolfDbException(e.toString()));
    }
  }

  Future<Result<Id, NetwolfException>> addRequest(
    AddRequestDto addRequest,
  ) async {
    try {
      final id = await db.insertRequest(
        addRequest.method,
        addRequest.url,
        addRequest.startTime,
        addRequest.requestHeaders,
        addRequest.requestBody,
      );
      return Result(id);
    } catch (e) {
      log(e.toString());
      return Result.error(NetwolfDbException(e.toString()));
    }
  }

  Future<Result<void, NetwolfException>> completeRequest(
    CompleteRequestDto completeRequest,
  ) async {
    try {
      await db.completeRequest(
        completeRequest.statusCode,
        completeRequest.endTime,
        completeRequest.responseHeaders,
        completeRequest.responseBody,
        completeRequest.id,
      );
      return const Result(null);
    } catch (e) {
      log(e.toString());
      return Result.error(NetwolfDbException(e.toString()));
    }
  }

  Future<Result<void, NetwolfException>> deleteAllRequests() async {
    try {
      await db.deleteAllRequests();
      return const Result(null);
    } catch (e) {
      log(e.toString());
      return Result.error(NetwolfDbException(e.toString()));
    }
  }

  Future<Result<void, NetwolfException>> deleteRequestById(Id id) async {
    try {
      await db.deleteRequestById(id);
      return const Result(null);
    } catch (e) {
      log(e.toString());
      return Result.error(NetwolfDbException(e.toString()));
    }
  }
}
