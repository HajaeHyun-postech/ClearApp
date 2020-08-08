import 'package:flutter/material.dart';
import '../login/login_info.dart';

enum ShuttleMenuCurrentTab { Total, Not_Rcved, Admin }

class ShuttleTab {
  static List<Widget> getShuttleTab() {
    List<Widget> tab = new List<Widget>();
    tab.add(Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('TOTAL'),
      ),
    ));

    tab.add(Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('NOT RCVED'),
      ),
    ));

    if (LoginInfo().isAdmin) {
      tab.add(Tab(
        child: Align(
          alignment: Alignment.center,
          child: Text('ADMIN'),
        ),
      ));
    }

    return tab;
  }
}
