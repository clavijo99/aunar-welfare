import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:aunar_welfar/screens/activities/activities_screen.dart';
import 'package:aunar_welfar/screens/my%20activities/my_activities_screen.dart';
import 'package:flutter/material.dart';

class LayoutProvider extends ChangeNotifier{

final LocalStorageInterface localStorageInterface;
  String? type;
  int _page = 0;

  LayoutProvider({required this.localStorageInterface}  );

void init()async {
  type = await localStorageInterface.getRol();
  notifyListeners();
}

  void setPage(int page){
    _page = page;
    notifyListeners();
  }

  int getPage() => _page;

}