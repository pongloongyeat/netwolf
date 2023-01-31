import 'package:dio/dio.dart';
import 'package:netwolf/netwolf.dart';

class NetwolfDioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);

    NetwolfController.instance.addRequest(
      options.hashCode,
      method: HttpRequestMethod.tryParse(options.method),
      url: options.uri.toString(),
      requestHeaders: options.headers,
      requestBody: options.data,
    );
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    super.onResponse(response, handler);

    NetwolfController.instance.addResponse(
      response.requestOptions.hashCode,
      responseCode: response.statusCode,
      responseHeaders: response.headers.map,
      responseBody: response.data,
      method: null,
      url: null,
      requestHeaders: null,
      requestBody: null,
    );
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);

    NetwolfController.instance.addResponse(
      err.requestOptions.hashCode,
      responseCode: err.response?.statusCode,
      responseHeaders: err.response?.headers.map,
      responseBody: err.response?.data,
      method: null,
      url: null,
      requestHeaders: null,
      requestBody: null,
    );
  }
}
