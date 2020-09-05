import 'package:clearApp/store/game/game_store.dart';
import 'package:clearApp/store/login/login_store.dart';
import 'package:clearApp/store/racket/racket_store.dart';
import 'package:clearApp/store/shuttle/shuttle_store.dart';
import 'package:clearApp/ui/game_menu/game_home.dart';
import 'package:clearApp/vo/user/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    login: (BuildContext context) => Provider<LoginStore>(
          create: (_) => LoginStore(),
          child: LoginScreen(),
        ),
    homescreen: (BuildContext context) => Provider<User>.value(
        value: ModalRoute.of(context).settings.arguments,
        child: NavigationHomeScreen()),
    shuttlecockMenu: (BuildContext context) => Provider<ShuttleStore>(
          create: (_) => ShuttleStore(),
          child: ShuttleMenuScreen(),
        ),
    gamesMenu: (BuildContext context) => Provider<GameStore>(
          create: (_) => GameStore(),
          child: GameHome(),
        ),
    racketMenu: (BuildContext context) => Provider<RacketStore>(
          create: (_) => RacketStore(),
          child: RacketMenuHome(),
        ),
    scoresMenu: (BuildContext context) => HotelHomeScreen(),
    gatchaMenu: (BuildContext context) => FitnessAppHomeScreen(),
  };
}
