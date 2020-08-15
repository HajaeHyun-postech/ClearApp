import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../util/app_theme.dart';
import 'racket_card.dart';
import '../util/toast_generator.dart';
import '../navigation_home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 


class RacketCardList extends StatelessWidget {
  final RacketCard racketCard;
  final bool horizontal;
 
  RacketCardList(this.racketCard, {this.horizontal = true});
  
  @override
  Widget build(BuildContext context) {
    
    final RacketCardContent = Container(
      margin: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(70), ScreenUtil().setHeight(0), ScreenUtil().setWidth(70), ScreenUtil().setHeight(0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(racketCard.image, width: ScreenUtil().setWidth(250), height: ScreenUtil().setHeight(460)),
          SizedBox(width: ScreenUtil().setWidth(70)),
          Expanded(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                      Text(
                        racketCard.location, 
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          letterSpacing: 0,
                          fontFamily: 'RobotoCondensed',
                          color: Color(0xFF424242),
                          fontWeight: FontWeight.w600,
                          )
                      ),
                  Row(
                      children: <Widget>[
                        !racketCard.isavailable ?  
                          FaIcon(FontAwesomeIcons.ban, size : ScreenUtil().setWidth(60), color: Color(0xFFFF84B1)) :
                          FaIcon(FontAwesomeIcons.checkCircle, size : ScreenUtil().setWidth(60), color: ClearAppTheme.green,),
                          SizedBox(width: ScreenUtil().setWidth(12),),
                          SizedBox(width: ScreenUtil().setWidth(40),),
                      ]
                  )
                ]
              ),
              
              SizedBox(
                height: ScreenUtil().setHeight(50),
              ),
              Row(
                children: <Widget>[
                 FaIcon(FontAwesomeIcons.jira, size : ScreenUtil().setWidth(45), color: Color(0xFFCCCED1)),
                 SizedBox(width: ScreenUtil().setWidth(20)),
                        Text(
                    'No.'+racketCard.id, 
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      letterSpacing: 0,
                      fontFamily: 'RobotoCondensed',
                      color: Color(0xFF424242),
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      )
                    ),
                ],
              ),
            ]
          ), 
          )
        ],
      ),
    );
 
    final RacketCardf = Container(
      child: RacketCardContent,
      height: ScreenUtil().setHeight(340),
      decoration: BoxDecoration(
        color: ClearAppTheme.white,
        shape: BoxShape.rectangle,
      ),
    );
    return GestureDetector(
        onTap: racketCard.isavailable
            ? () => Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => NavigationHomeScreen() ,
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            FadeTransition(opacity: animation, child: child),
                  ),
                )
            : () => Toast_generator.errorToast(context, "It is already occupied"),
        child: Container(
          child: 
          Column(
           children: <Widget>[
            RacketCardf,
                Divider(
                  indent: ScreenUtil().setWidth(70),
                  endIndent: ScreenUtil().setWidth(70),
                  color: Color(0xFFF1F4F7),
                  thickness: ScreenUtil().setHeight(6),
              ),
            ]
          )
        )
    );
  }
}