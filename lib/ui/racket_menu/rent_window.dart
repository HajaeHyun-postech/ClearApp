import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../vo/racket/racket.dart';
import '../../widget/app_theme.dart';
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
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(180)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FaIcon(
                        FontAwesomeIcons.weightHanging,
                        size: ScreenUtil().setWidth(100),
                        color: Color(0xFFCECEB8),
                      ),
                      Image.asset(
                        "assets/images/racket_head.png",
                        height: ScreenUtil().setHeight(130),
                        //width: ScreenUtil().setWidth(200),
                        color: Color(0xFFCECEB8),
                      ),
                      FaIcon(
                        FontAwesomeIcons.balanceScale,
                        size: ScreenUtil().setWidth(100),
                        color: Color(0xFFCECEB8),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                Container(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(200),
                      right: ScreenUtil().setWidth(155)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        racketCard.weight.toString() + 'U',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: ScreenUtil().setSp(50),
                          color: Color(0xFF837F76),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: ScreenUtil().setWidth(36),
                          ),
                          Text(
                            racketCard.type,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: ScreenUtil().setSp(50),
                              color: Color(0xFF837F76),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            racketCard.balance.toString(),
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: ScreenUtil().setSp(50),
                              color: Color(0xFF837F76),
                            ),
                          ),
                          Text(
                            'mm',
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
          ),
          SizedBox(
            height: ScreenUtil().setHeight(80),
          ),
          InkWell(
            onTap: null,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFFF7F2E7),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
