import 'package:clearApp/store/racket/racket_store.dart';
import 'package:clearApp/widget/app_theme.dart';
import 'package:clearApp/widget/appbar.dart';
import 'package:clearApp/widget/toast_generator.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'racket_cardlist.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:clearApp/vo/user/user.dart';
import 'custom_filter.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class RacketMenu {
  final RacketCurrentMenu eventType;
  final String menu;
  RacketMenu({this.eventType, this.menu});
}

class RacketMenuHomeScreenWithProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<RacketStore>(
      create: (_) => RacketStore(),
      child: RacketMenuHomeScreen(),
    );
  }
}

class RacketMenuHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        CustomAppBar(),
        RacketScrollView(user: ModalRoute.of(context).settings.arguments),
      ],
    ));
  }
}

class RacketScrollView extends StatefulWidget {
  final User user;
  RacketScrollView({Key key, this.user}) : super(key: key);
  @override
  _RacketScrollView createState() => _RacketScrollView();
}

class _RacketScrollView extends State<RacketScrollView> {
  final ScrollController _scrollController = ScrollController();
  SelectionMenuController selectionMenuController;
  RacketStore racketStore;
  List<RacketMenu> menus;

  void onItemSelected(RacketMenu menu) {
    racketStore.tabChanged(menu.eventType);
    print(racketStore.currentMenu);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      //print('offset = ${_scrollController.offset}');
    });
    selectionMenuController = SelectionMenuController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    racketStore = Provider.of<RacketStore>(context);

    racketStore.disposers
      ..add(reaction((_) => racketStore.successStore.success, (success) {
        if (success) {
          ToastGenerator.successToast(
              context, racketStore.successStore.successMessage);
        }
      }))
      ..add(reaction((_) => racketStore.errorStore.error, (error) {
        if (error) {
          ToastGenerator.errorToast(
              context, racketStore.errorStore.errorMessage);
        }
      }));

    menus = [
      RacketMenu(eventType: RacketCurrentMenu.AllRacketStatus, menu: "Rent"),
      RacketMenu(eventType: RacketCurrentMenu.MyHstr, menu: "MyHstr"),
    ];

    if (widget.user.isAdmin) {
      RacketMenu adminTab = RacketMenu(
          eventType: RacketCurrentMenu.AllRacketHstr, menu: "AllRacketHstr");

      menus.add(adminTab);
    }

    ///racketStore.rackets 에 라켓 정보가 들어있음
    ///위 코드는 check out/ in 이 성공 / 실패 할때마다 토스트를 띄우고, refresh 하는 코드.
    ///shuttle_menu/order_form 을 참고하면 됨.
    ///프로바이더 패턴으로 racketStore을 얻어서, store 의 action 함수를 실행하면 됨.
    ///toast message는 위 코드에서 알아서 띄우므로, UI 쪽에서 코드를 집어넣을 필요 없음.
  }

  @override
  void dispose() {
    racketStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: ClearAppTheme.buildLightTheme().backgroundColor,
        child: Observer(builder: (_) {
          return CustomScrollView(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Row(children: <Widget>[
                    SizedBox(width: ScreenUtil().setWidth(70)),
                    CustomFilter(
                      menus: menus,
                      racketStore: racketStore,
                      onItemSelected: onItemSelected,
                      initialindex: racketStore.getindex(),
                    ),
                  ]),
                  childCount: 1,
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => racketStore.currentMenu ==
                            RacketCurrentMenu.AllRacketStatus
                        ? RacketCardList(racketStore.rackets[index])
                        : (racketStore.currentMenu == RacketCurrentMenu.MyHstr
                            ? null
                            : null),
                    childCount: racketStore.rackets.length,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
