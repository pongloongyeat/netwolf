import 'dart:developer';

import 'package:netwolf/src/core/exceptions.dart';
import 'package:netwolf/src/core/typedefs.dart';
import 'package:netwolf/src/models/netwolf_request.dart';
import 'package:netwolf/src/models/result.dart';
import 'package:sqflite/sqflite.dart';

class RequestRepository {
  RequestRepository(this.db);

  final Database db;

  Future<Result<List<NetwolfRequest>, NetwolfException>> getRequests() async {
    late List<DbObject> query;
    try {
      query = await db.query(
        NetwolfRequest.tableName,
        columns: [
          NetwolfRequestDbObjectKeys.id.name,
          NetwolfRequestDbObjectKeys.method.name,
          NetwolfRequestDbObjectKeys.url.name,
          NetwolfRequestDbObjectKeys.startTime.name,
          NetwolfRequestDbObjectKeys.statusCode.name,
          NetwolfRequestDbObjectKeys.endTime.name,
        ],
      );
    } catch (e) {
      log(e.toString());
      return Result.error(NetwolfDbException(e.toString()));
    }

    try {
      return Result(query.map(NetwolfRequest.fromDbObject).toList());
    } catch (e) {
      log(e.toString());
      return Result.error(NetwolfDecodingException());
    }
  }

  Future<Result<NetwolfRequest, NetwolfException>> getRequestById(Id id) async {
    late List<DbObject> query;
    try {
      query = await db.query(
        NetwolfRequest.tableName,
        where: '${NetwolfRequestDbObjectKeys.id.name} = ?',
        whereArgs: [id],
        limit: 1,
      );
    } catch (e) {
      log(e.toString());
      return Result.error(NetwolfDbException(e.toString()));
    }

    if (query.isEmpty) return Result.error(NetwolfRecordNotFoundException());

    try {
      return Result(NetwolfRequest.fromDbObject(query.first));
    } catch (e) {
      log(e.toString());
      return Result.error(NetwolfDecodingException());
    }
  }

  Future<Result<NetwolfRequest, NetwolfException>> addRequest(
    NetwolfRequest request,
  ) async {
    late Id id;
    try {
      id = await db.insert(NetwolfRequest.tableName, request.toDbObject());
      return Result(request.copyWith(id: id));
    } catch (e) {
      log(e.toString());
      return Result.error(NetwolfDbException(e.toString()));
    }
  }

  /// Updates a request in the DB. If [request]'s ID is specified,
  /// this updates that specific row. Otherwise, this tries to find the
  /// row where all the columns of this [request] matches and updates
  /// that row entry.
  Future<Result<NetwolfRequest, NetwolfException>> updateRequest(
    NetwolfRequest request,
    NetwolfRequest updatedRequest,
  ) async {
    final requestId = request.id;

    try {
      if (requestId != null) {
        await db.update(
          NetwolfRequest.tableName,
          updatedRequest.toDbObject(),
          where: '${NetwolfRequestDbObjectKeys.id.name} = ?',
          whereArgs: [requestId],
        );
      } else {
        final requestDbObject = request.toDbObject(withId: false);
        final nonNullKeys = requestDbObject
          ..removeWhere((key, value) => value == null);

        await db.update(
          NetwolfRequest.tableName,
          updatedRequest.toDbObject()..removeWhere((_, value) => value == null),
          where: nonNullKeys.keys.map((e) => '$e = ?').join(' AND '),
          whereArgs: nonNullKeys.keys.map((e) => requestDbObject[e]).toList(),
        );
      }
      return Result(request);
    } catch (e) {
      log(e.toString());
      return Result.error(NetwolfDbException(e.toString()));
    }
  }

  Future<Result<void, NetwolfException>> deleteAllRequests() async {
    try {
      await db.delete(NetwolfRequest.tableName);
      return const Result(null);
    } catch (e) {
      log(e.toString());
      return Result.error(NetwolfDbException(e.toString()));
    }
  }

  Future<Result<void, NetwolfException>> deleteRequestById(Id id) async {
    try {
      await db.delete(
        NetwolfRequest.tableName,
        where: '${NetwolfRequestDbObjectKeys.id.name} = ?',
        whereArgs: [id],
      );
      return const Result(null);
    } catch (e) {
      log(e.toString());
      return Result.error(NetwolfDbException(e.toString()));
    }
  }
}
