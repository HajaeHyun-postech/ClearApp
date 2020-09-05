import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:selection_menu/selection_menu.dart';

import '../../store/racket/racket_store.dart';
import '../../vo/user/user.dart';
import '../../widget/app_theme.dart';
import '../../widget/appbar.dart';
import 'custom_filter.dart';
import 'racket_data_tile.dart';
import 'racket_history_tile.dart';

class RacketMenu {
  final RacketMenuEnum eventType;
  final String menu;
  RacketMenu({this.eventType, this.menu});
}

class RacketMenuHome extends StatefulWidget {
  const RacketMenuHome({Key key}) : super(key: key);

  @override
  _RacketMenuHomeState createState() => _RacketMenuHomeState();
}

class _RacketMenuHomeState extends State<RacketMenuHome>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  SelectionMenuController selectionMenuController;
  RacketStore racketStore;
  List<RacketMenu> menus;
  AnimationController animationController;
  User user;

  void onItemSelected(RacketMenu menu) {
    if (racketStore.currentMenu != menu.eventType) {
      animationController.reset();
      racketStore.tabChanged(menu.eventType);
      racketStore.refreshOnTabChange();
    }
  }

  @override
  void initState() {
    super.initState();
    selectionMenuController = SelectionMenuController();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ModalRoute.of(context).settings.arguments;
    racketStore = Provider.of<RacketStore>(context);

    menus = [
      RacketMenu(eventType: RacketMenuEnum.AllRacketStatus, menu: "Borrow"),
      RacketMenu(eventType: RacketMenuEnum.MyRacketHstr, menu: "My"),
      if (user.isAdmin)
        RacketMenu(eventType: RacketMenuEnum.AllHstr, menu: "All")
    ];
  }

  @override
  void dispose() {
    racketStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            CustomAppBar(),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top, left: 8, right: 8),
              child: Container(
                height: AppBar().preferredSize.height,
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    CustomFilter(
                      menus: menus,
                      onItemSelected: onItemSelected,
                      initialindex: racketStore.currentMenu.index,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
              color: ClearAppTheme.buildLightTheme().backgroundColor,
              child: CustomScrollView(
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                slivers: <Widget>[
                  Observer(
                    builder: (_) {
                      final count = racketStore.currentMenu ==
                              RacketMenuEnum.AllRacketStatus
                          ? racketStore.rackets.length
                          : racketStore.histories.length;

                      return SliverPadding(
                        padding:
                            EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                        sliver: SliverList(
                          delegate: racketStore.loading
                              ? SliverChildBuilderDelegate(
                                  (context, index) {
                                    return Column(children: <Widget>[
                                      SizedBox(
                                        height: ScreenUtil().setHeight(50),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(90),
                                        child: LoadingIndicator(
                                          indicatorType:
                                              Indicator.circleStrokeSpin,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ]);
                                  },
                                  childCount: 1,
                                )
                              : SliverChildBuilderDelegate(
                                  (context, index) {
                                    final Animation<double> animation =
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(CurvedAnimation(
                                                parent: animationController,
                                                curve: Interval(
                                                    (1 / count) * index, 1.0,
                                                    curve:
                                                        Curves.fastOutSlowIn)));

                                    animationController.forward();

                                    switch (racketStore.currentMenu) {
                                      case RacketMenuEnum.AllRacketStatus:
                                        final racket =
                                            racketStore.rackets[index];

                                        final isReturn = racket.user == null
                                            ? false
                                            : racket.user.studentId ==
                                                user.studentId;

                                        final isAvailable = racket.isAvailable;

                                        return RacketDataTile(
                                          animation: animation,
                                          animationController:
                                              animationController,
                                          racket: racket,
                                          isBorrowLimit:
                                              racketStore.isBorrowLimit,
                                          isReturn: isReturn,
                                          isAvailable: isAvailable,
                                        );
                                        break;
                                      case RacketMenuEnum.MyRacketHstr:
                                      case RacketMenuEnum.AllHstr:
                                        return RacketHistoryTile(
                                          animation: animation,
                                          animationController:
                                              animationController,
                                          history: racketStore.histories[index],
                                        );
                                        break;
                                      default:
                                        return Container();
                                    }
                                  },
                                  childCount: count,
                                ),
                        ),
                      );
                    },
                  )
                ],
              )),
        ),
      ],
    ));
  }
}
