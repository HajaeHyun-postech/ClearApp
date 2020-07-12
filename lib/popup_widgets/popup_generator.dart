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
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => SystemNavigator.pop(),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    );
  }

  static Alert loginErrorPopUp(BuildContext context) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(
        fontSize: 15,
        fontFamily: "Poppins-Medium",
      ),
      animationDuration: Duration(milliseconds: 200),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.red,
        fontFamily: "Poppins-Bold",
        fontSize: 20,
      ),
    );

    return new Alert(
      context: context,
      style: alertStyle,
      type: AlertType.info,
      title: "Login Failed",
      desc: "Please check your povis Id and student Id",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: "Poppins-Medium",
            ),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    );
  }
}
