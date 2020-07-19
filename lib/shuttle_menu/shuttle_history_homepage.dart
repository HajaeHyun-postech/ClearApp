import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../util/appbar.dart';
import '../util/app_theme.dart';
import 'data_manage/shuttle_hitsory_handler.dart';
import 'data_manage/shuttle_purchace_history.dart';
import '../util/constants.dart' as Constants;

class ShuttleHstrHomePage extends StatefulWidget {
  @override
  ShuttleHstrHomePageState createState() => ShuttleHstrHomePageState();
}

class ShuttleHstrHomePageState extends State<ShuttleHstrHomePage>
    with SingleTickerProviderStateMixin {
  List<ShuttlePrchHstr> shuttlePrchHstrList = new List<ShuttlePrchHstr>();

  List<String> shuttleListToRcv;
  int moneyToPay;

  final ScrollController _scrollController = ScrollController();

  TabController _tabController;
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
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ShuttlePrchHstrHandler().updateTabChanged(
            Constants.ShuttleMenuCurrentTab.values[_tabController.index]);
      }
    });

    ShuttlePrchHstrHandler().dataUpdateCallback = (list) {
      setState(() {
        shuttlePrchHstrList = list;
      });
    };

    ShuttlePrchHstrHandler()
        .updateTabChanged(Constants.ShuttleMenuCurrentTab.Total);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void moneyToPayCal() {
    moneyToPay = 0;
    shuttlePrchHstrList.forEach((element) {
      element.approved ? moneyToPay += 0 : moneyToPay += element.price;
    });
  }

  void shuttleListToRcvCal() {
    shuttleListToRcv = new List<String>();
    shuttlePrchHstrList.forEach((element) {
      if (element.received) shuttleListToRcv.addAll(element.shuttleList);
    });
  }

  @override
  Widget build(BuildContext context) {
    moneyToPayCal();
    shuttleListToRcvCal();

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
                    CustomAppBar().appBar(context),
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
                                          height: 10.0,
                                        ),
                                        ItemCard('Unapproved',
                                            moneyToPay.toString() + ' \₩', [
                                          ClearAppTheme.orange,
                                          ClearAppTheme.pink
                                        ]),
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                        ItemCard(
                                            'List to rcv',
                                            shuttleListToRcv
                                                .toString()
                                                .replaceAll('[', '')
                                                .replaceAll(']', ''),
                                            [
                                              ClearAppTheme.blue,
                                              ClearAppTheme.darkBlue
                                            ]),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                      ],
                                    );
                                  }, childCount: 1),
                                ),
                                SliverPersistentHeader(
                                    pinned: true,
                                    floating: true,
                                    delegate: ContestTabHeader(_MyTabBar(
                                        tabController: _tabController,
                                        tabs: _tabs)))
                              ];
                            },
                            body: Container(
                              color: ClearAppTheme.buildLightTheme()
                                  .backgroundColor,
                              child: Text(''),
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
        padding: EdgeInsets.all(16.0),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
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
                  indicator: UnderlineTabIndicator(
                    borderSide: const BorderSide(
                      width: 5.0,
                      color: const Color.fromRGBO(86, 83, 195, 1.0),
                    ),
                    insets: const EdgeInsets.only(left: 50, right: 50),
                  ),
                  controller: _tabController,
                  tabs: _tabs.toList(),
                  labelColor: Colors.black,
                  labelPadding: EdgeInsets.all(0.0),
                  labelStyle: Theme.of(context).textTheme.bodyText1,
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
