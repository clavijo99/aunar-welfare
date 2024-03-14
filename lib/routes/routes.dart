import 'package:aunar_welfar/screens/activities%20detail/activity_detail_screen.dart';
import 'package:aunar_welfar/screens/layout/layout_screen.dart';
import 'package:aunar_welfar/screens/login/login_screen.dart';
import 'package:aunar_welfar/screens/splash/splash_screen.dart';
import 'package:aunar_welfar/screens/widgets/qr_scanner.dart';
import 'package:aunar_welfar/screens/widgets/recover%20password/generate_code.dart';
import 'package:flutter/material.dart';

routes(BuildContext context) => {
      '/': (context) => SplashScreen.init(context),
      'login': (context) => LoginScreen.init(context),
      'layout': (context) => LayoutScreen.init(context),
      'activity-detail': (context) => ActivityDetailScreen.init(context),
      'qr-scanner': (context) => const QrScanner(),
      'generate-code': (context) => GenerateCode.init(context)
    };
