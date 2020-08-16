import 'package:flutter/material.dart';
import '../util/appbar.dart';
import '../util/toast_generator.dart';
import 'racket_cardlist.dart';
import 'racket_card.dart';
import '../util/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../util/toast_generator.dart';

class RacketmenuHomepage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: <Widget>[
            CustomAppBar(),
            RacketScrollView(),
        ],
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

  final ScrollController _scrollController = ScrollController();

  @override
  void initState(){
    super.initState();
    _scrollController.addListener(() {
      print('offset = ${_scrollController.offset}');
    }
    );
  }

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
        child:
         CustomScrollView(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          slivers: <Widget>[
            SliverList(delegate: SliverChildBuilderDelegate(
                  (context, index) => CustomFilter(),
                  childCount: 1,
                ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(0),
              sliver: SliverList(delegate: SliverChildBuilderDelegate(
                  (context, index) => RacketCardList(racketcardlist[index]),
                  childCount: racketcardlist.length,
              ),
            ),
            ),
          ],
        ),
      ),
      );
  }
}


class CustomFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: ClearAppTheme.white,
      child: Row(
      children: <Widget>[
        SizedBox(width: ScreenUtil().setWidth(70)),
          InkWell(
            borderRadius: const BorderRadius.all(
                      Radius.circular(2.0),
                    ),
            onTap: () { 
        }
        ,
            child:
            Padding(
              padding: EdgeInsets.symmetric(horizontal : ScreenUtil().setWidth(0), vertical: ScreenUtil().setHeight(5)),
              child:
                      Row(
                        children: <Widget>[
                          Text('Result',
                            style: TextStyle(
                              fontFamily: 'RobotoCondensed',
                              fontWeight: FontWeight.w600,
                              fontSize:14,
                            ),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(30)),
                          FaIcon(FontAwesomeIcons.caretDown, 
                              size: ScreenUtil().setWidth(45),
                              color: ClearAppTheme.darkBlue,
                              ),
                          ]
                      )
                  
              )

        )
      ]
    )
    );
  }
}

