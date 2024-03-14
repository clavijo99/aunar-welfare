import 'dart:io';

import 'package:aunar_welfar/const/colors.dart';
import 'package:aunar_welfar/const/host.dart';
import 'package:aunar_welfar/const/navigation.dart';
import 'package:aunar_welfar/const/utils.dart';
import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:aunar_welfar/screens/login/login_screen.dart';
import 'package:aunar_welfar/screens/profile/profile_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
            ? Stack(
                children: [
                  Positioned.fill(
                    child: Column(
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
                                child: (bloc.image != null)
                                    ? Image.file(
                                        File(bloc.image!),
                                        fit: BoxFit.cover,
                                        width: (size.width * 0.65) * 0.5,
                                        height: (size.width * 0.65) * 0.5,
                                        alignment: Alignment.center,
                                      )
                                    : (bloc.user!.avatar != '')
                                        ? CachedNetworkImage(
                                            imageUrl: bloc.user!.avatar
                                                    .contains('https')
                                                ? bloc.user!.avatar
                                                : '${apiHost}${bloc.user!.avatar}',
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                CircularProgressIndicator(
                                                    value: downloadProgress
                                                        .progress),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            alignment: Alignment.center,
                                            fit: BoxFit.cover,
                                            width: (size.width * 0.65) * 0.5,
                                            height: (size.width * 0.65) * 0.5,
                                          )
                                        : Image.asset(
                                            "assets/images/avatar.png",
                                            fit: BoxFit.cover,
                                            width: (size.width * 0.65) * 0.5,
                                            height: (size.width * 0.65) * 0.5,
                                            alignment: Alignment.center,
                                          ),
                              )),
                              Positioned(
                                  bottom: 1,
                                  right: 3,
                                  child: GestureDetector(
                                    onTap: () => bloc.setShowCaptureImage(),
                                    child: Icon(
                                      bloc.getShowCaptureImage()
                                          ? Icons.close
                                          : Icons.camera_alt,
                                      color: primaryColor,
                                      size: 40,
                                    ),
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
                                        value:
                                            bloc.getProgress().toDouble() / 100,
                                        minHeight: 10,
                                        color: primaryColor,
                                        backgroundColor: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text('${bloc.getProgress()}%')
                                  ],
                                ),
                                if (bloc.points == 40)
                                  Text(
                                    'Has completado el 100% de puntos',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  )
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
                                  if (bloc.user!.type!.name == 'STUDENT')
                                    Divider(),
                                  if (bloc.user!.type!.name == 'STUDENT')
                                    Divider(),
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
                    ),
                  ),
                  if (bloc.getShowCaptureImage())
                    Positioned(
                      left: 0,
                      right: 0,
                      height: 70,
                      bottom: 0,
                      child: Container(
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(0, -1),
                            blurRadius: 5,
                            spreadRadius: 0.6,
                          )
                        ]),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    var pickerFile = await ImagePicker()
                                        .pickImage(
                                            source: ImageSource.camera,
                                            imageQuality: 50);
                                    if (pickerFile != null) {
                                      bloc.addImage(
                                        pickerFile.path,
                                      );
                                    }
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        color: primaryColor,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Abrir cámara',
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ],
                                  )),
                              GestureDetector(
                                  onTap: () async {
                                    var pickerFile = await ImagePicker()
                                        .pickImage(
                                            source: ImageSource.gallery,
                                            imageQuality: 50);
                                    if (pickerFile != null) {
                                      bloc.addImage(
                                        pickerFile.path,
                                      );
                                    }
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.image,
                                        color: primaryColor,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Abrir galería',
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (bloc.state == StateLoading.loading)
                    Positioned.fill(
                        child: Container(
                      color: primaryColor.withOpacity(0),
                    )),
                  if (bloc.state == StateLoading.loading)
                    Positioned(
                        bottom: 10,
                        left: size.width / 2 - 30,
                        child: Center(child: CircularProgressIndicator()))
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
