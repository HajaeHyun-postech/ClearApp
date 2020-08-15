import 'package:flutter/material.dart';
import '../util/appbar.dart';
import '../util/toast_generator.dart';
import 'racket_cardlist.dart';
import 'racket_card.dart';
import '../util/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
            CustomAppBar(),/*
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child:
              Container(
                alignment: Alignment.centerRight,
                height: AppBar().preferredSize.height,
                child:
                Row(
                  mainAxisAlignment:MainAxisAlignment.end,
                  children: <Widget>[
                 Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    onTap: () {
                      Toast_generator.successToast(context, "Filter Test...");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: FaIcon(FontAwesomeIcons.search, size: ScreenUtil().setWidth(70)),
                    ),
                  ),
                ),
                  SizedBox(width: ScreenUtil().setWidth(30),),
                  ],
                ),
              ),
            ),*/
         
           
          
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
          slivers: <Widget>[
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