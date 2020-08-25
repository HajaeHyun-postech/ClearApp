import 'package:clearApp/ui/racket_menu/racket_menu_home_screen.dart';
import 'package:clearApp/widget/app_theme.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:flutter/material.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:clearApp/store/racket/racket_store.dart';

class CustomFilter extends StatelessWidget {
  final List<RacketMenu> menus;
  Function onItemSelected;
  int initialindex;

  CustomFilter({
    @required this.menus,
    @required this.onItemSelected,
    @required this.initialindex,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionMenu<RacketMenu>(
      itemsList: menus,
      itemBuilder: this.itemBuilder,
      onItemSelected: onItemSelected,
      showSelectedItemAsTrigger: true,
      initiallySelectedItemIndex: initialindex,
      closeMenuInsteadOfPop: true,
      closeMenuOnEmptyMenuSpaceTap: false,
      closeMenuWhenTappedOutside: true,
      closeMenuOnItemSelected: true,
      allowMenuToCloseBeforeOpenCompletes: true,
      componentsConfiguration: DropdownComponentsConfiguration<RacketMenu>(
        listViewComponent: ListViewComponent(builder: _listViewBuilder),
        triggerFromItemComponent: TriggerFromItemComponent<RacketMenu>(
          builder: _triggerFromItemBuilder,
        ),
        menuPositionAndSizeComponent:
            MenuPositionAndSizeComponent(builder: _menuPositionBuilder),
        menuSizeConfiguration: MenuSizeConfiguration(
          maxHeight: menus.length * ScreenUtil().setHeight(400 / 3),
          minHeightFraction: 0.0,
          maxWidth: ScreenUtil().setWidth(400),
          minWidthFraction: 0.0,
        ),
      ),
    );
  }

  static MenuPositionAndSize _menuPositionBuilder(
      MenuPositionAndSizeComponentData data) {
    return MenuPositionAndSize(
      positionOffset: Offset(-ScreenUtil().setWidth(70),
          data.triggerPositionAndSize.size.height - 10),
      constraints: data.constraints,
    );
  }

  static Widget _listViewBuilder(ListViewComponentData data) {
    return ListView.separated(
      itemBuilder: data.itemBuilder,
      separatorBuilder: (context, _) {
        return Container(
          height: 1,
          color: Color(0xFFF1F4F7),
        );
      },
      itemCount: data.itemCount,
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    );
  }

  static Widget _triggerFromItemBuilder(TriggerFromItemComponentData data) {
    return Container(
      alignment: Alignment.centerRight,
      width: AppBar().preferredSize.height + 40,
      height: AppBar().preferredSize.height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(32.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.sort),
          ),
          onTap: data.triggerMenu,
        ),
      ),
    );
  }

  Widget itemBuilder(
    BuildContext context,
    RacketMenu menu,
    OnItemTapped onItemTapped,
  ) {
    return Material(
        color: ClearAppTheme.white,
        child: Row(children: <Widget>[
          InkWell(
            borderRadius: const BorderRadius.all(
              Radius.circular(2.0),
            ),
            onTap: onItemTapped,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
              child: Text(
                menu.menu,
                style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.w600,
                  fontSize: ScreenUtil().setSp(60),
                ),
              ),
            ),
          )
        ]));
  }
}
