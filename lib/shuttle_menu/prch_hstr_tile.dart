import 'package:clearApp/shuttle_menu/data_manage/shuttle_hitsory_handler.dart';
import 'package:clearApp/shuttle_menu/data_manage/shuttle_purchace_history.dart';
import 'package:clearApp/util/popup_widgets/popup_generator.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:clearApp/util/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PrchHstrTile extends StatefulWidget {
  final ShuttlePrchHstr prchHstr;
  final bool isAdminTab;

  const PrchHstrTile({Key key, this.prchHstr, this.isAdminTab})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PrchHstrTileState();
}

class PrchHstrTileState extends State<PrchHstrTile> {
  bool selected;
  bool dragToRemove;

  @override
  void initState() {
    super.initState();
    selected = false;
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.25,
      child: Row(
        children: <Widget>[
          SizedBox(width: 10),
          Expanded(
            child: ValueCard(
                widget.prchHstr.usage,
                widget.prchHstr.name,
                widget.prchHstr.price,
                widget.prchHstr.date,
                widget.prchHstr.shuttleList,
                widget.isAdminTab,
                widget.prchHstr.approved,
                widget.prchHstr.received),
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
                      ? () => Fluttertoast.showToast(
                          msg: "Already Approved!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xFFF45C43).withOpacity(1),
                          textColor: Colors.white,
                          fontSize: 13.0)
                      : () => PopupGenerator.remindPopupWidget(
                              context,
                              'REMIND',
                              'Are you sure about this?',
                              () => Navigator.pop(context), () {
                            ShuttlePrchHstrHandler()
                                .updateAppr(widget.prchHstr.key);
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: "Approved succesfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    ClearAppTheme.green.withOpacity(1),
                                textColor: Colors.white,
                                fontSize: 13.0);
                          }).show())
            ]
          : <Widget>[
              IconSlideAction(
                  caption: 'Received',
                  color: ClearAppTheme.darkBlue,
                  icon: Icons.check,
                  onTap: widget.prchHstr.received
                      ? () => Fluttertoast.showToast(
                          msg: "Already Received!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xFFF45C43).withOpacity(1),
                          textColor: Colors.white,
                          fontSize: 13.0)
                      : () => PopupGenerator.remindPopupWidget(
                              context,
                              'REMIND',
                              'Are you sure about this?',
                              () => Navigator.pop(context), () {
                            ShuttlePrchHstrHandler()
                                .updateRcved(widget.prchHstr.key);
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: "Received succesfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    ClearAppTheme.green.withOpacity(1),
                                textColor: Colors.white,
                                fontSize: 13.0);
                          }).show())
            ],
      secondaryActions: <Widget>[
        IconSlideAction(
            caption: 'Delete',
            color: ClearAppTheme.postechRed,
            icon: Icons.delete,
            onTap: () {
              //validate
              bool timeValidate =
                  DateTime.now().difference(widget.prchHstr.date).inMinutes <=
                      10;
              if (!widget.prchHstr.approved &&
                  !widget.prchHstr.received &&
                  timeValidate) {
                PopupGenerator.remindPopupWidget(
                    context,
                    'ALERT',
                    'Are you sure about this?',
                    () => Navigator.pop(context), () {
                  ShuttlePrchHstrHandler().deleteHstr(widget.prchHstr.key);
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                      msg: "Deleted succesfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: ClearAppTheme.green.withOpacity(1),
                      textColor: Colors.white,
                      fontSize: 13.0);
                }).show();
              } else {
                Fluttertoast.showToast(
                    msg: widget.prchHstr.approved
                        ? "Error: approved history"
                        : (widget.prchHstr.received
                            ? "Error: received history"
                            : "Error: timeout (10 min)"),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xFFF45C43).withOpacity(1),
                    textColor: Colors.white,
                    fontSize: 13.0);
              }
            })
      ],
    );
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
  ValueCard(this.usage, this.name, this.price, this.date, this.shuttleList,
      this.isAdminTab, this.approved, this.rcved);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  isAdminTab ? '$name: $usage' : usage,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.7)),
                ),
                Text(
                  price.toString() + ' \‎₩',
                  style: TextStyle(
                      color: approved
                          ? ClearAppTheme.darkBlue
                          : ClearAppTheme.pink,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      decoration: approved
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                )
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  formatDate(date, [mm, '-', dd, ' ', hh, ':', nn]),
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  shuttleList.toString(),
                  style: TextStyle(
                      color: rcved ? Colors.grey : Colors.orange,
                      decoration: rcved
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                )
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Divider()
          ],
        ));
  }
}
