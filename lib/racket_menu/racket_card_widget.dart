import 'package:flutter/material.dart';
import '../util/app_theme.dart';


void main(){
  runApp(TestMain());
  return;
}

class TestMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RacketCard(),
    );
  }
}

class RacketCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(50, 50, 50, 50),
      child: Text(
        "HI",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          fontFamily: 'Poppins',
        )
      ),
    );
  }
}