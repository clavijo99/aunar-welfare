import 'package:openapi/openapi.dart';

abstract class LocalStorageInterface{
  void setAccess(String access);
  Future<String?> getAccess();
    void setUserId(int userId);
  Future<int?> getUserId();
  void setRol(String rol);
  Future<String?> getRol();
  Future clean();

}