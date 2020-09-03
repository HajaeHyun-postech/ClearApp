import 'package:flutter/material.dart';

import 'ui/fitness_app/fitness_app_home_screen.dart';
import 'ui/hotel_booking/hotel_home_screen.dart';
import 'ui/login/login_screen.dart';
import 'ui/home/navigation_home_screen.dart';
import 'ui/racket_menu/racket_menu_home_screen.dart';
import 'ui/shuttle_menu/shuttle_menu_screen.dart';

class Routes {
  Routes._();

  //static variables
  static const String login = '/login';
  static const String homescreen = '/homescreen';
  static const String shuttlecockMenu = '/homescreen/shuttlecockMenu';
  static const String gamesMenu = '/homescreen/gamesMenu';
  static const String racketMenu = '/homescreen/racketMenu';
  static const String scoresMenu = '/homescreen/scoresMenu';
  static const String gatchaMenu = '/homescreen/gatchaMenu';

  static final routes = <String, WidgetBuilder>{
    login: (BuildContext context) => LoginScreenWithProvider(),
    homescreen: (BuildContext context) => NavigationHomeScreenWithProvider(),
    shuttlecockMenu: (BuildContext context) => ShuttleMenuScreenWithProvider(),
    gamesMenu: (BuildContext context) => RacketMenuHomeScreenWithProvider(),
    racketMenu: (BuildContext context) => RacketMenuHomeScreenWithProvider(),
    scoresMenu: (BuildContext context) => HotelHomeScreen(),
    gatchaMenu: (BuildContext context) => FitnessAppHomeScreen(),
  };
}
