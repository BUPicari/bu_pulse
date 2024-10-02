import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bu_pulse/services/notification_service.dart';
import 'package:bu_pulse/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}
