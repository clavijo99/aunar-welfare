import 'package:aunar_welfar/const/colors.dart';
import 'package:aunar_welfar/const/navigation.dart';
import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:aunar_welfar/screens/login/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen._();

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginProvider(
          localStorageInterface:
              Provider.of<LocalStorageInterface>(context, listen: false)),
      builder: (context, child) => const LoginScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bloc = Provider.of<LoginProvider>(context);

    void login() async {
      final result = await bloc.login();
      if (result != null) {
        if (result) {
          pushReplacement(context, 'layout', null);
        } else {
          final snackBar = SnackBar(
            content: Text(bloc.error ?? 'error'),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: size.width * 0.7,
              ),
              TextFieldCustom(
                label: 'Usuario',
                controller: bloc.email,
              ),
              TextFieldCustom(
                label: 'Contraseña',
                hinText: '********',
                controller: bloc.password,
              ),
              SizedBox(height: 50),
              ButtonCustom(
                text: 'Ingresar',
                onTap: login,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: size.width),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            height: 60,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldCustom extends StatelessWidget {
  const TextFieldCustom({
    super.key,
    required this.label,
    this.hinText,
    this.controller,
  });
  final String label;
  final String? hinText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hinText,
          label: Text(label),
        ),
        cursorColor: primaryColor,
        controller: controller,
      ),
    );
  }
}
