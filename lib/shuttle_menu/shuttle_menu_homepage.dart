import 'package:clearApp/shuttle_menu/shuttle_history_homepage.dart';
import 'package:clearApp/shuttle_menu/shuttle_purchase_homepage.dart';
import 'package:flutter/material.dart';
import 'data_manage/shuttle_hitsory_subject.dart';
import 'package:provider/provider.dart';

class ShuttleMenuHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShuttlePrchHstrSubject>(
        create: (context) => ShuttlePrchHstrSubject(context),
        child: Scaffold(
            body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ShuttleHstrHomePage(),
            ShuttlePrchHomePage(),
          ],
        )));
  }
}
