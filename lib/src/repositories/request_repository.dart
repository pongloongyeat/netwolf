import 'package:netwolf/src/core/exceptions.dart';
import 'package:netwolf/src/core/typedefs.dart';
import 'package:netwolf/src/models/netwolf_request.dart';
import 'package:netwolf/src/models/result.dart';
import 'package:sqflite/sqflite.dart';

abstract class _RequestRepository {
  const _RequestRepository(this.db);

  final Database db;

  Future<Result<List<NetwolfRequest>, Exception>> getRequests();

  Future<Result<NetwolfRequest, Exception>> getRequestById(Id id);

  Future<Result<NetwolfRequest, Exception>> addRequest(NetwolfRequest request);

  Future<Result<void, Exception>> deleteAllRequests();

  Future<Result<Id, Exception>> deleteRequestById(Id id);
}

final class RequestRepository extends _RequestRepository {
  RequestRepository(super.db);

  @override
  Future<Result<List<NetwolfRequest>, Exception>> getRequests() async {
    final query = await db.query(
      NetwolfRequest.tableName,
      columns: ['id', 'method', 'url', 'startTime'],
    );

    try {
      return Result(query.map(NetwolfRequest.fromDbObject).toList());
    } catch (_) {
      return Result.error(NetwolfDecodingException());
    }
  }

  @override
  Future<Result<NetwolfRequest, Exception>> getRequestById(Id id) async {
    final query = await db.query(
      NetwolfRequest.tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (query.isEmpty) return Result.error(NetwolfNotFoundException());

    try {
      return Result(NetwolfRequest.fromDbObject(query.first));
    } catch (_) {
      return Result.error(NetwolfDecodingException());
    }
  }

  @override
  Future<Result<NetwolfRequest, Exception>> addRequest(
    NetwolfRequest request,
  ) async {
    final id = await db.insert(NetwolfRequest.tableName, request.toDbObject());
    return Result(request.copyWith(id: id));
  }

  @override
  Future<Result<void, Exception>> deleteAllRequests() async {
    await db.delete(NetwolfRequest.tableName);
    return const Result(null);
  }

  @override
  Future<Result<Id, Exception>> deleteRequestById(Id id) async {
    final deletedId = await db.delete(
      NetwolfRequest.tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return Result(deletedId);
  }
}