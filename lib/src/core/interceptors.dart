import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  const DioInterceptor();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Access-Control-Allow-Origin'] = '*';
    super.onRequest(options, handler);
  }
}
