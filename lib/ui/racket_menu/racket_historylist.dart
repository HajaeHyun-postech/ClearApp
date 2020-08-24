import 'package:clearApp/store/racket/racket_store.dart';
import 'package:clearApp/vo/racket_check_out_history/racket_check_out_history.dart';
import 'package:clearApp/widget/toast_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../vo/racket/racket.dart';
import '../../widget/app_theme.dart';
import 'rent_window.dart';

class RacketHistoryList extends StatelessWidget {
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final RacketCheckOutHistory racketCard;
  final bool horizontal;

  RacketHistoryList(
      {this.racketCard,
      this.horizontal = true,
      this.animationController,
      this.animation});

  @override
  Widget build(BuildContext context) {
    final racketStore = Provider.of<RacketStore>(context);

    final racketCardContent = Container(
      margin: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(70),
          ScreenUtil().setHeight(0),
          ScreenUtil().setWidth(70),
          ScreenUtil().setHeight(0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(racketCard.racket.asset,
              width: ScreenUtil().setWidth(250),
              height: ScreenUtil().setHeight(460)),
          SizedBox(width: ScreenUtil().setWidth(70)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(racketCard.racket.name,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  letterSpacing: 0,
                                  fontFamily: 'RobotoCondensed',
                                  color: Color(0xFF424242),
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtil().setSp(56),
                                  //fontSize: 14,
                                )),
                          ]),
                      SizedBox(
                        height: ScreenUtil().setHeight(50),
                      ),
                      Row(
                        children: <Widget>[
                          FaIcon(FontAwesomeIcons.jira,
                              size: ScreenUtil().setWidth(45),
                              color: Color(0xFFCCCED1)),
                          SizedBox(width: ScreenUtil().setWidth(20)),
                          Text('No.' + racketCard.id.toString(),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                letterSpacing: 0,
                                fontFamily: 'RobotoCondensed',
                                color: Color(0xFF424242),
                                fontWeight: FontWeight.w600,
                                fontSize: ScreenUtil().setSp(44),
                              )),
                        ],
                      ),
                    ]),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        'From ' +
                            DateFormat('M/dd  kk:mm')
                                .format(racketCard.rentDate),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          letterSpacing: 0,
                          fontFamily: 'RobotoCondensed',
                          color: Color(0xFF424242),
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(56),
                          //fontSize: 14,
                        )),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    Text(
                        racketCard.returnDate == null
                            ? 'Until ' +
                                DateFormat('M/dd  kk:mm')
                                    .format(racketCard.dueDate)
                            : 'To ' +
                                DateFormat('M/dd  kk:mm')
                                    .format(racketCard.returnDate),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          letterSpacing: 0,
                          fontFamily: 'RobotoCondensed',
                          color: racketCard.returnDate == null
                              ? Color(0xFFFF6961)
                              : Color(0xFF424242),
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(56),
                          //fontSize: 14,
                        )),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );

    final racketCardf = Container(
      child: racketCardContent,
      height: ScreenUtil().setHeight(340),
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.rectangle,
      ),
    );

    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: animation,
              child: InkWell(
                  onTap: null,
                  child: Container(
                      color: Colors.transparent,
                      child: Column(children: <Widget>[
                        racketCardf,
                        Divider(
                          indent: ScreenUtil().setWidth(70),
                          endIndent: ScreenUtil().setWidth(70),
                          color: Color(0xFFF1F4F7),
                          thickness: ScreenUtil().setHeight(6),
                        ),
                      ]))));
        });
  }
}
