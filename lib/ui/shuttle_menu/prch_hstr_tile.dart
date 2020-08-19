import 'package:clearApp/ui/shuttle_menu/data_manage/shuttle_history_subject.dart';
import 'package:clearApp/ui/shuttle_menu/data_manage/shuttle_purchace_history.dart';
import 'package:clearApp/util/popup_generator.dart';
import 'package:clearApp/util/toast_generator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:clearApp/util/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'data_manage/events.dart';
import 'package:provider/provider.dart';

class PrchHstrTile extends StatefulWidget {
  final ShuttlePrchHstr prchHstr;
  final bool isAdminTab;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  const PrchHstrTile(
      {Key key,
      this.prchHstr,
      this.isAdminTab,
      this.animationController,
      this.animation})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PrchHstrTileState();
}

class PrchHstrTileState extends State<PrchHstrTile> {
  bool _isReceiving;
  bool _isDeleting;
  bool _isApproving;

  @override
  void initState() {
    super.initState();
    _isReceiving = false;
    _isDeleting = false;
    _isApproving = false;
  }

  @override
  Widget build(BuildContext context) {
    final shuttlePrchHstrSubject = Provider.of<ShuttlePrchHstrSubject>(context);

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
                      child: _isDeleting
                          ? GlowingProgressIndicator(
                              child: ValueCard(
                                  widget.prchHstr.usage,
                                  widget.prchHstr.name,
                                  widget.prchHstr.price,
                                  widget.prchHstr.date,
                                  widget.prchHstr.shuttleList,
                                  widget.isAdminTab,
                                  widget.prchHstr.approved,
                                  widget.prchHstr.received,
                                  _isReceiving,
                                  _isApproving),
                            )
                          : ValueCard(
                              widget.prchHstr.usage,
                              widget.prchHstr.name,
                              widget.prchHstr.price,
                              widget.prchHstr.date,
                              widget.prchHstr.shuttleList,
                              widget.isAdminTab,
                              widget.prchHstr.approved,
                              widget.prchHstr.received,
                              _isReceiving,
                              _isApproving),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                actions: widget.isAdminTab
                    ? <Widget>[
                        IconSlideAction(
                            caption: 'Approved',
                            color: ClearAppTheme.darkBlue,
                            icon: Icons.check,
                            onTap: widget.prchHstr.approved
                                ? () => Toast_generator.errorToast(
                                    context, 'Already Approved!')
                                : () => PopupGenerator.remindPopupWidget(
                                        context,
                                        'REMIND',
                                        'Are you sure about this?',
                                        () => Navigator.pop(context), () {
                                      setState(() => _isApproving = true);
                                      shuttlePrchHstrSubject
                                          .eventHandle(EVENT.UpdateApprEvent,
                                              key: widget.prchHstr.key)
                                          .then((_) => setState(
                                              () => _isApproving = false));
                                      Navigator.pop(context);
                                    }).show())
                      ]
                    : <Widget>[
                        IconSlideAction(
                            caption: 'Received',
                            color: ClearAppTheme.darkBlue,
                            icon: Icons.check,
                            onTap: widget.prchHstr.received
                                ? () => Toast_generator.errorToast(
                                    context, 'Already Received!')
                                : () => PopupGenerator.remindPopupWidget(
                                        context,
                                        'REMIND',
                                        'Are you sure about this?',
                                        () => Navigator.pop(context), () {
                                      setState(() => _isReceiving = true);
                                      shuttlePrchHstrSubject
                                          .eventHandle(EVENT.UpdateRcvedEvent,
                                              key: widget.prchHstr.key)
                                          .then((_) => setState(
                                              () => _isReceiving = false));
                                      Navigator.pop(context);
                                    }).show())
                      ],
                secondaryActions: <Widget>[
                  IconSlideAction(
                      caption: 'Delete',
                      color: ClearAppTheme.postechRed,
                      icon: Icons.delete,
                      onTap: () {
                        //validate
                        bool timeValidate = DateTime.now()
                                .difference(widget.prchHstr.date)
                                .inMinutes <=
                            10;
                        if (!widget.prchHstr.approved &&
                            !widget.prchHstr.received &&
                            timeValidate &&
                            !widget.isAdminTab) {
                          PopupGenerator.remindPopupWidget(
                              context,
                              'ALERT',
                              'Are you sure about this?',
                              () => Navigator.pop(context), () {
                            setState(() => _isDeleting = true);
                            shuttlePrchHstrSubject
                                .eventHandle(EVENT.DeleteHstrEvent,
                                    key: widget.prchHstr.key)
                                .then(
                                    (_) => setState(() => _isDeleting = false));
                            Navigator.pop(context);
                          }).show();
                        } else {
                          Toast_generator.errorToast(
                              context,
                              widget.prchHstr.approved
                                  ? "Error: approved history"
                                  : (widget.prchHstr.received
                                      ? "Error: received history"
                                      : (!timeValidate
                                          ? "Error: timeout (10 min)"
                                          : "Admin cannot remove history")));
                        }
                      })
                ],
              ));
        });
  }
}

class ValueCard extends StatelessWidget {
  final String usage;
  final String name;
  final int price;
  final DateTime date;
  final List<String> shuttleList;
  final bool isAdminTab;
  final bool approved;
  final bool rcved;
  final bool _isReceiving;
  final bool _isApproving;

  ValueCard(
      this.usage,
      this.name,
      this.price,
      this.date,
      this.shuttleList,
      this.isAdminTab,
      this.approved,
      this.rcved,
      this._isReceiving,
      this._isApproving);
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
                  isAdminTab ? '$name: $usage' : usage,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(55),
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.7)),
                ),
                _isApproving
                    ? JumpingText(price.toString() + ' \‎₩',
                        style: TextStyle(
                            color: approved
                                ? ClearAppTheme.darkBlue
                                : ClearAppTheme.pink,
                            fontSize: ScreenUtil().setSp(55),
                            fontWeight: FontWeight.bold,
                            decoration: approved
                                ? TextDecoration.lineThrough
                                : TextDecoration.none))
                    : Text(
                        price.toString() + ' \‎₩',
                        style: TextStyle(
                            color: approved
                                ? ClearAppTheme.darkBlue
                                : ClearAppTheme.pink,
                            fontSize: ScreenUtil().setSp(55),
                            fontWeight: FontWeight.bold,
                            decoration: approved
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
                _isReceiving
                    ? JumpingText(shuttleList.toString(),
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: ScreenUtil().setSp(44),
                            color: rcved
                                ? Colors.grey
                                : ClearAppTheme.orange.withAlpha(230),
                            decoration: rcved
                                ? TextDecoration.lineThrough
                                : TextDecoration.none))
                    : Text(
                        shuttleList.toString(),
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: ScreenUtil().setSp(44),
                            color: rcved
                                ? Colors.grey
                                : ClearAppTheme.orange.withAlpha(230),
                            decoration: rcved
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
