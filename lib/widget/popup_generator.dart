import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PopupGenerator {
  
  static Alert closingPopup(BuildContext context) {
    return new Alert(
      context: context,
      type: AlertType.warning,
      title: "ALERT",
      desc: "Program will be closed",
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => SystemNavigator.pop(),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    );
  }
  static Alert errorPopupWidget(BuildContext context, String title,
      String description, Function clickHandler) {
    var alertStyle = AlertStyle(
      titleStyle: TextStyle(
        color: Colors.red,
        fontFamily: "Roboto-Bold",
        fontSize: 20,
      ),
      descStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 15,
        fontFamily: "Roboto-Regular",
      ),
    );

    return new Alert(
      style: alertStyle,
      context: context,
      type: AlertType.error,
      title: title,
      desc: description,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: clickHandler,
          gradient:
              LinearGradient(colors: [Color(0xFFe53935), Color(0xFFe35d5b)]),
        )
      ],
    );
  }

  static Alert remindPopupWidget(BuildContext context, String title,
      String description, Function cancelCallback, Function okCallback) {
    return new Alert(
      context: context,
      type: AlertType.warning,
      title: title,
      desc: description,
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: cancelCallback,
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: okCallback,
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    );
  }
}
