import 'package:clearApp/ui/navigation_home_screen.dart';
import 'package:clearApp/ui/fitness_app/fitness_app_home_screen.dart';
import 'package:clearApp/ui/games_menu/games_home_screen.dart';
import 'package:clearApp/ui/hotel_booking/hotel_home_screen.dart';
import 'package:clearApp/ui/login/login_screen.dart';
import 'package:clearApp/ui/navigation_home_screen.dart';
import 'package:clearApp/ui/racket_menu/racket_menu_homepage.dart';
import 'package:clearApp/ui/shuttle_menu/shuttle_history_homepage.dart';
import 'package:flutter/material.dart';

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
    homescreen: (BuildContext context) => NavigationHomeScreen(),
    shuttlecockMenu: (BuildContext context) => ShuttleHstrScreenWithProvider(),
    gamesMenu: (BuildContext context) => GamesHomeScreenWithProvider(),
    racketMenu: (BuildContext context) => RacketmenuHomepage(),
    scoresMenu: (BuildContext context) => HotelHomeScreen(),
    gatchaMenu: (BuildContext context) => FitnessAppHomeScreen(),
  };
}
