class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
    this.title = '',
  });

  String navigateScreen;
  String imagePath;
  String title;

  //TODO : fix nagigateScreen
  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/menu/shuttleCock.png',
      navigateScreen: '/homescreen/shuttlemenu',
      title: 'Shuttlecock',
    ),
    HomeList(
      imagePath: 'assets/menu/racket.png',
      navigateScreen: '/homescreeen/racketmenu',
      title: 'Racket',
    ),
    HomeList(
      imagePath: 'assets/menu/games.png',
      navigateScreen: '/homescreen/gamesmenu',
      title: 'Games',
    ),
    HomeList(
      imagePath: 'assets/menu/scores.png',
      navigateScreen: '/homescreeen/scoresmenu',
      title: 'deprecated',
    ),
    HomeList(
      imagePath: 'assets/menu/gatcha.png',
      navigateScreen: '/homescreen/gatchamenu',
      title: 'Gatcha',
    ),
  ];
}
