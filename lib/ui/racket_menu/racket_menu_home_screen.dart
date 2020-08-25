import 'package:clearApp/store/racket/racket_store.dart';
import 'package:clearApp/ui/racket_menu/racket_data_tile.dart';
import 'package:clearApp/ui/racket_menu/racket_history_tile.dart';
import 'package:clearApp/widget/app_theme.dart';
import 'package:clearApp/widget/appbar.dart';
import 'package:clearApp/widget/toast_generator.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:clearApp/vo/user/user.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'custom_filter.dart';

class RacketMenu {
  final RacketMenuEnum eventType;
  final String menu;
  RacketMenu({this.eventType, this.menu});
}

class RacketMenuHomeScreenWithProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<RacketStore>(
      create: (_) => RacketStore(),
      child:
          RacketMenuHomeScreen(user: ModalRoute.of(context).settings.arguments),
    );
  }
}

class RacketMenuHomeScreen extends StatelessWidget {
  final User user;

  const RacketMenuHomeScreen({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RacketScrollView(user: user),
    );
  }
}

class RacketScrollView extends StatefulWidget {
  final User user;

  RacketScrollView({Key key, this.user}) : super(key: key);
  @override
  _RacketScrollView createState() => _RacketScrollView();
}

class _RacketScrollView extends State<RacketScrollView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  SelectionMenuController selectionMenuController;
  RacketStore racketStore;
  List<RacketMenu> menus;
  AnimationController animationController;

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
    racketStore = Provider.of<RacketStore>(context);

    racketStore.disposers
      ..add(reaction((_) => racketStore.successStore.success, (success) {
        if (success) {
          racketStore.refreshOnTabChange();
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
      RacketMenu(
          eventType: RacketMenuEnum.AllRacketStatus, menu: "Racket Rent"),
      RacketMenu(eventType: RacketMenuEnum.MyRacketHstr, menu: "My History"),
      if (widget.user.isAdmin)
        RacketMenu(eventType: RacketMenuEnum.AllHstr, menu: "All History")
    ];
  }

  @override
  void dispose() {
    racketStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                      return SliverPadding(
                        padding:
                            EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              //TODO: Refactoring. 코드가 넘 더럽다.
                              final count = racketStore.rackets.length;

                              final Animation<double> animation =
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                      CurvedAnimation(
                                          parent: animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn)));

                              animationController.forward();
                              switch (racketStore.currentMenu) {
                                case RacketMenuEnum.AllRacketStatus:
                                  return RacketDataTile(
                                      animation: animation,
                                      animationController: animationController,
                                      racket: racketStore.rackets[index]);
                                  break;
                                case RacketMenuEnum.MyRacketHstr:
                                case RacketMenuEnum.AllHstr:
                                  return RacketHistoryTile(
                                    animation: animation,
                                    animationController: animationController,
                                    racketCard: racketStore.histories[index],
                                  );
                                  break;
                                default:
                                  return Container();
                              }
                            },
                            childCount: racketStore.currentMenu ==
                                    RacketMenuEnum.AllRacketStatus
                                ? racketStore.rackets.length
                                : racketStore.histories.length,
                          ),
                        ),
                      );
                    },
                  )
                ],
              )),
        ),
      ],
    );
  }
}
