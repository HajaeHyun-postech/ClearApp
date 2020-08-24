import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../store/racket/racket_form_store.dart';
import '../../vo/racket/racket.dart';
import '../../widget/toast_generator.dart';

class RentWindow extends StatefulWidget {
  final Racket racketCard;
  final Function onSuccess;
  final bool canCheckOut;
  final bool isUserUsing;
  final int historyId;
  RentWindow(this.racketCard,
      {this.onSuccess, this.canCheckOut, this.isUserUsing, this.historyId});
  @override
  _RentWindowState createState() => _RentWindowState();
}

class _RentWindowState extends State<RentWindow> with TickerProviderStateMixin {
  _RentWindowState();
  RacketFormStore racketFormStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    racketFormStore = Provider.of<RacketFormStore>(context);

    racketFormStore.disposers
      ..add(reaction((_) => racketFormStore.successStore.success, (success) {
        if (success) {
          widget.onSuccess();
          ToastGenerator.successToast(
              context, racketFormStore.successStore.successMessage);
          Navigator.of(context).pop();
        }
      }))
      ..add(reaction((_) => racketFormStore.errorStore.error, (error) {
        if (error) {
          ToastGenerator.errorToast(
              context, racketFormStore.errorStore.errorMessage);
        }
      }));
  }

  @override
  void dispose() {
    racketFormStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, //Color(0xFF9DAFAF),
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(70)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(130),
                ScreenUtil().setHeight(70),
                ScreenUtil().setWidth(130),
                ScreenUtil().setHeight(0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        widget.racketCard.asset,
                        width: ScreenUtil().setWidth(155),
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(30)),
                    Text('No.' + widget.racketCard.id.toString(),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          letterSpacing: 0,
                          fontFamily: 'RobotoCondensed',
                          color: Color(0xFF837F76),
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(75),
                          //fontSize: 14,
                        )),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(width: ScreenUtil().setWidth(56)),
                    Text(widget.racketCard.name,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          letterSpacing: 0,
                          fontFamily: 'RobotoCondensed',
                          color: Color(0xFF837F76),
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(80),
                          //fontSize: 14,
                        )),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(100)),
          Container(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(460),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.weightHanging,
                            size: 29,
                            color: Color(0xFFCECEB8),
                          ),
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(330),
                        child: Center(
                          child: Image.asset(
                            "assets/images/racket_head.png",
                            height: 35,
                            width: 29,
                            color: Color(0xFFCECEB8),
                          ),
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(460),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.balanceScale,
                            size: 29,
                            color: Color(0xFFCECEB8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(460),
                        child: Center(
                          child: Text(
                            widget.racketCard.weight.toString() + 'U',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: ScreenUtil().setSp(50),
                              color: Color(0xFF837F76),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(330),
                        child: Center(
                          child: Text(
                            widget.racketCard.type,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: ScreenUtil().setSp(50),
                              color: Color(0xFF837F76),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(460),
                        child: Center(
                          child: Text(
                            widget.racketCard.balance.toString() + 'mm',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: ScreenUtil().setSp(50),
                              color: Color(0xFF837F76),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(80),
          ),
          InkWell(
            onTap: null,
            child: DecoratedBox(
                decoration: BoxDecoration(
                  color: widget.isUserUsing
                      ? Color(0xFFCFCFC4)
                      : !widget.canCheckOut
                          ? Colors.transparent
                          : !widget.racketCard.available
                              ? Colors.transparent
                              : Color(0xFFCFCFC4),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: InkWell(
                  onTap: () => racketFormStore.adaptiveTapEvent(
                      widget.isUserUsing,
                      widget.canCheckOut,
                      widget.historyId,
                      widget.racketCard.id,
                      widget.racketCard.available),
                  child: Container(
                    width: ScreenUtil().setWidth(1200),
                    height: ScreenUtil().setHeight(130),
                    child: Center(
                      child: Text(
                        widget.isUserUsing
                            ? "Return"
                            : !widget.canCheckOut
                                ? " You can't rent more "
                                : !widget.racketCard.available
                                    ? "Occupied"
                                    : "Rent now",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(60),
                          color: widget.isUserUsing
                              ? Colors.white
                              : !widget.canCheckOut
                                  ? Color(0xFF808080)
                                  : !widget.racketCard.available
                                      ? Color(0xFFCFCFC4)
                                      : Colors.white,
                        ),
                      ),
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
