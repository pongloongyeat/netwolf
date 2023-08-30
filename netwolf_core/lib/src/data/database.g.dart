// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class NetwolfRequests extends Table
    with TableInfo<NetwolfRequests, NetwolfRequest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  NetwolfRequests(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
      'start_time', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _requestHeadersMeta =
      const VerificationMeta('requestHeaders');
  late final GeneratedColumn<String> requestHeaders = GeneratedColumn<String>(
      'request_headers', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _requestBodyMeta =
      const VerificationMeta('requestBody');
  late final GeneratedColumn<String> requestBody = GeneratedColumn<String>(
      'request_body', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _statusCodeMeta =
      const VerificationMeta('statusCode');
  late final GeneratedColumn<int> statusCode = GeneratedColumn<int>(
      'status_code', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
      'end_time', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _responseHeadersMeta =
      const VerificationMeta('responseHeaders');
  late final GeneratedColumn<String> responseHeaders = GeneratedColumn<String>(
      'response_headers', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _responseBodyMeta =
      const VerificationMeta('responseBody');
  late final GeneratedColumn<String> responseBody = GeneratedColumn<String>(
      'response_body', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        method,
        url,
        startTime,
        requestHeaders,
        requestBody,
        statusCode,
        endTime,
        responseHeaders,
        responseBody
      ];
  @override
  String get aliasedName => _alias ?? 'netwolf_requests';
  @override
  String get actualTableName => 'netwolf_requests';
  @override
  VerificationContext validateIntegrity(Insertable<NetwolfRequest> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('request_headers')) {
      context.handle(
          _requestHeadersMeta,
          requestHeaders.isAcceptableOrUnknown(
              data['request_headers']!, _requestHeadersMeta));
    }
    if (data.containsKey('request_body')) {
      context.handle(
          _requestBodyMeta,
          requestBody.isAcceptableOrUnknown(
              data['request_body']!, _requestBodyMeta));
    }
    if (data.containsKey('status_code')) {
      context.handle(
          _statusCodeMeta,
          statusCode.isAcceptableOrUnknown(
              data['status_code']!, _statusCodeMeta));
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    }
    if (data.containsKey('response_headers')) {
      context.handle(
          _responseHeadersMeta,
          responseHeaders.isAcceptableOrUnknown(
              data['response_headers']!, _responseHeadersMeta));
    }
    if (data.containsKey('response_body')) {
      context.handle(
          _responseBodyMeta,
          responseBody.isAcceptableOrUnknown(
              data['response_body']!, _responseBodyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NetwolfRequest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NetwolfRequest(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_time'])!,
      requestHeaders: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}request_headers']),
      requestBody: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}request_body']),
      statusCode: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status_code']),
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}end_time']),
      responseHeaders: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}response_headers']),
      responseBody: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}response_body']),
    );
  }

  @override
  NetwolfRequests createAlias(String alias) {
    return NetwolfRequests(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['PRIMARY KEY(id)'];
  @override
  bool get dontWriteConstraints => true;
}

class NetwolfRequest extends DataClass implements Insertable<NetwolfRequest> {
  final int id;
  final String method;
  final String url;
  final String startTime;
  final String? requestHeaders;
  final String? requestBody;
  final int? statusCode;
  final String? endTime;
  final String? responseHeaders;
  final String? responseBody;
  const NetwolfRequest(
      {required this.id,
      required this.method,
      required this.url,
      required this.startTime,
      this.requestHeaders,
      this.requestBody,
      this.statusCode,
      this.endTime,
      this.responseHeaders,
      this.responseBody});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['method'] = Variable<String>(method);
    map['url'] = Variable<String>(url);
    map['start_time'] = Variable<String>(startTime);
    if (!nullToAbsent || requestHeaders != null) {
      map['request_headers'] = Variable<String>(requestHeaders);
    }
    if (!nullToAbsent || requestBody != null) {
      map['request_body'] = Variable<String>(requestBody);
    }
    if (!nullToAbsent || statusCode != null) {
      map['status_code'] = Variable<int>(statusCode);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<String>(endTime);
    }
    if (!nullToAbsent || responseHeaders != null) {
      map['response_headers'] = Variable<String>(responseHeaders);
    }
    if (!nullToAbsent || responseBody != null) {
      map['response_body'] = Variable<String>(responseBody);
    }
    return map;
  }

  NetwolfRequestsCompanion toCompanion(bool nullToAbsent) {
    return NetwolfRequestsCompanion(
      id: Value(id),
      method: Value(method),
      url: Value(url),
      startTime: Value(startTime),
      requestHeaders: requestHeaders == null && nullToAbsent
          ? const Value.absent()
          : Value(requestHeaders),
      requestBody: requestBody == null && nullToAbsent
          ? const Value.absent()
          : Value(requestBody),
      statusCode: statusCode == null && nullToAbsent
          ? const Value.absent()
          : Value(statusCode),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      responseHeaders: responseHeaders == null && nullToAbsent
          ? const Value.absent()
          : Value(responseHeaders),
      responseBody: responseBody == null && nullToAbsent
          ? const Value.absent()
          : Value(responseBody),
    );
  }

  factory NetwolfRequest.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NetwolfRequest(
      id: serializer.fromJson<int>(json['id']),
      method: serializer.fromJson<String>(json['method']),
      url: serializer.fromJson<String>(json['url']),
      startTime: serializer.fromJson<String>(json['start_time']),
      requestHeaders: serializer.fromJson<String?>(json['request_headers']),
      requestBody: serializer.fromJson<String?>(json['request_body']),
      statusCode: serializer.fromJson<int?>(json['status_code']),
      endTime: serializer.fromJson<String?>(json['end_time']),
      responseHeaders: serializer.fromJson<String?>(json['response_headers']),
      responseBody: serializer.fromJson<String?>(json['response_body']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'method': serializer.toJson<String>(method),
      'url': serializer.toJson<String>(url),
      'start_time': serializer.toJson<String>(startTime),
      'request_headers': serializer.toJson<String?>(requestHeaders),
      'request_body': serializer.toJson<String?>(requestBody),
      'status_code': serializer.toJson<int?>(statusCode),
      'end_time': serializer.toJson<String?>(endTime),
      'response_headers': serializer.toJson<String?>(responseHeaders),
      'response_body': serializer.toJson<String?>(responseBody),
    };
  }

  NetwolfRequest copyWith(
          {int? id,
          String? method,
          String? url,
          String? startTime,
          Value<String?> requestHeaders = const Value.absent(),
          Value<String?> requestBody = const Value.absent(),
          Value<int?> statusCode = const Value.absent(),
          Value<String?> endTime = const Value.absent(),
          Value<String?> responseHeaders = const Value.absent(),
          Value<String?> responseBody = const Value.absent()}) =>
      NetwolfRequest(
        id: id ?? this.id,
        method: method ?? this.method,
        url: url ?? this.url,
        startTime: startTime ?? this.startTime,
        requestHeaders:
            requestHeaders.present ? requestHeaders.value : this.requestHeaders,
        requestBody: requestBody.present ? requestBody.value : this.requestBody,
        statusCode: statusCode.present ? statusCode.value : this.statusCode,
        endTime: endTime.present ? endTime.value : this.endTime,
        responseHeaders: responseHeaders.present
            ? responseHeaders.value
            : this.responseHeaders,
        responseBody:
            responseBody.present ? responseBody.value : this.responseBody,
      );
  @override
  String toString() {
    return (StringBuffer('NetwolfRequest(')
          ..write('id: $id, ')
          ..write('method: $method, ')
          ..write('url: $url, ')
          ..write('startTime: $startTime, ')
          ..write('requestHeaders: $requestHeaders, ')
          ..write('requestBody: $requestBody, ')
          ..write('statusCode: $statusCode, ')
          ..write('endTime: $endTime, ')
          ..write('responseHeaders: $responseHeaders, ')
          ..write('responseBody: $responseBody')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, method, url, startTime, requestHeaders,
      requestBody, statusCode, endTime, responseHeaders, responseBody);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NetwolfRequest &&
          other.id == this.id &&
          other.method == this.method &&
          other.url == this.url &&
          other.startTime == this.startTime &&
          other.requestHeaders == this.requestHeaders &&
          other.requestBody == this.requestBody &&
          other.statusCode == this.statusCode &&
          other.endTime == this.endTime &&
          other.responseHeaders == this.responseHeaders &&
          other.responseBody == this.responseBody);
}

class NetwolfRequestsCompanion extends UpdateCompanion<NetwolfRequest> {
  final Value<int> id;
  final Value<String> method;
  final Value<String> url;
  final Value<String> startTime;
  final Value<String?> requestHeaders;
  final Value<String?> requestBody;
  final Value<int?> statusCode;
  final Value<String?> endTime;
  final Value<String?> responseHeaders;
  final Value<String?> responseBody;
  const NetwolfRequestsCompanion({
    this.id = const Value.absent(),
    this.method = const Value.absent(),
    this.url = const Value.absent(),
    this.startTime = const Value.absent(),
    this.requestHeaders = const Value.absent(),
    this.requestBody = const Value.absent(),
    this.statusCode = const Value.absent(),
    this.endTime = const Value.absent(),
    this.responseHeaders = const Value.absent(),
    this.responseBody = const Value.absent(),
  });
  NetwolfRequestsCompanion.insert({
    this.id = const Value.absent(),
    required String method,
    required String url,
    required String startTime,
    this.requestHeaders = const Value.absent(),
    this.requestBody = const Value.absent(),
    this.statusCode = const Value.absent(),
    this.endTime = const Value.absent(),
    this.responseHeaders = const Value.absent(),
    this.responseBody = const Value.absent(),
  })  : method = Value(method),
        url = Value(url),
        startTime = Value(startTime);
  static Insertable<NetwolfRequest> custom({
    Expression<int>? id,
    Expression<String>? method,
    Expression<String>? url,
    Expression<String>? startTime,
    Expression<String>? requestHeaders,
    Expression<String>? requestBody,
    Expression<int>? statusCode,
    Expression<String>? endTime,
    Expression<String>? responseHeaders,
    Expression<String>? responseBody,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (method != null) 'method': method,
      if (url != null) 'url': url,
      if (startTime != null) 'start_time': startTime,
      if (requestHeaders != null) 'request_headers': requestHeaders,
      if (requestBody != null) 'request_body': requestBody,
      if (statusCode != null) 'status_code': statusCode,
      if (endTime != null) 'end_time': endTime,
      if (responseHeaders != null) 'response_headers': responseHeaders,
      if (responseBody != null) 'response_body': responseBody,
    });
  }

  NetwolfRequestsCompanion copyWith(
      {Value<int>? id,
      Value<String>? method,
      Value<String>? url,
      Value<String>? startTime,
      Value<String?>? requestHeaders,
      Value<String?>? requestBody,
      Value<int?>? statusCode,
      Value<String?>? endTime,
      Value<String?>? responseHeaders,
      Value<String?>? responseBody}) {
    return NetwolfRequestsCompanion(
      id: id ?? this.id,
      method: method ?? this.method,
      url: url ?? this.url,
      startTime: startTime ?? this.startTime,
      requestHeaders: requestHeaders ?? this.requestHeaders,
      requestBody: requestBody ?? this.requestBody,
      statusCode: statusCode ?? this.statusCode,
      endTime: endTime ?? this.endTime,
      responseHeaders: responseHeaders ?? this.responseHeaders,
      responseBody: responseBody ?? this.responseBody,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (requestHeaders.present) {
      map['request_headers'] = Variable<String>(requestHeaders.value);
    }
    if (requestBody.present) {
      map['request_body'] = Variable<String>(requestBody.value);
    }
    if (statusCode.present) {
      map['status_code'] = Variable<int>(statusCode.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (responseHeaders.present) {
      map['response_headers'] = Variable<String>(responseHeaders.value);
    }
    if (responseBody.present) {
      map['response_body'] = Variable<String>(responseBody.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NetwolfRequestsCompanion(')
          ..write('id: $id, ')
          ..write('method: $method, ')
          ..write('url: $url, ')
          ..write('startTime: $startTime, ')
          ..write('requestHeaders: $requestHeaders, ')
          ..write('requestBody: $requestBody, ')
          ..write('statusCode: $statusCode, ')
          ..write('endTime: $endTime, ')
          ..write('responseHeaders: $responseHeaders, ')
          ..write('responseBody: $responseBody')
          ..write(')'))
        .toString();
  }
}

abstract class _$NetwolfDatabase extends GeneratedDatabase {
  _$NetwolfDatabase(QueryExecutor e) : super(e);
  late final NetwolfRequests netwolfRequests = NetwolfRequests(this);
  Selectable<GetAllRequestsResult> getAllRequests() {
    return customSelect(
        'SELECT id, method, url, start_time, status_code, end_time FROM netwolf_requests',
        variables: [],
        readsFrom: {
          netwolfRequests,
        }).map((QueryRow row) => GetAllRequestsResult(
          id: row.read<int>('id'),
          method: row.read<String>('method'),
          url: row.read<String>('url'),
          startTime: row.read<String>('start_time'),
          statusCode: row.readNullable<int>('status_code'),
          endTime: row.readNullable<String>('end_time'),
        ));
  }

  Selectable<NetwolfRequest> getRequestById(int var1) {
    return customSelect('SELECT * FROM netwolf_requests WHERE id = ?1 LIMIT 1',
        variables: [
          Variable<int>(var1)
        ],
        readsFrom: {
          netwolfRequests,
        }).asyncMap(netwolfRequests.mapFromRow);
  }

  Future<int> insertRequest(
      String var1, String var2, String var3, String? var4, String? var5) {
    return customInsert(
      'INSERT INTO netwolf_requests (method, url, start_time, request_headers, request_body) VALUES (?1, ?2, ?3, ?4, ?5)',
      variables: [
        Variable<String>(var1),
        Variable<String>(var2),
        Variable<String>(var3),
        Variable<String>(var4),
        Variable<String>(var5)
      ],
      updates: {netwolfRequests},
    );
  }

  Future<int> completeRequest(
      int? var1, String? var2, String? var3, String? var4, int var5) {
    return customUpdate(
      'UPDATE netwolf_requests SET status_code = ?1, end_time = ?2, response_headers = ?3, response_body = ?4 WHERE id = ?5',
      variables: [
        Variable<int>(var1),
        Variable<String>(var2),
        Variable<String>(var3),
        Variable<String>(var4),
        Variable<int>(var5)
      ],
      updates: {netwolfRequests},
      updateKind: UpdateKind.update,
    );
  }

  Future<int> deleteRequestById(int var1) {
    return customUpdate(
      'DELETE FROM netwolf_requests WHERE id = ?1',
      variables: [Variable<int>(var1)],
      updates: {netwolfRequests},
      updateKind: UpdateKind.delete,
    );
  }

  Future<int> deleteAllRequests() {
    return customUpdate(
      'DELETE FROM netwolf_requests',
      variables: [],
      updates: {netwolfRequests},
      updateKind: UpdateKind.delete,
    );
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [netwolfRequests];
}

class GetAllRequestsResult {
  final int id;
  final String method;
  final String url;
  final String startTime;
  final int? statusCode;
  final String? endTime;
  GetAllRequestsResult({
    required this.id,
    required this.method,
    required this.url,
    required this.startTime,
    this.statusCode,
    this.endTime,
  });
}
