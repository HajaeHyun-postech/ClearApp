import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../store/racket/racket_form_store.dart';
import '../../vo/racket/racket.dart';
import '../../widget/toast_generator.dart';

class BorrowForm extends StatefulWidget {
  final Racket racket;
  final Function onSuccess;

  BorrowForm(this.racket, {this.onSuccess});
  @override
  _BorrowFormState createState() => _BorrowFormState();
}

class _BorrowFormState extends State<BorrowForm> with TickerProviderStateMixin {
  RacketFormStore racketFormStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    racketFormStore = Provider.of<RacketFormStore>(context);

    racketFormStore.disposers
      ..add(reaction((_) => racketFormStore.successStore.success, (success) {
        if (success) {
          widget.onSuccess();
          Navigator.of(context).pop();
        }
      }));
  }

  @override
  void dispose() {
    racketFormStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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
                        widget.racket.asset,
                        width: ScreenUtil().setWidth(155),
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(30)),
                    Text('No.' + widget.racket.id.toString(),
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
                    Text(widget.racket.name,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(460),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.weightHanging,
                            size: 29,
                            color: Color(0xFFCECEB8),
                          ),
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(330),
                        child: Center(
                          child: Image.asset(
                            "assets/images/racket_head.png",
                            height: 35,
                            width: 29,
                            color: Color(0xFFCECEB8),
                          ),
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(460),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.balanceScale,
                            size: 29,
                            color: Color(0xFFCECEB8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(460),
                        child: Center(
                          child: Text(
                            widget.racket.weight.toString() + 'U',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: ScreenUtil().setSp(50),
                              color: Color(0xFF837F76),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(330),
                        child: Center(
                          child: Text(
                            widget.racket.type,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: ScreenUtil().setSp(50),
                              color: Color(0xFF837F76),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(460),
                        child: Center(
                          child: Text(
                            widget.racket.balance.toString() + 'mm',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: ScreenUtil().setSp(50),
                              color: Color(0xFF837F76),
                            ),
                          ),
                        ),
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
                  color: racketFormStore.buttonColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: InkWell(
                  onTap: () => racketFormStore.buttonTapEvent(widget.racket.id),
                  child: Container(
                    width: ScreenUtil().setWidth(1200),
                    height: ScreenUtil().setHeight(130),
                    child: Center(
                      child: Text(
                        racketFormStore.buttonText,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(60),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
