import 'package:aunar_welfar/const/host.dart';
import 'package:aunar_welfar/const/interceptor.dart';
import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

class ActivitiesProvider extends ChangeNotifier{
  ActivitiesProvider({required this.localStorageInterface});
   final LocalStorageInterface localStorageInterface;
  late final ActivitiesApi activitiesApi = ActivitiesApi(
      Dio(BaseOptions(baseUrl: apiHost))
        ..interceptors.add(DioInterceptor(localStorage: localStorageInterface)),
      standardSerializers);

  int _categorySelect = 0;
  List<Activity>? activities;



  Future init() async {
    try{
      final response = await activitiesApi.activitiesActivitiesList();
      if(response.statusCode == 200){
        print(response);
        activities = response.data!.toList();
        notifyListeners();
      }
    } on DioException catch(err){
      print(err);
    }
  }

  void removeActivity(Activity value){
    activities!.remove(value);
    notifyListeners();
  }



  void setCategorySelect(int value){
    _categorySelect = value;
    notifyListeners();
  }

  int getCategorySelect() => _categorySelect;
}