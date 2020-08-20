import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../widget/app_theme.dart';
import 'racket_card.dart';

class RentWindow extends StatefulWidget {
  final RacketCard racketCard;
  RentWindow(this.racketCard);
  @override
  _RentWindowState createState() => _RentWindowState(racketCard);
}

class _RentWindowState extends State<RentWindow> {
  final RacketCard racketCard;
  _RentWindowState(this.racketCard);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          color: Colors.white,
          margin: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(70),
              ScreenUtil().setHeight(0),
              ScreenUtil().setWidth(70),
              ScreenUtil().setHeight(0)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(racketCard.image,
                  width: ScreenUtil().setWidth(250),
                  height: ScreenUtil().setHeight(460)),
              SizedBox(width: ScreenUtil().setWidth(70)),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(racketCard.location,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  letterSpacing: 0,
                                  fontFamily: 'RobotoCondensed',
                                  color: Color(0xFF424242),
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtil().setSp(56),
                                  //fontSize: 14,
                                )),
                            Row(children: <Widget>[
                              !racketCard.isavailable
                                  ? FaIcon(FontAwesomeIcons.ban,
                                      size: ScreenUtil().setWidth(60),
                                      color: Color(0xFFFF84B1))
                                  : FaIcon(
                                      FontAwesomeIcons.checkCircle,
                                      size: ScreenUtil().setWidth(60),
                                      color: ClearAppTheme.green,
                                    ),
                              SizedBox(
                                width: ScreenUtil().setWidth(12),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(40),
                              ),
                            ])
                          ]),
                    ]),
              )
            ],
          ),
        ),
        Container(
          color: Colors.white,
          margin: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(70),
              ScreenUtil().setHeight(0),
              ScreenUtil().setWidth(70),
              ScreenUtil().setHeight(0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: ClearAppTheme.blue,
                ),
                child: FaIcon(
                  FontAwesomeIcons.weight,
                  size: ScreenUtil().setWidth(60),
                  color: Color(0xFF424242),
                ),
              ),
              FaIcon(
                FontAwesomeIcons.balanceScale,
                size: ScreenUtil().setWidth(60),
                color: Color(0xFF424242),
              ),
              FaIcon(
                FontAwesomeIcons.list,
                size: ScreenUtil().setWidth(60),
                color: Color(0xFF424242),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
