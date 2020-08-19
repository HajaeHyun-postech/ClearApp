import '../../login/login_info.dart';

enum EVENT{
  RacketRentEvent,
  RacketReturnEvent,
  FilterChangeEvent,
}

enum RacketCurrentMenu{
  FilterMyHstrEvent,
  FilterMyRacketStatusEvent,
  FilterAllRacketStatusEvent,
  FilterAllRacketHstrEvent, 
}

class RacketMenu{
  final RacketCurrentMenu eventType;
  final String menu;
  RacketMenu({this.eventType, this.menu});
}

class RacketMenus{
 
  static List<RacketMenu> returnMenus(){
    List<RacketMenu> menus = [
    RacketMenu(
      eventType: RacketCurrentMenu.FilterAllRacketStatusEvent,
      menu: 'Rent',
    ),
    RacketMenu(
      eventType: RacketCurrentMenu.FilterMyRacketStatusEvent,
      menu: 'My Status',
    ),
    RacketMenu(
      eventType: RacketCurrentMenu.FilterMyHstrEvent,
      menu: 'My History',
    ),
  ];
  if(LoginInfo().isAdmin == true){
      RacketMenu adminFilter = 
        new RacketMenu(
          eventType: RacketCurrentMenu.FilterAllRacketHstrEvent,
          menu: 'All History',
        );

      menus.add(adminFilter);
  }
    return menus;
  }
}