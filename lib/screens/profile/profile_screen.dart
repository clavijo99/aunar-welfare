import 'package:aunar_welfar/const/colors.dart';
import 'package:aunar_welfar/const/host.dart';
import 'package:aunar_welfar/const/navigation.dart';
import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:aunar_welfar/screens/login/login_screen.dart';
import 'package:aunar_welfar/screens/profile/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen._();

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileProvider(
        localStorageInterface:
            Provider.of<LocalStorageInterface>(context, listen: false),
      )..init(),
      builder: (context, child) => const ProfileScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ProfileProvider>(context);
    var textStyle = TextStyle(color: Colors.white);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mi perfil',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: bloc.user != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: ClipOval(
                          child: Image.network(
                            bloc.user!.avatar.contains('https')
                                ? bloc.user!.avatar
                                : '${apiHost}${bloc.user!.avatar}',
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.not_interested_rounded),
                            fit: BoxFit.contain,
                          ),
                        )),
                        Positioned(
                            bottom: 1,
                            right: 3,
                            child: Icon(
                              Icons.camera_alt_rounded,
                              color: primaryColor,
                              size: 40,
                            ))
                      ],
                    ),
                  ),
                  if (bloc.user!.type!.name == 'STUDENT')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(bloc.points.toString()),
                              SizedBox(width: 10),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: bloc.getProgress().toDouble() / 100,
                                  minHeight: 10,
                                  color: primaryColor,
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text('${bloc.getProgress()}%')
                            ],
                          ),
                          if(bloc.points == 40)
                          Text('Has completado el 100% de puntos' , style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(),
                            Text(
                              'Nombre: ${bloc.user!.firstName ?? ''} ${bloc.user!.lastName ?? ''}',
                              style: textStyle,
                            ),
                            Divider(),
                            Text(
                              'Correo: ${bloc.user!.email}',
                              style: textStyle,
                            ),
                            if (bloc.user!.type!.name == 'STUDENT') Divider(),
                            if (bloc.user!.type!.name == 'STUDENT')
                              Text(
                                'Carrera: Ingenieria informatica',
                                style: textStyle,
                              ),
                            if (bloc.user!.type!.name == 'STUDENT') Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ButtonCustom(
                    text: 'Cerrar sesion',
                    onTap: () async {
                      await Provider.of<LocalStorageInterface>(context,
                              listen: false)
                          .clean();
                      pushReplacement(context, 'login', null);
                    },
                  )
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
