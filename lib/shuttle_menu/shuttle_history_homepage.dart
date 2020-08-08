import 'package:clearApp/racket_menu/racket_menu_homepage.dart';
import 'package:clearApp/shuttle_menu/prch_hstr_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'tab_model.dart';
import '../util/appbar.dart';
import '../util/app_theme.dart';
import 'data_manage/events.dart';
import 'package:provider/provider.dart';
import 'data_manage/shuttle_hitsory_subject.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:progress_indicators/progress_indicators.dart';

class ShuttleHstrHomePage extends StatefulWidget {
  @override
  ShuttleHstrHomePageState createState() => ShuttleHstrHomePageState();
}

class ShuttleHstrHomePageState extends State<ShuttleHstrHomePage>
    with TickerProviderStateMixin {
  ShuttlePrchHstrSubject shuttlePrchHstrSubject;

  AnimationController animationController;
  List<String> shuttleListToRcv;

  final ScrollController _scrollController = ScrollController();

  TabController _tabController;

  @override
  void initState() {
    super.initState();

    //animation setting
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _tabController =
        TabController(length: ShuttleMenuCurrentTab.values.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        shuttlePrchHstrSubject.eventHandle(EVENT.TabChangeEvent,
            tab: ShuttleMenuCurrentTab.values[_tabController.index]);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int moneyToPayCal() {
    int moneyToPay = 0;
    shuttlePrchHstrSubject.shuttlePrchHstrList.forEach((element) {
      element.approved ? moneyToPay += 0 : moneyToPay += element.price;
    });
    return moneyToPay;
  }

  @override
  Widget build(BuildContext context) {
    shuttlePrchHstrSubject = Provider.of<ShuttlePrchHstrSubject>(context);

    return Theme(
        data: ClearAppTheme.buildLightTheme(),
        child: Container(
            child: Scaffold(
          body: Stack(
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  children: <Widget>[
                    CustomAppBar(),
                    Expanded(
                        child: NestedScrollView(
                            controller: _scrollController,
                            headerSliverBuilder: (context, innerBoxIsScrolled) {
                              return <Widget>[
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    return Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: ScreenUtil().setHeight(40),
                                        ),
                                        ItemCard(
                                            'Unapproved',
                                            moneyToPayCal().toString() + ' \₩',
                                            [
                                              ClearAppTheme.orange,
                                              ClearAppTheme.pink
                                            ]),
                                        SizedBox(
                                            height: ScreenUtil().setHeight(40)),
                                      ],
                                    );
                                  }, childCount: 1),
                                ),
                                SliverPersistentHeader(
                                    pinned: true,
                                    floating: true,
                                    delegate: ContestTabHeader(_MyTabBar(
                                        tabController: _tabController,
                                        tabs: ShuttleTab.getShuttleTab())))
                              ];
                            },
                            body: Container(
                              color: ClearAppTheme.buildLightTheme()
                                  .backgroundColor,
                              child: ListView.builder(
                                  itemCount: shuttlePrchHstrSubject.isFeching
                                      ? 1
                                      : shuttlePrchHstrSubject
                                          .shuttlePrchHstrList.length,
                                  padding: const EdgeInsets.only(bottom: 1),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: shuttlePrchHstrSubject.isFeching
                                      ? (BuildContext context, int index) {
                                          return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: ScreenUtil()
                                                      .setHeight(100),
                                                ),
                                                JumpingText(
                                                  'Loading...',
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(45)),
                                                )
                                              ]);
                                        }
                                      : (BuildContext context, int index) {
                                          final int count =
                                              shuttlePrchHstrSubject
                                                  .shuttlePrchHstrList.length;
                                          final Animation<double>
                                              animation = Tween<double>(
                                                      begin: 0.0, end: 1.0)
                                                  .animate(CurvedAnimation(
                                                      parent:
                                                          animationController,
                                                      curve: Interval(
                                                          (1 / count) * index,
                                                          1.0,
                                                          curve: Curves
                                                              .fastOutSlowIn)));
                                          animationController.forward();
                                          return PrchHstrTile(
                                            animation: animation,
                                            animationController:
                                                animationController,
                                            prchHstr: shuttlePrchHstrSubject
                                                .shuttlePrchHstrList[index],
                                            isAdminTab:
                                                ShuttleMenuCurrentTab.values[
                                                        _tabController.index] ==
                                                    ShuttleMenuCurrentTab.Admin,
                                          );
                                        }),
                            )))
                  ],
                ),
              )
            ],
          ),
        )));
  }
}

class ItemCard extends StatelessWidget {
  final titel;
  final value;
  final colors;
  ItemCard(this.titel, this.value, this.colors);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(50),
            right: ScreenUtil().setWidth(50),
            top: ScreenUtil().setHeight(50),
            bottom: ScreenUtil().setHeight(50)),
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: colors),
            borderRadius: BorderRadius.circular(4.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  titel,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: ScreenUtil().setSp(55)),
                ),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: ScreenUtil().setSp(55)),
            )
          ],
        ),
      ),
    );
  }
}

class _MyTabBar extends StatelessWidget {
  const _MyTabBar({
    Key key,
    @required TabController tabController,
    @required List<Widget> tabs,
  })  : _tabController = tabController,
        _tabs = tabs,
        super(key: key);

  final TabController _tabController;
  final List<Widget> _tabs;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            color: ClearAppTheme.buildLightTheme().backgroundColor,
            child: Padding(
                padding:
                    const EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 8),
                child: TabBar(
                  indicator: MD2Indicator(
                      indicatorHeight: 4,
                      indicatorColor: ClearAppTheme.black,
                      indicatorSize: MD2IndicatorSize.tiny),
                  controller: _tabController,
                  tabs: _tabs.toList(),
                  labelColor: ClearAppTheme.black,
                  labelPadding: EdgeInsets.all(0.0),
                  unselectedLabelColor: Colors.grey,
                ))),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.tabUI,
  );
  final Widget tabUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return tabUI;
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
