import 'dart:convert';

import 'package:aunar_welfar/const/host.dart';
import 'package:aunar_welfar/const/interceptor.dart';
import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:openapi/openapi.dart';
import 'package:http/http.dart' as http;

class MyActivitiesProvider extends ChangeNotifier {
  MyActivitiesProvider({required this.localStorageInterface});
  final LocalStorageInterface localStorageInterface;
  late final ActivitiesApi activitiesApi = ActivitiesApi(
      Dio(BaseOptions(baseUrl: apiHost))
        ..interceptors.add(DioInterceptor(localStorage: localStorageInterface)),
      standardSerializers);
  List<Activity>? activities;
  String? type;
  int? ActivityId;

  Future init() async {
    try {
      final user = await localStorageInterface.getUserId();
      type = await localStorageInterface.getRol();
      final response = type == 'STUDENT'
          ? await activitiesApi.activitiesActivitiesGetMyActivitiesCreate(
              activityRegisterUserRequest: ActivityRegisterUserRequest(
              (b) {
                b.userId = user!;
              },
            ))
          : await activitiesApi
              .activitiesActivitiesGetMyActivitiesTeacherCreate(
                  activityRegisterUserRequest: ActivityRegisterUserRequest(
              (b) {
                b.userId = user!;
              },
            ));
      if (response.statusCode == 200) {
        print(response);
        activities = response.data!.toList();
        notifyListeners();
      }
    } on DioException catch (err) {
      print(err);
    }
  }

  Future<bool> isWithinRange(List<int> timeToValidate, int minutesRange) async {
    final hour = await getHour();
    int minutesToValidate = timeToValidate[0] * 60 + timeToValidate[1];
    int minutesReference = hour[0] * 60 + hour[1];

    int allowedMinutesRange = minutesRange ~/ 2;

    return (minutesToValidate >= minutesReference - allowedMinutesRange) &&
        (minutesToValidate <= minutesReference + allowedMinutesRange);
  }

  Future<List<int>> getHour() async {
    final a = await getDate();
    final hour = a.split('T')[1].split('.')[0].split(':');
    return [int.parse(hour[0]), int.parse(hour[1])];
  }

  Future<String?> enter(Activity activity) async {
    final user = await localStorageInterface.getUserId();

    try {
      final response =
          await activitiesApi.activitiesActivitiesAddStudentParticipateCreate(
              id: activity.id,
              activityRegisterUserRequest: ActivityRegisterUserRequest(
                (b) {
                  b.userId = user;
                },
              ));
      if (response.statusCode == 201) {
        if (response.data!.dateEnd == null) {
          return 'Has ingresado a la actividad!';
        } else {
          activities!.remove(activity);
          notifyListeners();
          return 'Actividad terminada gracias por participar!!';
        }
      }
      return 'Ups, algo salio mal vuelve a intentar';
    } on DioException catch (_) {
      print(_);
    }
  }

  Future<String> getDate() async {
    final response =
        await http.get(Uri.parse('http://worldtimeapi.org/api/ip'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String hora = data['datetime'];
      return hora;
    } else {
      throw Exception('No se pudo obtener la hora desde Internet');
    }
  }
}
