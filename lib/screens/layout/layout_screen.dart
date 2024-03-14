import 'package:aunar_welfar/domain/repository/local_storage_inter.dart';
import 'package:aunar_welfar/screens/activities/activities_screen.dart';
import 'package:aunar_welfar/screens/layout/layout_provider.dart';
import 'package:aunar_welfar/screens/my%20activities/my_activities_screen.dart';
import 'package:aunar_welfar/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen._();

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LayoutProvider(
          localStorageInterface:
              Provider.of<LocalStorageInterface>(context, listen: false))
        ..init(),
      builder: (context, child) => const LayoutScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<LayoutProvider>(context);
    List<Widget> pagesStudent = [
      ActivitiesScreen.init(context),
      MyActivitiesScreen.init(context),
      ProfileScreen.init(context)
    ];
    List<Widget> pagesTeacher = [
      MyActivitiesScreen.init(context),
      ProfileScreen.init(context)
    ];

    return Scaffold(
      body: bloc.type != null
          ? bloc.type == 'STUDENT'
              ? pagesStudent.elementAt(bloc.getPage())
              : pagesTeacher.elementAt(bloc.getPage())
          : const Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: bloc.type != null
          ? BottomNavigationBar(
              items: bloc.type == 'STUDENT'
                  ? const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.local_activity_outlined),
                        label: 'Actividades',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.local_activity_outlined,
                        ),
                        label: 'Mis Actividades',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.person,
                        ),
                        label: 'Mi perfil',
                      )
                    ]
                  : const [
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.local_activity_outlined,
                        ),
                        label: 'Mis Actividades',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.person,
                        ),
                        label: 'Mi perfil',
                      )
                    ],
              onTap: (value) => bloc.setPage(value),
              currentIndex: bloc.getPage(),
            )
          : null,
    );
  }
}
