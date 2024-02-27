String get apiHost {
  bool idProd = const bool.fromEnvironment("dart.vm.product");
  if (idProd) {
    return "https://aunar-welfare.mi-server.cloud";
  }
  return "https://aunar-welfare.mi-server.cloud";
}
