import 'dart:io';
import 'package:clearApp/store/login_store.dart';
import 'package:clearApp/widget/popup_generator.dart';
import 'package:clearApp/widget/toast_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'FormCard.dart';

class LoginScreenWithProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1440, height: 2560, allowFontScaling: true);
    return Provider<LoginStore>(
      create: (_) => LoginStore(),
      child: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
  }

  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: new Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 80.0, left: 90),
                  child: Image.asset("assets/images/badminton_play.png"),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 90.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: ScreenUtil().setHeight(550),
                    ),
                    FormCard(),
                    SizedBox(height: ScreenUtil().setHeight(50)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: ScreenUtil().setWidth(25),
                            ),
                            GestureDetector(
                              onTap: _radio,
                              child: radioButton(_isSelected),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(20),
                            ),
                            Text("Remember me",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(45),
                                    fontFamily: "Poppins-Medium"))
                          ],
                        ),
                        InkWell(
                          child: Container(
                            width: ScreenUtil().setWidth(400),
                            height: ScreenUtil().setHeight(150),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFF17ead9),
                                  Color(0xFF6078ea)
                                ]),
                                borderRadius: BorderRadius.circular(6.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFF6078ea).withOpacity(.3),
                                      offset: Offset(0.0, 8.0),
                                      blurRadius: 8.0)
                                ]),
                            child: Observer(builder: (_) {
                              final loginStore =
                                  Provider.of<LoginStore>(context);
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    if (!loginStore.loading) {
                                      loginStore.login();
                                    }
                                  },
                                  child: Center(
                                    child: !loginStore.loading
                                        ? new Text("SIGNIN",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w500,
                                              fontSize: ScreenUtil().setSp(55),
                                              letterSpacing: 1.0,
                                            ))
                                        : JumpingText('SIGNIN',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w500,
                                              fontSize: ScreenUtil().setSp(55),
                                              letterSpacing: 1.0,
                                            )),
                                  ),
                                ),
                              );
                            }),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      onWillPop: () {
        PopupGenerator.closingPopup(context).show();
      },
    );
  }
}
