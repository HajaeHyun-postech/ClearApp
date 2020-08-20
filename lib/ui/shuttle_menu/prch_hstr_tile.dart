import 'package:clearApp/store/shuttle/shuttle_store.dart';
import 'package:clearApp/widget/app_theme.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

class PrchHstrTile extends StatefulWidget {
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final List<int> idList;
  final String title;
  final String name;
  final int price;
  final DateTime orderDate;
  final bool depositConfirmed;
  final bool received;
  final String firstActionCaption;
  final String secondActionCaption;
  final Function firstTapAction;
  final Function secondTapAction;

  const PrchHstrTile(
      {Key key,
      this.animationController,
      this.animation,
      this.idList,
      this.title,
      this.name,
      this.price,
      this.orderDate,
      this.depositConfirmed,
      this.received,
      this.firstActionCaption,
      this.secondActionCaption,
      this.firstTapAction,
      this.secondTapAction})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PrchHstrTileState();
}

class PrchHstrTileState extends State<PrchHstrTile> {
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
                    SizedBox(width: 10),
                    Expanded(
                        child: ValueCard(
                            widget.title,
                            widget.name,
                            widget.price,
                            widget.orderDate,
                            widget.idList,
                            widget.depositConfirmed,
                            widget.received)),
                    SizedBox(width: 10),
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
  final bool depositConfirmed;
  final bool received;
  ValueCard(
    this.title,
    this.name,
    this.price,
    this.date,
    this.idList,
    this.depositConfirmed,
    this.received,
  );
  @override
  Widget build(BuildContext context) {
    final shuttleStore = Provider.of<ShuttleStore>(context);

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
                      fontSize: ScreenUtil().setSp(55),
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.7)),
                ),
                Observer(builder: (_) {
                  return shuttleStore.loading
                      ? JumpingText(price.toString() + ' \‎₩',
                          style: TextStyle(
                              color: depositConfirmed
                                  ? ClearAppTheme.darkBlue
                                  : ClearAppTheme.pink,
                              fontSize: ScreenUtil().setSp(55),
                              fontWeight: FontWeight.bold,
                              decoration: depositConfirmed
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none))
                      : Text(
                          price.toString() + ' \‎₩',
                          style: TextStyle(
                              color: depositConfirmed
                                  ? ClearAppTheme.darkBlue
                                  : ClearAppTheme.pink,
                              fontSize: ScreenUtil().setSp(55),
                              fontWeight: FontWeight.bold,
                              decoration: depositConfirmed
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        );
                })
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
                Observer(builder: (_) {
                  return shuttleStore.loading
                      ? JumpingText(idList.toString(),
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: ScreenUtil().setSp(44),
                              color: received
                                  ? Colors.grey
                                  : ClearAppTheme.orange.withAlpha(230),
                              decoration: received
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none))
                      : Text(
                          idList.toString(),
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: ScreenUtil().setSp(44),
                              color: received
                                  ? Colors.grey
                                  : ClearAppTheme.orange.withAlpha(230),
                              decoration: received
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        );
                }),
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
