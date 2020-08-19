import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../login/login_info.dart';

enum ShuttleMenuCurrentTab { Total, Not_Rcved, Admin }

class ShuttleTab {
  static List<Widget> getShuttleTab() {
    List<Widget> tab = new List<Widget>();
    tab.add(Tab(
      child: Align(
        alignment: Alignment.center,
        child:
            Text('TOTAL', style: TextStyle(fontSize: ScreenUtil().setSp(42))),
      ),
    ));

    tab.add(Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'NOT RCVED',
          style: TextStyle(fontSize: ScreenUtil().setSp(42)),
        ),
      ),
    ));

    if (LoginInfo().isAdmin) {
      tab.add(Tab(
        child: Align(
          alignment: Alignment.center,
          child:
              Text('ADMIN', style: TextStyle(fontSize: ScreenUtil().setSp(42))),
        ),
      ));
    }

    return tab;
  }
}
