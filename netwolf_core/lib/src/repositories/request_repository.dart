import 'dart:developer';

import 'package:netwolf_core/src/core/exceptions.dart';
import 'package:netwolf_core/src/core/typedefs.dart';
import 'package:netwolf_core/src/models/netwolf_request.dart';
import 'package:netwolf_core/src/models/result.dart';
import 'package:sqflite/sqflite.dart';

class RequestRepository {
  RequestRepository(this.db);

  final Database db;

  Future<Result<List<NetwolfRequest>, Exception>> getRequests() async {
    final query = await db.query(
      NetwolfRequest.tableName,
      columns: [
        'id',
        'method',
        'url',
        'start_time',
        'status_code',
        'end_time',
      ],
    );

    try {
      return Result(query.map(NetwolfRequest.fromDbObject).toList());
    } catch (e) {
      log(e.toString());
      return Result.error(NetwolfDecodingException());
    }
  }

  Future<Result<NetwolfRequest, Exception>> getRequestById(Id id) async {
    final query = await db.query(
      NetwolfRequest.tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (query.isEmpty) return Result.error(NetwolfRecordNotFoundException());

    try {
      return Result(NetwolfRequest.fromDbObject(query.first));
    } catch (e) {
      log(e.toString());
      return Result.error(NetwolfDecodingException());
    }
  }

  Future<Result<NetwolfRequest, Exception>> addRequest(
    NetwolfRequest request,
  ) async {
    final id = await db.insert(NetwolfRequest.tableName, request.toDbObject());
    return Result(request.copyWith(id: id));
  }

  Future<Result<NetwolfRequest, Exception>> updateRequest(
    Id id,
    NetwolfRequest request,
  ) async {
    try {
      await db.update(
        NetwolfRequest.tableName,
        request.toDbObject(),
        where: 'id = ?',
        whereArgs: [id],
      );
      return Result(request);
    } catch (e) {
      log(e.toString());
      return Result.error(NetwolfRecordNotFoundException());
    }
  }

  Future<Result<void, Exception>> deleteAllRequests() async {
    await db.delete(NetwolfRequest.tableName);
    return const Result(null);
  }

  Future<Result<void, Exception>> deleteRequestById(Id id) async {
    try {
      await db.delete(
        NetwolfRequest.tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      return const Result(null);
    } catch (e) {
      log(e.toString());
      return Result.error(NetwolfRecordNotFoundException());
    }
  }
}
