import 'package:aunar_welfar/const/host.dart';
import 'package:aunar_welfar/const/interceptor.dart';
import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

class RecoverPasswordProvider extends ChangeNotifier {
  final LocalStorageInterface localStorageInterface;

  late final RecoverPasswordApi recoverPasswordApi = RecoverPasswordApi(
      Dio(BaseOptions(baseUrl: apiHost))
        ..interceptors.add(DioInterceptor(localStorage: localStorageInterface)),
      standardSerializers);

  RecoverPasswordProvider({required this.localStorageInterface});

  TextEditingController email = TextEditingController();

  Future<bool?> generateCode() async {
    try {
      final response = await recoverPasswordApi
          .usersGenerateCodeRecoverPasswordCreate(
              resetPasswordRequestRequest: ResetPasswordRequestRequest(
        (b) {
          b.email = email.text;
        },
      ));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (_) {
      print(_);
    }
  }
}
