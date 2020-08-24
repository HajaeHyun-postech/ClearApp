import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../vo/racket/racket.dart';
import '../../widget/app_theme.dart';
import 'package:clearApp/store/racket/racket_store.dart';
import '../../widget/toast_generator.dart';
import 'package:clearApp/store/racket/racket_form_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'racket_historylist.dart';
import 'package:clearApp/vo/racket_check_out_history/racket_check_out_history.dart';

class RentWindow extends StatefulWidget {
  final Function onSuccess;
  final Racket racketCard;
  final List<RacketCheckOutHistory> history;
  RentWindow(this.racketCard, {this.onSuccess, this.history});
  @override
  _RentWindowState createState() =>
      _RentWindowState(racketCard, history: history);
}

class _RentWindowState extends State<RentWindow> with TickerProviderStateMixin {
  final Racket racketCard;
  final List<RacketCheckOutHistory> history;
  _RentWindowState(this.racketCard, {this.history});
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

  void _checkOutRacket(int racketid) {
    setState(() {
      racketFormStore.checkOutRacket(racketid);
    });
  }

  void _checkInRacket(int racketid) {
    setState(() {
      racketFormStore.checkInRacket(racketid);
    });
  }

  bool amIrentingAvailable() {
    for (int i = 0; i < history.length; i++) {
      if (history[i].returnDate == null) {
        return false;
      }
    }
    return true;
  }

  bool isitMine() {
    for (int i = 0; i < history.length; i++) {
      if (history[i].returnDate == null) {
        if (history[i].racket.id == racketCard.id) return true;
      }
    }
    return false;
  }

  void situationFitFunction() {
    if (racketCard.available) {
      if (amIrentingAvailable()) {
        _checkOutRacket(racketCard.id);
      } else {
        return;
      }
    } else {
      if (isitMine()) {
        _checkInRacket(racketCard.id);
      } else {
        return;
      }
    }
  }

  Widget situationFitWidget() {
    if (racketCard.available) {
      if (amIrentingAvailable()) {
        return Container(
          width: ScreenUtil().setWidth(1200),
          height: ScreenUtil().setHeight(130),
          child: Center(
            child: Text(
              "Rent now",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: ScreenUtil().setSp(60),
                color: Color(0xFF837F76),
              ),
            ),
          ),
        );
      } else
        return Container(
          width: ScreenUtil().setWidth(1200),
          height: ScreenUtil().setHeight(130),
          child: Center(
            child: Text(
              "You are renting now",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: ScreenUtil().setSp(60),
                color: Color(0xFF837F76),
              ),
            ),
          ),
        );
    } else {
      if (isitMine()) {
        return Container(
          width: ScreenUtil().setWidth(1200),
          height: ScreenUtil().setHeight(130),
          child: Center(
            child: Text(
              "return now",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: ScreenUtil().setSp(60),
                color: Color(0xFF837F76),
              ),
            ),
          ),
        );
      } else
        return Container(
          width: ScreenUtil().setWidth(1200),
          height: ScreenUtil().setHeight(130),
          child: Center(
            child: Text(
              "It is already occupied",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: ScreenUtil().setSp(60),
                color: Color(0xFF837F76),
              ),
            ),
          ),
        );
    }
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
                        racketCard.asset,
                        width: ScreenUtil().setWidth(155),
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(30)),
                    Text('No.' + racketCard.id.toString(),
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
                    Text(racketCard.name,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(460),
                        child: Center(
                          child: Text(
                            racketCard.weight.toString() + 'U',
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
                            racketCard.type,
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
                            racketCard.balance.toString() + 'mm',
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
          Observer(builder: (_) {
            return InkWell(
              onTap: null,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color:
                      racketCard.available ? Color(0xFFF7F2E7) : Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: InkWell(
                  onTap: () => situationFitFunction(),
                  child: situationFitWidget(),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
