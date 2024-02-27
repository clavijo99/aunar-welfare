import 'package:aunar_welfar/const/colors.dart';
import 'package:aunar_welfar/const/navigation.dart';
import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:aunar_welfar/screens/my%20activities/my_activities_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyActivitiesScreen extends StatelessWidget {
  const MyActivitiesScreen._();

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyActivitiesProvider(
          localStorageInterface:
              Provider.of<LocalStorageInterface>(context, listen: false))
        ..init(),
      builder: (context, child) => const MyActivitiesScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bloc = Provider.of<MyActivitiesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mis Actividades',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: bloc.activities != null
          ? bloc.activities!.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    final activity = bloc.activities![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              '12 - 02 - 2023',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: size.width,
                            height: 60,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                    color: primaryColor.withOpacity(0.5),
                                    offset: Offset(2, 0),
                                    spreadRadius: 2,
                                    blurRadius: 2)
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        activity.title,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                          width: size.width * 0.6,
                                          child: Text(
                                            activity.description,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (bloc.type == 'STUDENT') {
                                      final activityId = await push(
                                          context, 'qr-scanner', null);
                                      if (activityId != null) {
                                        bloc.ActivityId = activityId as int;
                                        final result =
                                            await bloc.enter(activity);
                                        if (result != null) {
                                          final snackBar = SnackBar(
                                            content: Text(result),
                                            backgroundColor: Colors.green,
                                          );
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                        }
                                      }
                                    } else {
                                      push(
                                          context, 'activity-detail', activity);
                                    }
                                  },
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        bottomLeft: Radius.circular(25),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Ingresar',
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 10),
                                          Icon(
                                            Icons.qr_code,
                                            color: primaryColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: bloc.activities!.length,
                )
              : Center(
                  child: Text('No hay actividades disponibles'),
                )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
