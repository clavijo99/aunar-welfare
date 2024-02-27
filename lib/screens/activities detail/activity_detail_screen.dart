import 'package:aunar_welfar/const/colors.dart';
import 'package:aunar_welfar/const/host.dart';
import 'package:aunar_welfar/const/utils.dart';
import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:aunar_welfar/screens/activities%20detail/activities_provider.dart';
import 'package:aunar_welfar/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';

class ActivityDetailScreen extends StatelessWidget {
  const ActivityDetailScreen._();

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ActivityProvider(
        localStorageInterface:
            Provider.of<LocalStorageInterface>(context, listen: false),
      )..init(),
      builder: (context, child) => const ActivityDetailScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bloc = Provider.of<ActivityProvider>(context);
    final activity = ModalRoute.of(context)!.settings.arguments as Activity;
    bloc.activity = activity;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                SizedBox(
                  child: Image.network(
                    bloc.type != 'TEACHER'
                        ? activity.image!.contains('http')
                            ? activity.image!
                            : '${apiHost}${activity.image}'
                        : activity.qrCode!.contains('http')
                            ? activity.qrCode!
                            : '${apiHost}${activity.qrCode}',
                    height: size.height * 0.4,
                    width: size.width,
                    fit: BoxFit.contain,
                  ),
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(activity.description, overflow: TextOverflow.ellipsis,),
                              Text(activity.startDate.toString()),
                              Text( getHour(activity.hour.name) ),
                              Text(activity.site),
                            ],
                          ),
                        ),
                        SizedBox(width: 70),
                        if( bloc.type == 'TEACHER' && activity.image != null)
                        Expanded(
                          child: Image.network(
                            activity.image!.contains('http')
                                ? activity.image!
                                : '${apiHost}${activity.image}',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    if (bloc.type != 'TEACHER')
                      ButtonCustom(
                        text: 'Inscribirme',
                        onTap: () async {
                          final a = await bloc.a();
                          if (a != null && a) {
                            const snackBar = SnackBar(
                              content: Text('Te has inscrito!!'),
                              backgroundColor: Colors.green,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Future.delayed(const Duration(milliseconds: 3000),
                                () {
                              Navigator.of(context).pop(activity);
                            });
                          }
                        },
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
