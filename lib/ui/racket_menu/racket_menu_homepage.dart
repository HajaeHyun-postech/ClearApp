import 'package:clearApp/util/app_theme.dart';
import 'package:clearApp/util/appbar.dart';
import 'package:flutter/material.dart';
import 'racket_cardlist.dart';
import 'racket_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'custom_filter.dart';
import 'package:selection_menu/selection_menu.dart';

class RacketmenuHomepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        CustomAppBar(),
        RacketScrollView(),
      ],
    ));
  }
}

class RacketScrollView extends StatefulWidget {
  RacketScrollView({Key key}) : super(key: key);
  @override
  _RacketScrollView createState() => _RacketScrollView();
}

class _RacketScrollView extends State<RacketScrollView> {
  final ScrollController _scrollController = ScrollController();
  SelectionMenuController selectionMenuController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      //print('offset = ${_scrollController.offset}');
    });
    selectionMenuController = SelectionMenuController();
  }

  int return_available() {
    int count = 0;
    for (int i = 0; i < racketcardlist.length; i++) {
      if (racketcardlist[i].isavailable) count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: ClearAppTheme.buildLightTheme().backgroundColor,
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Row(children: <Widget>[
                  SizedBox(width: ScreenUtil().setWidth(70)),
                  CustomFilter(),
                ]),
                childCount: 1,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => RacketCardList(racketcardlist[index]),
                  childCount: racketcardlist.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
