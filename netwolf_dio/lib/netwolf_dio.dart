import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:netwolf_core/netwolf_core.dart';

String _formatBody(dynamic body) {
  try {
    return jsonEncode(body);
  } catch (_) {
    return body.toString();
  }
}

extension on RequestOptions {
  static const _extraHeaderKey = 'Netwolf-RequestId';

  void insertRequestId(Id id) {
    extra.addAll({_extraHeaderKey: id});
  }

  Id? get requestId {
    final id = extra[_extraHeaderKey];
    if (id is Id) return id;
    return null;
  }
}

class NetwolfDioInterceptor extends Interceptor {
  const NetwolfDioInterceptor(this.controller);

  final BaseNetwolfController controller;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final startTime = DateTime.now();
    final result = await controller.addRequest(
      method: HttpRequestMethod.parse(options.method),
      uri: options.uri,
      startTime: startTime,
      requestHeaders: options.headers,
      requestBody: _formatBody(options.data),
    );
    final requestId = result.data;
    if (requestId != null) options.insertRequestId(requestId);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final requestId = response.requestOptions.requestId;

    if (requestId != null) {
      controller.completeRequest(
        requestId,
        statusCode: response.statusCode,
        endTime: DateTime.now(),
        responseHeaders: response.headers.map,
        responseBody: _formatBody(response.data),
      );
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final requestId = err.requestOptions.requestId;

    if (requestId != null) {
      controller.completeRequest(
        requestId,
        statusCode: err.response?.statusCode,
        endTime: DateTime.now(),
        responseHeaders: err.response?.headers.map,
        responseBody: err.response?.data?.toString(),
      );
    }

    super.onError(err, handler);
  }
}
