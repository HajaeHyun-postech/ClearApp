import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../store/shuttle/shuttle_form_store.dart';
import '../../store/shuttle/shuttle_store.dart';
import '../../vo/shuttle_order_history/shuttle_order_history.dart';
import '../../vo/user/user.dart';
import '../../widget/app_theme.dart';
import '../../widget/appbar.dart';
import 'add_shuttle_form.dart';
import 'history_tile.dart';
import 'order_form.dart';

class ShuttleMenuScreen extends StatefulWidget {
  const ShuttleMenuScreen({Key key}) : super(key: key);

  @override
  ShuttleMenuScreenState createState() => ShuttleMenuScreenState();
}

class ShuttleMenuScreenState extends State<ShuttleMenuScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  ScrollController _scrollController = ScrollController();
  TabController _tabController;
  ShuttleStore shuttleStore;
  List<Widget> _tabs;
  User user;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ModalRoute.of(context).settings.arguments;
    shuttleStore = context.read<ShuttleStore>();

    _tabs = [
      Tab(
        child: Align(
          alignment: Alignment.center,
          child: Text('ALL'),
        ),
      ),
      Tab(
        child: Align(
          alignment: Alignment.center,
          child: Text('NOT RCVED'),
        ),
      ),
      if (user.isAdmin)
        Tab(
          child: Align(
            alignment: Alignment.center,
            child: Text('ADMIN'),
          ),
        ),
    ];

    _tabController = TabController(
        length: _tabs.length,
        vsync: this,
        initialIndex: shuttleStore.currentTab.index);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        if (shuttleStore.currentTab != TAB.values[_tabController.index]) {
          animationController.reset();
          shuttleStore.tabChanged(TAB.values[_tabController.index]);
          shuttleStore.refreshOnTabChange();
        }
      }
    });
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
                                  Observer(
                                    builder: (_) {
                                      final isAdminTab =
                                          shuttleStore.currentTab == TAB.Admin;
                                      return Topcard(
                                          title: isAdminTab
                                              ? 'Unconfirmed'
                                              : 'Amount due',
                                          value:
                                              '${shuttleStore.unconfirmedPrice}  \₩',
                                          colors: [
                                            ClearAppTheme.orange.withAlpha(230),
                                            ClearAppTheme.pink.withAlpha(230)
                                          ],
                                          modalBuilder: isAdminTab
                                              ? Builder(
                                                  builder: (_) {
                                                    return AddShuttleForm();
                                                  },
                                                )
                                              : Builder(
                                                  builder: (_) {
                                                    return OrderForm();
                                                  },
                                                ));
                                    },
                                  ),
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
                              final bool isAdminTab =
                                  TAB.values[_tabController.index] == TAB.Admin;
                              List<ShuttleOrderHistory> list =
                                  shuttleStore.histories;
                              int itemCount = list.length;

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
                                                  ScreenUtil().setHeight(50),
                                            ),
                                            SizedBox(
                                              height:
                                                  ScreenUtil().setHeight(90),
                                              child: LoadingIndicator(
                                                indicatorType:
                                                    Indicator.circleStrokeSpin,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ]);
                                        }
                                      : (BuildContext context, int index) {
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
                                            firstTapAction = () => shuttleStore
                                                .confirmDeposit(list[index].id);
                                            secondTapAction = () => shuttleStore
                                                .deleteOrder(list[index].id);
                                          } else {
                                            title = '${list[index].orderUsage}';
                                            firstActionCaption = 'Receive';
                                            secondActionCaption = 'Delete';
                                            firstTapAction = () => shuttleStore
                                                .receiveShuttle(list[index].id);
                                            secondTapAction = () => shuttleStore
                                                .deleteOrder(list[index].id);
                                          }
                                          return HistoryTile(
                                            animation: animation,
                                            animationController:
                                                animationController,
                                            id: list[index].id,
                                            title: title,
                                            price: list[index].price,
                                            orderDate: list[index].orderDate,
                                            isConfirmed:
                                                list[index].isConfirmed,
                                            isReceived: list[index].isReceived,
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
  final modalBuilder;
  Topcard({this.title, this.value, this.colors, this.modalBuilder});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(60),
                    right: ScreenUtil().setWidth(60),
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
                    Text(value,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: ScreenUtil().setSp(57))),
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
                              child: modalBuilder),
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
