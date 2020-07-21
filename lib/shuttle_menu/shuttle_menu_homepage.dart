import 'package:clearApp/shuttle_menu/shuttle_history_homepage.dart';
import 'package:clearApp/shuttle_menu/shuttle_purchase_homepage.dart';
import 'package:flutter/material.dart';
import 'data_manage/shuttle_hitsory_handler.dart';

class ShuttleMenuHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ShuttlePrchHstrHandler().initInstance(context);
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ShuttleHstrHomePage(),
        ShuttlePrchHomePage(),
      ],
    ));
  }
}
