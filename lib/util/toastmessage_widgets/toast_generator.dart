import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

// ignore: camel_case_types
class Toast_generator {
  static void errorPopup(BuildContext context, String decs){
    showToast(
      decs,
      context: context,
      animation: StyledToastAnimation.slideFromBottom,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: 2),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
      backgroundColor: Color(0xFFF45C43).withOpacity(0.7),
      textStyle: TextStyle(
      fontSize: 13.0,
      fontFamily: 'Poppins',
      color: Color(0xFFFFFFFF),
      ),
      
    );
  }

    static void successPopup(BuildContext context, String decs){
    showToast(
      decs,
      context: context,
      animation: StyledToastAnimation.slideFromBottom,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: 2),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
      backgroundColor: ClearAppTheme.green.withOpacity(0.7),
      textStyle: TextStyle(
      fontSize: 13.0,
      fontFamily: 'Poppins',
      color: Color(0xFFFFFFFF),
      ),
      
    );
    }
    static void infoPopup(BuildContext context, String decs){
    showToast(
      decs,
      context: context,
      animation: StyledToastAnimation.slideFromBottom,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: 2),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
      backgroundColor: Color(0xFFF45C43).withOpacity(0.7), // TODO : fix color fit
      textStyle: TextStyle(
      fontSize: 13.0,
      fontFamily: 'Poppins',
      color: Color(0xFFFFFFFF),
      ),
      
    );
  }
}