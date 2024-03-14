import 'package:aunar_welfar/const/colors.dart';
import 'package:aunar_welfar/const/navigation.dart';
import 'package:aunar_welfar/const/utils.dart';
import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:aunar_welfar/screens/activities/activities_provider.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen._();

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ActivitiesProvider(
          localStorageInterface:
              Provider.of<LocalStorageInterface>(context, listen: false))
        ..init(),
      builder: (context, child) => const ActivitiesScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ActivitiesProvider>(context);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Actividades',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: bloc.activities != null
            ? bloc.activities!.isNotEmpty
                ? SizedBox(
                    width: size.width,
                    height: size.height,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final activity = bloc.activities![index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Container(
                            width: size.width,
                            height: 320,
                            decoration:
                                const BoxDecoration(color: primaryColor),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 200,
                                  width: size.width,
                                  child: Stack(
                                    children: [
                                      if (activity.image != null)
                                        Positioned.fill(
                                          child: Image.network(
                                            activity.image!,
                                            height: 220,
                                            width: size.width,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      Positioned(
                                        top: 20,
                                        right: 20,
                                        child: Container(
                                          width: 80,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color:
                                                  primaryColor.withOpacity(0.9),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                  offset: const Offset(1, 1),
                                                  spreadRadius: 5,
                                                  blurRadius: 10,
                                                )
                                              ]),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                activity.startDate.day
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                getMount(
                                                    activity.startDate.month),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 20,
                                        left: 20,
                                        child: Container(
                                          width: 70,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color:
                                                primaryColor.withOpacity(0.9),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                offset: const Offset(1, 1),
                                                spreadRadius: 5,
                                                blurRadius: 10,
                                              )
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                activity.points.toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Text(
                                                'Puntos',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  color: primaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              activity.title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.directions,
                                                    color: Colors.white),
                                                const SizedBox(width: 5),
                                                Text(
                                                  activity.site,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.alarm,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  getHour(
                                                      activity.hour.toString()),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: GestureDetector(
                                            onTap: () async {
                                              final result = await push(context,
                                                  'activity-detail', activity);
                                              if (result != null) {
                                                bloc.removeActivity(
                                                    result as Activity);
                                              }
                                            },
                                            child: Container(
                                              width: 80,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    offset: const Offset(0, -5),
                                                    blurRadius: 10,
                                                    spreadRadius: 1,
                                                  )
                                                ],
                                              ),
                                              child: const Icon(
                                                Icons.arrow_forward,
                                                size: 40,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ))
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: bloc.activities!.length,
                      shrinkWrap: true,
                    ),
                  )
                : Center(
                    child: Text('no hay actividades disponibles'),
                  )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
