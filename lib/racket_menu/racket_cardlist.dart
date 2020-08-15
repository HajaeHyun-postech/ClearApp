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
      //constraints: BoxConstraints.expand(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(racketCard.image, width: ScreenUtil().setWidth(270), height: ScreenUtil().setHeight(480)),
          SizedBox(width: ScreenUtil().setWidth(90)),
          Expanded(
            child:
            
          Column(
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
                fontWeight: FontWeight.w500,
                decoration: racketCard.isavailable ? TextDecoration.none : TextDecoration.lineThrough,
                fontSize: 13,
              )),
              Row(
                children: <Widget>[
              Text(
             'No.'+racketCard.id, 
              textAlign: TextAlign.end,
              style: TextStyle(
                letterSpacing: 0,
                fontFamily: 'RobotoCondensed',
                color: Color(0xFF424242),
                fontWeight: FontWeight.w600,
                fontSize: 11,
              )),
              SizedBox(width: ScreenUtil().setWidth(40),),
                ]
              )
             // SizedBox(width: ScreenUtil().setWidth(10)),
          
              ]
              ),
              
              SizedBox(
                height: ScreenUtil().setHeight(50),
              ),
              Row(
                children: <Widget>[
                  FaIcon(FontAwesomeIcons.infoCircle, size : ScreenUtil().setWidth(52), color: Color(0xFFF3F781),),
                  SizedBox(width: ScreenUtil().setWidth(12),),
              Text(
                racketCard.isavailable ? 'Availabe' : 'Occupied',
                textAlign: TextAlign.end,
                style: TextStyle(
                fontFamily: 'Alata',
                fontWeight: FontWeight.w300,
                color: racketCard.isavailable ? ClearAppTheme.green : Color(0xFFFF84B1),
                fontSize: 11.5,
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
       //margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
      decoration: BoxDecoration(
        color: ClearAppTheme.nearlyWhite,
        shape: BoxShape.rectangle,
        //borderRadius: BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          /*BoxShadow(
            color: Colors.black12,
            blurRadius: 18.0,
            offset: Offset(-10, 10.0),
          ),*/
        ],
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
           
        ));
  }
}