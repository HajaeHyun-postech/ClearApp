import 'dart:io';
import 'package:clearApp/shuttle_menu/shuttle_menu_homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'util/app_theme.dart';
import 'login/login_when_start.dart';
import 'navigation_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'Clear App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: ClearAppTheme.textTheme,
        platform: TargetPlatform.iOS,
      ),
      locale: Locale('en', 'KR'),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/homescreen': (context) => NavigationHomeScreen(),
        '/homescreen/shuttlemenu': (context) => ShuttleMenuHomePage(),
      }, //use this route by Navigator.pushNamed(context, address)
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
