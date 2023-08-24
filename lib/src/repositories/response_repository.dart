import 'package:netwolf/src/core/exceptions.dart';
import 'package:netwolf/src/core/typedefs.dart';
import 'package:netwolf/src/models/netwolf_request.dart';
import 'package:netwolf/src/models/netwolf_response.dart';
import 'package:netwolf/src/models/result.dart';
import 'package:sqflite/sqflite.dart';

abstract class _ResponseRepository {
  const _ResponseRepository(this.db);

  final Database db;

  Future<Result<List<NetwolfResponse>, Exception>> getResponses();

  Future<Result<NetwolfResponse, Exception>> getResponseById(Id id);

  Future<Result<NetwolfResponse, Exception>> addResponse(
    NetwolfResponse response,
  );
}

final class ResponseRepository extends _ResponseRepository {
  ResponseRepository(super.db);

  @override
  Future<Result<List<NetwolfResponse>, Exception>> getResponses() async {
    final query = await db.rawQuery('''
SELECT  req.id as request_id,
        req.method as request_method,
        req.url as request_url,
        req.start_time as start_time,
        res.id as response_id,
        res.status_code as status_code,
        res.end_time as end_time
FROM ${NetwolfResponse.tableName} as res
JOIN ${NetwolfRequest.tableName} as req
ON req.id = res.id
''');

    try {
      return Result(query.map(NetwolfResponse.fromDbObject).toList());
    } catch (_) {
      return Result.error(NetwolfDecodingException());
    }
  }

  @override
  Future<Result<NetwolfResponse, Exception>> getResponseById(Id id) async {
    final query = await db.rawQuery('''
SELECT  req.id as request_id,
        req.method as request_method,
        req.url as request_url,
        req.start_time as start_time,
        req.headers as request_headers,
        req.body as request_body,
        res.id as response_id,
        res.status_code as status_code,
        res.end_time as end_time,
        res.headers as resposne_headers,
        res.body as response_body
FROM ${NetwolfResponse.tableName} as res
JOIN ${NetwolfRequest.tableName} as req
ON req.id = res.id
WHERE request_id = id
''');

    if (query.isEmpty) return Result.error(NetwolfNotFoundException());

    try {
      return Result(NetwolfResponse.fromDbObject(query.first));
    } catch (_) {
      return Result.error(NetwolfDecodingException());
    }
  }

  @override
  Future<Result<NetwolfResponse, Exception>> addResponse(
    NetwolfResponse response,
  ) async {
    final id = await db.insert(NetwolfResponse.tableName, response.toMap());
    return Result(response.copyWith(id: id));
  }
}
