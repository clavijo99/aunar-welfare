import 'package:aunar_welfar/const/colors.dart';
import 'package:aunar_welfar/data/repository/local_storage_imp.dart';
import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:aunar_welfar/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LocalStorageInterface>(
          create: (context) => LocalStorageImp(),
        )
      ],
      builder: (context, child) => MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: routes(context),
      ),
    );
  }
}
