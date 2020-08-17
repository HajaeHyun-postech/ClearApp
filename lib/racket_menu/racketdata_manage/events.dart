import '../../login/login_info.dart';

enum EVENT{
  RacketRentEvent,
  RacketReturnEvent,
  FilterMyHstrEvent,
  FilterMyRacketStatusEvent,
  FilterAllRacketStatusEvent,
  FilterAllRacketHstrEvent, // for admin
}

class RacketMenu{
  final EVENT eventType;
  final String menu;
  RacketMenu({this.eventType, this.menu});
}

class RacketMenus{
 
  static List<RacketMenu> returnMenus(){
    List<RacketMenu> menus = [
    RacketMenu(
      eventType: EVENT.FilterMyHstrEvent,
      menu: 'My History',
    ),
    RacketMenu(
      eventType: EVENT.FilterMyRacketStatusEvent,
      menu: 'My Status',
    ),
    RacketMenu(
      eventType: EVENT.FilterAllRacketStatusEvent,
      menu: 'Rent',
    ),
  ];
  if(LoginInfo().isAdmin == true){
      RacketMenu adminFilter = 
        new RacketMenu(
          eventType: EVENT.FilterAllRacketHstrEvent,
          menu: 'All Racket Rent History',
        );

      menus.add(adminFilter);
  }
    return menus;
  }
}