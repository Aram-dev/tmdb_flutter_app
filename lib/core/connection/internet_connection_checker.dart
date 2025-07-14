import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    bool hasConnection = await InternetConnectionChecker.createInstance().hasConnection;
    if (!hasConnection) {
      // You can throw a custom exception here
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: "No internet connection",
        ),
        true,
      );
      return;
    }
    return handler.next(options);
  }
}
