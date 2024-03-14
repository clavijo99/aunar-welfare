import 'package:aunar_welfar/data/repository/local_storage_imp.dart';
import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:aunar_welfar/screens/login/login_screen.dart';
import 'package:aunar_welfar/screens/widgets/recover%20password/recover_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GenerateCode extends StatelessWidget {
  const GenerateCode._();

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecoverPasswordProvider(
          localStorageInterface:
              Provider.of<LocalStorageInterface>(context, listen: false)),
      builder: (context, child) => const GenerateCode._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<RecoverPasswordProvider>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFieldCustom(
            label: 'Correo',
            textInputType: TextInputType.emailAddress,
            controller: bloc.email,
          ),
          SizedBox(height: 40),
          ButtonCustom(
              text: 'Restablecer Contraseña',
              onTap: () {
                bloc.generateCode();
              })
        ],
      ),
    );
  }
}
