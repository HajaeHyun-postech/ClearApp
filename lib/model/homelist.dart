import 'package:clearApp/shuttle_menu/shuttle_menu_homepage.dart';
import 'package:flutter/widgets.dart';

import '../design_course/home_design_course.dart';
import '../fitness_app/fitness_app_home_screen.dart';
import '../hotel_booking/hotel_home_screen.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
    this.title = '',
  });

  Widget navigateScreen;
  String imagePath;
  String title;

  //TODO : fix nagigateScreen
  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/menu/shuttleCock.png',
      navigateScreen: ShuttleMenuHomePage(),
      title: 'Shuttlecock',
    ),
    HomeList(
      imagePath: 'assets/menu/racket.png',
      navigateScreen: DesignCourseHomeScreen(),
      title: 'Racket',
    ),
    HomeList(
      imagePath: 'assets/menu/apply.png',
      navigateScreen: DesignCourseHomeScreen(),
      title: 'Matches',
    ),
    HomeList(
      imagePath: 'assets/menu/matchRetrieve.png',
      navigateScreen: DesignCourseHomeScreen(),
      title: '(Depredicated)',
    ),
    HomeList(
      imagePath: 'assets/menu/opgg.png',
      navigateScreen: DesignCourseHomeScreen(),
      title: '(Depredicated)',
    ),
    HomeList(
      imagePath: 'assets/menu/tongdolli.png',
      navigateScreen: DesignCourseHomeScreen(),
      title: '(Depredicated)',
    ),
    HomeList(
      imagePath: 'assets/menu/matchMake.png',
      navigateScreen: DesignCourseHomeScreen(),
      title: '(Depredicated)',
    ),
    HomeList(
      imagePath: 'assets/menu/matchFix.png',
      navigateScreen: DesignCourseHomeScreen(),
      title: '(Depredicated)',
    ),
    HomeList(
      imagePath: 'assets/hotel/hotel_booking.png',
      navigateScreen: HotelHomeScreen(),
      title: 'hotel',
    ),
    HomeList(
      imagePath: 'assets/fitness_app/fitness_app.png',
      navigateScreen: FitnessAppHomeScreen(),
      title: 'fitness',
    ),
    HomeList(
      imagePath: 'assets/design_course/design_course.png',
      navigateScreen: DesignCourseHomeScreen(),
      title: 'design',
    ),
  ];
}
