import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:netwolf/netwolf.dart';

String _formatBody(dynamic body) {
  try {
    return jsonEncode(body);
  } catch (_) {
    return body.toString();
  }
}

extension on RequestOptions {
  static const _extraHeaderKey = 'Netwolf-RequestId';

  NetwolfRequest toNetwolfRequest(DateTime startTime) {
    return NetwolfRequest.uri(
      method: HttpRequestMethod.parse(method),
      uri: uri,
      startTime: startTime,
      requestHeaders: headers,
      requestBody: _formatBody(data),
    );
  }

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
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final startTime = DateTime.now();
    final request = options.toNetwolfRequest(startTime);
    NetwolfController.instance.addRequest(request).then((result) {
      final requestId = result.data?.id;
      if (requestId != null) options.insertRequestId(requestId);
      super.onRequest(options, handler);
    });
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final requestId = response.requestOptions.requestId;

    if (requestId != null) {
      NetwolfController.instance.completeRequest(
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
      NetwolfController.instance.completeRequest(
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
