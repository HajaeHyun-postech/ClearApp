import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../widget/app_theme.dart';

class HistoryTile extends StatefulWidget {
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final List<int> idList;
  final String title;
  final String name;
  final int price;
  final DateTime orderDate;
  final bool isConfirmed;
  final bool isReceived;
  final String firstActionCaption;
  final String secondActionCaption;
  final Function firstTapAction;
  final Function secondTapAction;

  const HistoryTile(
      {Key key,
      this.animationController,
      this.animation,
      this.idList,
      this.title,
      this.name,
      this.price,
      this.orderDate,
      this.isConfirmed,
      this.isReceived,
      this.firstActionCaption,
      this.secondActionCaption,
      this.firstTapAction,
      this.secondTapAction})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => HistoryTileState();
}

class HistoryTileState extends State<HistoryTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: widget.animation,
              child: Slidable(
                actionPane: SlidableScrollActionPane(),
                actionExtentRatio: 0.25,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: ScreenUtil().setWidth(60)),
                    Expanded(
                        child: ValueCard(
                            widget.title,
                            widget.name,
                            widget.price,
                            widget.orderDate,
                            widget.idList,
                            widget.isConfirmed,
                            widget.isReceived)),
                    SizedBox(width: ScreenUtil().setWidth(60)),
                  ],
                ),
                actions: <Widget>[
                  IconSlideAction(
                      caption: widget.firstActionCaption,
                      color: ClearAppTheme.darkBlue,
                      icon: Icons.check,
                      onTap: widget.firstTapAction)
                ],
                secondaryActions: <Widget>[
                  IconSlideAction(
                      caption: widget.secondActionCaption,
                      color: ClearAppTheme.postechRed,
                      icon: Icons.delete,
                      onTap: widget.secondTapAction)
                ],
              ));
        });
  }
}

class ValueCard extends StatelessWidget {
  final String title;
  final String name;
  final int price;
  final DateTime date;
  final List<int> idList;
  final bool isConfirmed;
  final bool isReceived;
  ValueCard(
    this.title,
    this.name,
    this.price,
    this.date,
    this.idList,
    this.isConfirmed,
    this.isReceived,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(35), vertical: 4.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(52),
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.7)),
                ),
                Text(
                  price.toString() + ' \‎₩',
                  style: TextStyle(
                      color: isConfirmed
                          ? ClearAppTheme.darkBlue
                          : ClearAppTheme.pink,
                      fontSize: ScreenUtil().setSp(52),
                      fontWeight: FontWeight.bold,
                      decoration: isConfirmed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                )
              ],
            ),
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  formatDate(date, [mm, '-', dd, ' ', hh, ':', nn]),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ScreenUtil().setSp(44),
                  ),
                ),
                Text(
                  idList.toString(),
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ScreenUtil().setSp(44),
                      color: isReceived
                          ? Colors.grey
                          : ClearAppTheme.orange.withAlpha(230),
                      decoration: isReceived
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                )
              ],
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Divider()
          ],
        ));
  }
}
