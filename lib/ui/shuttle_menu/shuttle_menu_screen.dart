import 'package:clearApp/store/shuttle/shuttle_form_store.dart';
import 'package:clearApp/store/shuttle/shuttle_store.dart';
import 'package:clearApp/ui/shuttle_menu/history_tile.dart';
import 'package:clearApp/vo/shuttle_order_history/shuttle_order_history.dart';
import 'package:clearApp/widget/app_theme.dart';
import 'package:clearApp/widget/appbar.dart';
import 'package:clearApp/widget/toast_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'order_form.dart';

class ShuttleMenuScreenWithProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<ShuttleStore>(
      create: (_) => ShuttleStore(),
      child: ShuttleMenuScreen(),
    );
  }
}

enum TAB { Total, Not_Rcved, Admin }

class ShuttleMenuScreen extends StatefulWidget {
  @override
  ShuttleMenuScreenState createState() => ShuttleMenuScreenState();
}

class ShuttleMenuScreenState extends State<ShuttleMenuScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  ScrollController _scrollController = ScrollController();
  TabController _tabController;
  ShuttleStore shuttleStore;

  final List<Widget> _tabs = [
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('TOTAL'),
      ),
    ),
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('NOT RCVED'),
      ),
    ),
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('ADMIN'),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _tabController = TabController(length: TAB.values.length, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    shuttleStore = Provider.of<ShuttleStore>(context);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        tabChangeEvent();
      }
    });

    shuttleStore.disposers
      ..add(autorun((_) {
        if (shuttleStore.success) {
          tabChangeEvent();
          ToastGenerator.successToast(
              context, shuttleStore.successStore.successMessage);
        } else {
          ToastGenerator.errorToast(
              context, shuttleStore.errorStore.errorMessage);
        }
      }));
  }

  void tabChangeEvent() {
    if (TAB.values[_tabController.index] == TAB.Admin) {
      shuttleStore.getWholeUnconfirmedHistorires();
    } else if (TAB.values[_tabController.index] == TAB.Not_Rcved) {
      shuttleStore.getNotReceivedUsersHistories();
    } else {
      shuttleStore.getUsersHistories();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    shuttleStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ClearAppTheme.buildLightTheme(),
        child: Container(
            child: Scaffold(
                body: InkWell(
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
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              return Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: ScreenUtil().setHeight(40),
                                  ),
                                  Observer(builder: (_) {
                                    final bool isAdminTab =
                                        TAB.values[_tabController.index] ==
                                            TAB.Admin;
                                    String title = isAdminTab
                                        ? 'Unconfirmed'
                                        : 'Amount due';
                                    return Topcard(
                                        title,
                                        shuttleStore.unconfirmedPrice
                                                .toString() +
                                            ' \₩',
                                        [
                                          ClearAppTheme.orange.withAlpha(230),
                                          ClearAppTheme.pink.withAlpha(230)
                                        ]);
                                  }),
                                  SizedBox(height: ScreenUtil().setHeight(40)),
                                ],
                              );
                            }, childCount: 1),
                          ),
                          SliverPersistentHeader(
                              pinned: true,
                              floating: true,
                              delegate: ContestTabHeader(_MyTabBar(
                                  tabController: _tabController, tabs: _tabs)))
                        ];
                      },
                      body: Container(
                          color:
                              ClearAppTheme.buildLightTheme().backgroundColor,
                          child: Observer(
                            builder: (_) {
                              int itemCount;
                              List<ShuttleOrderHistory> list =
                                  shuttleStore.histories;
                              itemCount = list.length;

                              return ListView.builder(
                                  itemCount:
                                      shuttleStore.loading ? 1 : itemCount,
                                  padding: const EdgeInsets.only(bottom: 1),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: shuttleStore.loading
                                      ? (BuildContext context, int index) {
                                          return Column(children: <Widget>[
                                            SizedBox(
                                              height:
                                                  ScreenUtil().setHeight(60),
                                            ),
                                            JumpingText('Loading...',
                                                style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(45)))
                                          ]);
                                        }
                                      : (BuildContext context, int index) {
                                          final bool isAdminTab = TAB.values[
                                                  _tabController.index] ==
                                              TAB.Admin;
                                          final Animation<double>
                                              animation = Tween<double>(
                                                      begin: 0.0, end: 1.0)
                                                  .animate(CurvedAnimation(
                                                      parent:
                                                          animationController,
                                                      curve: Interval(
                                                          (1 / itemCount) *
                                                              index,
                                                          1.0,
                                                          curve: Curves
                                                              .fastOutSlowIn)));
                                          animationController.forward();

                                          String title;
                                          String firstActionCaption;
                                          String secondActionCaption;
                                          Function firstTapAction;
                                          Function secondTapAction;
                                          if (isAdminTab) {
                                            title =
                                                '${list[index].user.name} : ${list[index].orderUsage}';
                                            firstActionCaption = 'Confirm';
                                            secondActionCaption = 'Delete';
                                            firstTapAction = () =>
                                                shuttleStore.confirmDeposit(
                                                    list[index].idList,
                                                    list[index]
                                                        .depositConfirmed);
                                            secondTapAction = () =>
                                                shuttleStore.receiveShuttle(
                                                    list[index].idList,
                                                    list[index].received);
                                          } else {
                                            title = '${list[index].orderUsage}';
                                            firstActionCaption = 'Receive';
                                            secondActionCaption = 'Delete';
                                            firstTapAction = () =>
                                                shuttleStore.receiveShuttle(
                                                    list[index].idList,
                                                    list[index].received);
                                            secondTapAction = () =>
                                                shuttleStore.receiveShuttle(
                                                    list[index].idList,
                                                    list[index].received);
                                          }
                                          return HistoryTile(
                                            animation: animation,
                                            animationController:
                                                animationController,
                                            idList: list[index].idList,
                                            title: title,
                                            name: list[index].user.name,
                                            price: list[index].price,
                                            orderDate: list[index].orderDate,
                                            depositConfirmed:
                                                list[index].depositConfirmed,
                                            received: list[index].received,
                                            firstActionCaption:
                                                firstActionCaption,
                                            secondActionCaption:
                                                secondActionCaption,
                                            firstTapAction: firstTapAction,
                                            secondTapAction: secondTapAction,
                                          );
                                        });
                            },
                          ))))
            ],
          ),
        ))));
  }
}

