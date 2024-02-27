import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:openapi/src/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _userId = 'user';
const _access = 'access';
const _rol = 'rol';

class LocalStorageImp extends LocalStorageInterface {
  @override
  Future<String?> getAccess() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_access);
  }

  @override
  void setAccess(String access) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_access, access);
  }

  @override
  Future<int?> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(_userId);
  }

  @override
  void setUserId(int userId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt(_userId, userId);
  }

  @override
  Future<String?> getRol() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_rol);
  }

  @override
  void setRol(String rol) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_rol, rol);
  }
  
  @override
  Future clean() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.clear();
  }
}
