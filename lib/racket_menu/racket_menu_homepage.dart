import 'package:flutter/material.dart';
import '../util/appbar.dart';
import 'racket_cardlist.dart';
import 'racket_card.dart';
import '../util/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class RacketmenuHomepage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: <Widget>[
          CustomAppBar(),
          RacketScrollView(),
        ]
      )
    );
  }
}

class RacketScrollView extends StatefulWidget{
    RacketScrollView({Key key}) : super(key: key);
    @override
    _RacketScrollView createState() => _RacketScrollView();
}

class _RacketScrollView extends State<RacketScrollView>{


  int return_available(){
    int count = 0;
    for(int i=0; i<racketcardlist.length; i++){
      if(racketcardlist[i].isavailable)
        count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context){
    return Expanded(
      child: Container(
        color: ClearAppTheme.buildLightTheme().backgroundColor,
        child:Column(
          children: <Widget>[
        SizedBox(
              height: ScreenUtil().setHeight(40),),
              Topcard(
                'Rentable Racket',
                 return_available().toString(),[
                     Color(0xFFBDC3C7).withAlpha(230),
                     Color(0xFFBDC3C7).withAlpha(230)
                     ]),
                       SizedBox(height: ScreenUtil().setHeight(40)),  
        Expanded(child:
         CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
             
            SliverPadding(
              padding: EdgeInsets.all(0),
              sliver: SliverFixedExtentList(
                itemExtent: ScreenUtil().setHeight(350),
                
                delegate: SliverChildBuilderDelegate(
                  (context, index) => RacketCardList(racketcardlist[index]),
                  childCount: racketcardlist.length,
                ),
                
              ),
            ),
          ],
        ),
            )
        ]
      ),
      ),
    );
  }
}

class Topcard extends StatelessWidget {
  final titel;
  final value;
  final colors;
  Topcard(this.titel, this.value, this.colors);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(50),
                    right: ScreenUtil().setWidth(50),
                    top: ScreenUtil().setHeight(50),
                    bottom: ScreenUtil().setHeight(50)),
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        offset: const Offset(0, 2),
                        blurRadius: 18.0)
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: colors),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          titel,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil().setSp(70)),
                        ),
                      ],
                    ),
                    Text(
                      value,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(80)),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(50),
            ),
            Container(
              decoration: BoxDecoration(
                color: //Color(0xFFD3CCE3),
                Color(0xFFBDC3C7),
                borderRadius: const BorderRadius.all(
                  Radius.circular(38.0),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      offset: const Offset(0, 2),
                      blurRadius: 9.0)
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  onTap: () => showBarModalBottomSheet(
                    expand: false,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context, scrollController) => Material(
                        child: CupertinoPageScaffold(
                      navigationBar: CupertinoNavigationBar(
                          leading: Container(),
                          middle: Text('Add Transaction')),
                      child: SafeArea(
                        bottom: false,
                        child: InkWell(
                          onTap: () => Navigator.popUntil(
                              context,
                              (route) =>
                                  route.settings.name ==
                                  '/homescreen/shuttlemenu'),
                        ),
                      ),
                    )),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(13),
                    child: /*Icon(FontAwesomeIcons.plus,
                        size: 16, color: ClearAppTheme.white),*/
                        Text('tip',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(80),
                          color: ClearAppTheme.white,
                        ),)
                    )
                   ),
              ),
            )
          ],
        ));
  }
}