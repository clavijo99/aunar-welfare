import 'package:aunar_welfar/const/host.dart';
import 'package:aunar_welfar/const/interceptor.dart';
import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

class ActivityProvider extends ChangeNotifier {
  ActivityProvider({required this.localStorageInterface});
  final LocalStorageInterface localStorageInterface;
  late final ActivitiesApi activitiesApi = ActivitiesApi(
      Dio(BaseOptions(baseUrl: apiHost))
        ..interceptors.add(DioInterceptor(localStorage: localStorageInterface)),
      standardSerializers);
  Activity? activity;

  String? type;

  void init() async {
    type = await localStorageInterface.getRol();
    notifyListeners();
  }

  Future<bool?> a() async {
    final int? userId = await localStorageInterface.getUserId();
    type = await localStorageInterface.getRol();
    try {
      final response = await activitiesApi.activitiesActivitiesAddStudentCreate(
        id: activity!.id,
        activityRegisterUserRequest: ActivityRegisterUserRequest(
          (b) {
            b.userId = userId;
          },
        ),
      );
      if (response.statusCode == 201) {
        return true;
      }
    } on DioException catch (err) {
      print(err);
    }
  }
}
