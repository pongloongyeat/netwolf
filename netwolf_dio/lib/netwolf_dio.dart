import 'package:dio/dio.dart';
import 'package:netwolf/netwolf.dart';

extension on RequestOptions {
  static const _extraHeaderKey = 'Netwolf-StartTime';

  NetwolfRequest toNetwolfRequest(DateTime startTime) {
    return NetwolfRequest.uri(
      method: HttpRequestMethod.parse(method),
      uri: uri,
      startTime: startTime,
      requestHeaders: headers,
      requestBody: data?.toString(),
    );
  }

  void insertRequestStartTime(DateTime startTime) {
    extra.addAll({_extraHeaderKey: startTime});
  }

  DateTime? get requestStartTime {
    final dateString = extra[_extraHeaderKey];
    if (dateString is! DateTime) return null;
    return dateString;
  }
}

class NetwolfDioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final startTime = DateTime.now();
    NetwolfController.instance.addRequest(
      options.toNetwolfRequest(startTime),
    );
    options.insertRequestStartTime(startTime);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final startTime = response.requestOptions.requestStartTime;

    if (startTime != null) {
      final request = response.requestOptions.toNetwolfRequest(startTime);
      NetwolfController.instance.completeRequest(
        request,
        statusCode: response.statusCode,
        endTime: DateTime.now(),
        responseHeaders: response.headers.map,
        responseBody: response.data?.toString(),
      );
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = err.requestOptions.requestStartTime;

    if (startTime != null) {
      final request = err.requestOptions.toNetwolfRequest(startTime);
      NetwolfController.instance.completeRequest(
        request,
        statusCode: err.response?.statusCode,
        endTime: DateTime.now(),
        responseHeaders: err.response?.headers.map,
        responseBody: err.response?.data?.toString(),
      );
    }

    super.onError(err, handler);
  }
}
