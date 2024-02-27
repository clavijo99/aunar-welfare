import 'package:aunar_welfar/const/host.dart';
import 'package:aunar_welfar/const/interceptor.dart';
import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

class SplashProvider extends ChangeNotifier {
  late final LocalStorageInterface localStorageInterface;
  late final UsuarioApi usuarioApi = UsuarioApi(
      Dio(BaseOptions(baseUrl: apiHost))
        ..interceptors.add(DioInterceptor(localStorage: localStorageInterface)),
      standardSerializers);

  SplashProvider({required this.localStorageInterface});

  Future<bool?> validate() async {
    try {
      final String? access = await localStorageInterface.getAccess();
      if (access != null) {
        final user = await usuarioApi.usersCurrentRetrieve();
        if (user.statusCode == 200) {
          return true;
        }
      }
      localStorageInterface.clean();
      return false;
    } on DioException catch (err) {
      print(err);
      localStorageInterface.clean();
      return null;
    }
  }
}
