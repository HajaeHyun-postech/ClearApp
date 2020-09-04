import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';

class PopupGenerator {
  static Future<bool> closingPopup(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Text("App Close"),
            content: new Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "Do you want to close the App?",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            actions: <Widget>[
              new CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('Cancel'),
              ),
              new CupertinoButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: new Text('OK')),
            ],
          );
        });
  }

  static Future<bool> errorPopupWidget(BuildContext context, String title,
      String description, Function clickHandler) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Row(children: <Widget>[
              FaIcon(FontAwesomeIcons.timesCircle, color: Colors.red, size: 15),
              SizedBox(width: 5),
              Text(title, style: TextStyle(color: Colors.red))
            ]),
            content: new Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                description,
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            actions: <Widget>[
              new CupertinoButton(
                  onPressed: () => clickHandler, child: new Text('OK')),
            ],
          );
        });
  }

  static Future<bool> remindPopupWidget(BuildContext context, String title,
      String description, Function cancelCallback, Function okCallback) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Row(children: <Widget>[
              Text(title, style: TextStyle(color: Colors.black))
            ]),
            content: new Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                description,
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            actions: <Widget>[
              new CupertinoButton(
                  onPressed: () => cancelCallback, child: new Text('Cancel')),
              new CupertinoButton(
                  onPressed: () => okCallback, child: new Text('OK')),
            ],
          );
        });
  }
}
