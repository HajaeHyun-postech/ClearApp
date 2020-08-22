import 'package:clearApp/widget/toast_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../vo/racket/racket.dart';
import '../../widget/app_theme.dart';
import 'rent_window.dart';

class RacketCardList extends StatelessWidget {
  final Racket racketCard;
  final bool horizontal;

  RacketCardList(this.racketCard, {this.horizontal = true});

  @override
  Widget build(BuildContext context) {
    final racketCardContent = Container(
      margin: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(70),
          ScreenUtil().setHeight(0),
          ScreenUtil().setWidth(70),
          ScreenUtil().setHeight(0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(racketCard.asset,
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
                        Text(racketCard.name,
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
                          !racketCard.available
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

    return InkWell(
        //TODO : error Toast 로직 store 로 옮겨!!!!
        onTap: racketCard.available
            ? () => showBarModalBottomSheet(
                  expand: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context, scrollController) => Material(
                      child: CupertinoPageScaffold(
                    child: SafeArea(
                      child: RentWindow(racketCard),
                    ),
                  )),
                )
            : () =>
                ToastGenerator.errorToast(context, "It is already occupied"),
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
            ])));
  }
}
