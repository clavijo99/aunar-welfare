import 'package:aunar_welfar/const/host.dart';
import 'package:aunar_welfar/const/interceptor.dart';
import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

class ProfileProvider extends ChangeNotifier{
  ProfileProvider({required this.localStorageInterface});
     final LocalStorageInterface localStorageInterface;
  late final UsuarioApi usuarioApi = UsuarioApi(
      Dio(BaseOptions(baseUrl: apiHost))
        ..interceptors.add(DioInterceptor(localStorage: localStorageInterface)),
      standardSerializers);

        late final ActivitiesApi activitiesApi = ActivitiesApi(
      Dio(BaseOptions(baseUrl: apiHost))
        ..interceptors.add(DioInterceptor(localStorage: localStorageInterface)),
      standardSerializers);
      UserModel? user;
      int points = 0;

      void init() async {
        final int? userId = await localStorageInterface.getUserId();
        try{
          final response  = await usuarioApi.usersCurrentRetrieve();
          final pointresponse = await activitiesApi.activitiesActivitiesGetPointsCreate(activityRegisterUserRequest: ActivityRegisterUserRequest(
            (b) {
              b.userId = userId;
            },
          ));
          if(pointresponse.statusCode == 200){
            points = pointresponse.data!.points;
          }
          if(response.statusCode == 200){
            user = response.data;
            notifyListeners();
          }
        }on DioException catch(err){
          print(err);
        }
      }

      int getProgress(){
        return ( points * 100 /40 ).toInt();
      }

}