import 'package:clearApp/widget/app_theme.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:flutter/material.dart';
import 'package:selection_menu/components_configurations.dart';
import './racketdata_manage/events.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFilter extends StatelessWidget {
  final SelectionMenuController selectionMenuController =
      SelectionMenuController();

  @override
  Widget build(BuildContext context) {
    return SelectionMenu<RacketMenu>(
      itemsList: RacketMenus.returnMenus(),
      itemBuilder: this.itemBuilder,
      onItemSelected: this.onItemSelected,
      showSelectedItemAsTrigger: true,
      initiallySelectedItemIndex: 0,
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
          maxHeight: ScreenUtil().setHeight(400),
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
      positionOffset: Offset(0, data.triggerPositionAndSize.size.height),
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
    return Material(
        color: ClearAppTheme.white,
        child: Row(children: <Widget>[
          InkWell(
              borderRadius: const BorderRadius.all(
                Radius.circular(2.0),
              ),
              onTap: data.triggerMenu,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(0),
                      vertical: ScreenUtil().setHeight(5)),
                  child: Row(children: <Widget>[
                    Text(
                      data.item.menu,
                      style: TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontWeight: FontWeight.w600,
                        fontSize: ScreenUtil().setSp(60),
                      ),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(30)),
                    FaIcon(
                      FontAwesomeIcons.caretDown,
                      size: ScreenUtil().setWidth(45),
                      color: ClearAppTheme.darkBlue,
                    ),
                  ])))
        ]));
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

  void onItemSelected(RacketMenu menu) {
    print(menu.menu);
  }
}
