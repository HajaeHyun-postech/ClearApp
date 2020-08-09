import 'package:flutter/material.dart';
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
          ScreenUtil().setWidth(30), ScreenUtil().setHeight(0), ScreenUtil().setWidth(70), ScreenUtil().setHeight(0)),
      constraints: BoxConstraints.expand(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Stack(
          alignment: Alignment.center,
          
          children: <Widget>[
                  Container(
                      height: ScreenUtil().setHeight(200),
                    width: ScreenUtil().setWidth(200),
                      decoration: BoxDecoration(
                          color: ClearAppTheme.nearlyWhite,
                    shape: BoxShape.circle,
                      )
                  ),
                  
                  Container(
                      height: ScreenUtil().setHeight(187),
                    width: ScreenUtil().setWidth(187),
                      decoration: BoxDecoration(
                    color: ClearAppTheme.nearlyWhite,
                    shape: BoxShape.circle,      
                      )
                  ),
                  
                Text(
                  racketCard.id,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w100,
                      color: ClearAppTheme.darkerText,
                      fontSize: 24,
                    )               
                ),
                  
          ]
          ),
          SizedBox(width: ScreenUtil().setWidth(30)),
        new SizedBox(
          width: ScreenUtil().setWidth(10),
              child: new Center(
                child: new Container(
                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                  height: ScreenUtil().setHeight(200),
                  color: Colors.black,
                ),
            ),
              ),
          SizedBox(width: ScreenUtil().setWidth(70)),
          Image.asset(racketCard.image, width: ScreenUtil().setWidth(400), height: ScreenUtil().setHeight(200)),
          Expanded(
            child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              
              Text(racketCard.location, 
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w100,
                decoration: racketCard.isavailable ? TextDecoration.none : TextDecoration.lineThrough,
                fontSize: 15,
              )),
              
              Text(
                racketCard.isavailable ? 'Availabe' : 'Occupied',
                textAlign: TextAlign.end,
                style: TextStyle(
                fontWeight: FontWeight.w100,
                color: racketCard.isavailable ? ClearAppTheme.green : Color(0xFFDD5E89),
                fontSize: 15,
                )
              ),
            ]
          ),  
          )
          
        ],
      ),
    );
 
    final RacketCardf = Container(
      child: RacketCardContent,
      height: ScreenUtil().setHeight(270),
      margin:
          EdgeInsets.only(left: ScreenUtil().setWidth(30)),
      decoration: BoxDecoration(
        color: ClearAppTheme.nearlyWhite,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 18.0,
            offset: Offset(-10, 10.0),
          ),
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
          margin: EdgeInsets.only(
            top: ScreenUtil().setHeight(70),
            left: ScreenUtil().setWidth(0),
            right: ScreenUtil().setWidth(30),
          ),
          child: Stack(
            children: <Widget>[
              RacketCardf,
            ],
          ),
        ));
  }
}