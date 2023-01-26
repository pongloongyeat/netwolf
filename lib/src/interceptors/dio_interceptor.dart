import 'package:dio/dio.dart';
import 'package:netwolf/src/enums.dart';
import 'package:netwolf/src/netwolf_controller.dart';
import 'package:netwolf/src/netwolf_response.dart';

class NetwolfDioInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);

    NetwolfController.instance.addResponse(
      NetwolfResponse(
        method: HttpRequestMethod.tryParse(err.requestOptions.method),
        responseCode: err.response?.statusCode,
        url: err.requestOptions.uri.toString(),
        requestHeaders: err.requestOptions.headers,
        requestBody: err.requestOptions.data,
        responseHeaders: err.response?.headers.map,
        responseBody: err.response?.data,
      ),
    );
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    super.onResponse(response, handler);

    NetwolfController.instance.addResponse(
      NetwolfResponse(
        method: HttpRequestMethod.tryParse(response.requestOptions.method),
        responseCode: response.statusCode,
        url: response.requestOptions.uri.toString(),
        requestHeaders: response.requestOptions.headers,
        requestBody: response.requestOptions.data,
        responseHeaders: response.headers.map,
        responseBody: response.data,
      ),
    );
  }
}