class Topcard extends StatelessWidget {
  final title;
  final value;
  final colors;
  Topcard(this.title, this.value, this.colors);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(50),
                    right: ScreenUtil().setWidth(50),
                    top: ScreenUtil().setHeight(50),
                    bottom: ScreenUtil().setHeight(50)),
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        offset: const Offset(0, 2),
                        blurRadius: 9.0)
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: colors),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: ScreenUtil().setSp(57)),
                        ),
                      ],
                    ),
                    Text(
                      value,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: ScreenUtil().setSp(57)),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(50),
            ),
            Container(
              decoration: BoxDecoration(
                color: ClearAppTheme.postechRed.withAlpha(200),
                borderRadius: const BorderRadius.all(
                  Radius.circular(38.0),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      offset: const Offset(0, 2),
                      blurRadius: 9.0)
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  onTap: () {
                    showBarModalBottomSheet(
                      expand: false,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context, scrollController) => Material(
                          child: CupertinoPageScaffold(
                        child: SafeArea(
                          child: Provider<ShuttleFormStore>(
                              create: (context) => ShuttleFormStore(),
                              child: OrderForm()),
                        ),
                      )),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Icon(FontAwesomeIcons.plus,
                        size: 16, color: ClearAppTheme.white),
                  ),
                ),
              ),
            )
          ],
        ));
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
                  labelStyle: TextStyle(fontSize: ScreenUtil().setSp(45)),
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
