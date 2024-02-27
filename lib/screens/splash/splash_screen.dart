import 'package:aunar_welfar/const/colors.dart';
import 'package:aunar_welfar/const/navigation.dart';
import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:aunar_welfar/screens/splash/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen._();

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplashProvider(
          localStorageInterface:
              Provider.of<LocalStorageInterface>(context, listen: false)),
      builder: (context, child) => SplashScreen._(),
    );
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    validate();
    super.initState();
  }

  void validate() async {
    final bloc = Provider.of<SplashProvider>(context, listen: false);
    final result = await bloc.validate();
    if (result != null && result) {
      pushReplacement(context, 'layout', null);
    } else {
      pushReplacement(context, 'login', null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Positioned(
              left: 30,
              top: size.height / 2 - 50,
              right: 30,
              child: Image.asset(
                'assets/images/logo.png',
                height: 100,
              ),
            ),
            Positioned(
              left: size.width / 2 - 15,
              bottom: 50,
              child: const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
