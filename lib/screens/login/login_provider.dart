import 'package:aunar_welfar/const/host.dart';
import 'package:aunar_welfar/const/interceptor.dart';
import 'package:aunar_welfar/const/utils.dart';
import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

class LoginProvider extends ChangeNotifier {
  final LocalStorageInterface localStorageInterface;

  late final AuthenticationApi authenticationApi = AuthenticationApi(
      Dio(BaseOptions(baseUrl: apiHost))
        ..interceptors.add(DioInterceptor(localStorage: localStorageInterface)),
      standardSerializers);

  late final UsuarioApi usuarioApi = UsuarioApi(
      Dio(BaseOptions(baseUrl: apiHost))
        ..interceptors.add(DioInterceptor(localStorage: localStorageInterface)),
      standardSerializers);

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  LoginProvider({required this.localStorageInterface});

  StateLoading state = StateLoading.initial;

  String? error;

  Future<bool?> login() async {
    state = StateLoading.loading;
    notifyListeners();
    try {
      final login = await authenticationApi.usersLoginCreate(
          customTokenObtainPairRequest: CustomTokenObtainPairRequest(
        (b) {
          b.email = email.text;
          b.password = password.text;
        },
      ));
      if (login.statusCode == 200) {
        localStorageInterface.setAccess(login.data!.access);
        final user = await usuarioApi.usersCurrentRetrieve();
        if (user.statusCode == 200) {
          state = StateLoading.initial;
          notifyListeners();
          localStorageInterface.setUserId(user.data!.id);
          localStorageInterface.setRol(user.data!.type!.name);
          return true;
        }
      }
      return false;
    } on DioException catch (_) {
      state = StateLoading.initial;
      notifyListeners();
      error = _.response!.data['error'] ?? 'Credenciales incorrectas';
    }
  }
}
