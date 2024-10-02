import 'package:flutter/material.dart';

class AppColor {
  static MaterialColor primary = Colors.lightBlue;
  static MaterialColor secondary = Colors.blueGrey;
  static Color subPrimary = Colors.white;
  static Color subSecondary = Colors.black;
  static Color subTertiary = Colors.black12;
  static Color success = const Color(0xffd4edda);
  static Color darkSuccess = Colors.green;
  static MaterialColor warning = Colors.orange;
  static Color error = const Color(0xfff8d7da);
  static Color darkError = Colors.red;
  static MaterialColor neutral = Colors.grey;
  static Color? bgNeutral = Colors.grey[300];
  static List<MaterialColor> linearGradient = [secondary, primary];
}

class ApiConfig {
  /// UPDATER URL
  // static String updaterUrl = "https://app-config-manager.vercel.app/api/mobile";
  static String updaterUrl = "";
  /// UPDATER API KEY
  static String updaterApiKey = "";
  /// SERVER URL
  // static String baseUrl = "https://chedlakas.mab.com.ph:8001";
  static String baseUrl = "https://www.bu-research.online/bupulse-api";
  /// SERVER API KEY
  // static String apiKey = "vTZiBkM3GZniy45jf14V_Mpdvm43enyIzW61NAuzZTc";
  static String apiKey = "BIBgAolNJodHxR95ghUnR2soX4JvzSSbIKWMo9IKg60";
  /// VISUALIZATION URL
  // static String visualizationUrl = "https://chedlakas.mab.com.ph:8004/admin";
  /// LOCAL URL
  // static String baseUrl = "http://10.10.16.117:3001";
  /// LOCAL API KEY
  // static String apiKey = "BIBgAolNJodHxR95ghUnR2soX4JvzSSbIKWMo9IKg60";
}

class AppConfig {
  static String name = "BUPulse";
  static String logo = "assets/images/bupulse-logo.png";
  static String demoVideo = "assets/videos/howto.mp4";
  static String offlineModeText = "Switching to offline mode. Please wait while the data is being downloaded ...";
  static String onlineModeText = "Switching to online mode ...";
}
