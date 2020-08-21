import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../vo/racket/racket.dart';
import '../../widget/app_theme.dart';
import 'racket_card.dart';
import 'package:clearApp/store/racket/racket_store.dart';

class RentWindow extends StatefulWidget {
  final Racket racketCard;
  RentWindow(this.racketCard);
  @override
  _RentWindowState createState() => _RentWindowState(racketCard);
}

class _RentWindowState extends State<RentWindow> {
  final Racket racketCard;
  _RentWindowState(this.racketCard);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, //Color(0xFF9DAFAF),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(200),
                ScreenUtil().setHeight(70),
                ScreenUtil().setWidth(210),
                ScreenUtil().setHeight(0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(racketCard.name,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      letterSpacing: 0,
                      fontFamily: 'RobotoCondensed',
                      color: Color(0xFF837F76),
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().setSp(100),
                      //fontSize: 14,
                    )),
                ClipRRect(
                  //borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    racketCard.asset,
                    width: ScreenUtil().setWidth(155),
                    height: ScreenUtil().setHeight(155),
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(50)),
          Container(
            color: Colors.transparent,
            margin: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(70),
                ScreenUtil().setHeight(0),
                ScreenUtil().setWidth(70),
                ScreenUtil().setHeight(0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.weight,
                      size: ScreenUtil().setWidth(80),
                      color: Color(0xFFCECEB8),
                    ),
                    Text(
                      racketCard.weight.toString() + 'U',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: ScreenUtil().setSp(50),
                        color: Color(0xFF837F76),
                      ),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.balanceScale,
                      size: ScreenUtil().setWidth(80),
                      color: Color(0xFFCECEB8),
                    ),
                    Text(
                      racketCard.balance.toString(),
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: ScreenUtil().setSp(50),
                        color: Color(0xFF837F76),
                      ),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.list,
                      size: ScreenUtil().setWidth(80),
                      color: Color(0xFFCECEB8),
                    ),
                    Text(
                      racketCard.type,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: ScreenUtil().setSp(50),
                        color: Color(0xFF837F76),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
