import 'package:clearApp/routes.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
    this.title = '',
  });

  String navigateScreen;
  String imagePath;
  String title;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/menu/shuttleCock.png',
      navigateScreen: Routes.shuttlecockMenu,
      title: 'Shuttlecock',
    ),
    HomeList(
      imagePath: 'assets/menu/racket.png',
      navigateScreen: Routes.racketMenu,
      title: 'Racket',
    ),
    HomeList(
      imagePath: 'assets/menu/games.png',
      navigateScreen: Routes.gamesMenu,
      title: 'Games',
    ),
    HomeList(
      imagePath: 'assets/menu/scores.png',
      navigateScreen: Routes.scoresMenu,
      title: 'deprecated',
    ),
    HomeList(
      imagePath: 'assets/menu/gatcha.png',
      navigateScreen: Routes.gatchaMenu,
      title: 'Gatcha',
    ),
  ];
}
