import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:bu_pulse/helpers/variables.dart';
import 'package:bu_pulse/screens/server_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({ super.key });

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: AppConfig.name,
      theme: ThemeData(
        primarySwatch: AppColor.primary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset(AppConfig.logo, width: 300.0),
        splashIconSize: double.infinity,
        backgroundColor: AppColor.primary,
        duration: 3000,
        splashTransition: SplashTransition.fadeTransition,
        nextScreen: const ServerScreen(),
      ),
    );
  }
}
