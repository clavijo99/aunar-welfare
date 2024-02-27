import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  DioInterceptor({required this.localStorage});

  final LocalStorageInterface localStorage;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final String? access = await localStorage.getAccess();
    if (access != null) {
      options.headers['Authorization'] = 'Bearer $access';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    handler.next(err);
  }
}